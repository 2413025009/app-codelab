// FILE: lib/features/class/presentation/widgets/my_class_section.dart
//
// TUGAS: seksi "Kelas & Rombel" di halaman Profil siswa (TODO Minggu 10):
// saat belum tergabung → tombol "Gabung Kelas" membuka JoinClassSheet;
// saat sudah tergabung → kartu kelas aktif yang dibuka memunculkan
// StudentClassDetailSheet (info guru, teman sekelas, keluar kelas).
//
// Data 100% dari backend (GET /classes/my); gagal muat ditampilkan jujur
// dengan tombol coba lagi — tidak ada kelas tiruan.
//
// WAJIB DIUBAH BILA: badge rombel dipasang di Dashboard siswa (minggu 10+
// lanjutan) — bawa data via repository yang sama.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../domain/class_repository.dart';
import 'join_class_sheet.dart';
import 'student_class_detail_sheet.dart';

/// Kartu kelas aktif siswa — disisipkan di halaman Profil (tab 3).
class MyClassSection extends StatefulWidget {
  const MyClassSection({super.key});

  @override
  State<MyClassSection> createState() => _MyClassSectionState();
}

class _MyClassSectionState extends State<MyClassSection> {
  bool _loading = true;
  bool _failed = false;
  List<ClassInfo> _classes = const [];

  /// Kunci reentry: dua muatan serentak (buka tab + refresh senyap) jangan
  /// saling menimpa hingga pil memutar selamanya.
  bool _inflight = false;

  @override
  void initState() {
    super.initState();
    appShellTabActivated.addListener(_handleTabActivated);
  }

  @override
  void dispose() {
    appShellTabActivated.removeListener(_handleTabActivated);
    super.dispose();
  }

  /// Tab profil kembali diaktifkan → segarkan senyap (IndexedStack
  /// menjaga widget hidup; data kelas ikut segar tanpa refresh manual).
  void _handleTabActivated() {
    if (appShellTabActivated.value == 3) _load();
  }

  Future<void> _load() async {
    if (!mounted || _inflight) return;
    _inflight = true;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final repo = context.read<ClassRepository>();
      final items = await repo.myClasses();
      if (!mounted) return;
      setState(() {
        _classes = items;
        _loading = false;
      });
      debugPrint('MyClassSection: kelas dimuat (${items.length} item)');
    } catch (e) {
      // Kegagalan TIDAK lagi ditelan gelap — lempar keterangannya ke
      // konsol supaya penyebab "berputar terus" terbaca jujur di layar.
      debugPrint('MyClassSection.load gagal: $e');
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    } finally {
      _inflight = false;
    }
  }

  /// Buka lembar gabung; bila sukses → snack + muat ulang seksi.
  Future<void> _openJoin() async {
    final name = await showJoinClassSheet(context);
    if (name == null) return;
    if (!mounted) return;
    showAppSnack(context, 'Berhasil bergabung ke kelas $name!');
    _load();
  }

  /// Buka lembar detail/keluar; `true` berarti siswa keluar dari kelas.
  Future<void> _openDetail(ClassInfo info) async {
    final left = await showStudentClassDetailSheet(context, classId: info.id);
    if (left != true) return;
    if (!mounted) return;
    showAppSnack(context, 'Kamu keluar dari kelas ${info.name}.');
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kelas Belajar',
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_loading)
          const AppCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
          )
        else if (_classes.isEmpty)
          // Santai dua wujud: gagal memuat vs memang belum tergabung.
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _failed
                ? Column(
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 34,
                        color: p.textMuted,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Kelas gagal dimuat dari server',
                        style: AppTypography.label.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Cek koneksi lab sekolahmu, lalu coba lagi.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Coba lagi'),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: p.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.meeting_room_rounded,
                          color: p.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Belum tergabung ke kelas',
                        style: AppTypography.label.copyWith(
                          color: p.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Masukkan kode kelas 6 karakter yang dibagikan gurumu.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: 'Gabung Kelas',
                        leadingIcon: Icons.login_rounded,
                        expand: false,
                        onPressed: _openJoin,
                      ),
                    ],
                  ),
          )
        else
          // Kelas aktif: satu kelas per siswa (aturan minggu 10).
          for (final info in _classes)
            AppCard(
              padding: EdgeInsets.zero,
              child: InkWell(
                borderRadius: AppRadius.cardBorder,
                onTap: () => _openDetail(info),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: p.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.meeting_room_rounded,
                          color: p.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    info.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.label.copyWith(
                                      color: p.text,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p.surfaceAlt,
                                    borderRadius: AppRadius.pillBorder,
                                  ),
                                  child: Text(
                                    info.classCode,
                                    style: AppTypography.code.copyWith(
                                      color: p.textMuted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              [
                                if (info.teacherName.isNotEmpty)
                                  info.teacherName,
                                '${info.memberCount} teman sekelas',
                              ].join(' • '),
                              style: AppTypography.caption.copyWith(
                                color: p.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(Icons.chevron_right_rounded, color: p.textMuted),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
