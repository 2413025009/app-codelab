// FILE: lib/features/class/presentation/widgets/class_status_card.dart
//
// TUGAS: seksi KECIL kelas di Dashboard siswa (Minggu 10 lanjutan):
// - sedang tergabung  → satu kartu ringkas berisi nama kelas, guru, jumlah
//   teman, dan kode kelas; diketuk membuka StudentClassDetailSheet.
// - belum tergabung   → ajakan "Gabung Kelas" yang membuka JoinClassSheet.
//
// Data 100% dari backend (GET /classes/my) dan disegarkan senyap setiap tab
// Dashboard diaktifkan kembali — tidak ada kelas tiruan.
//
// WAJIB DIUBAH BILA: aturan "satu kelas aktif per siswa" dilonggarkan —
// ganti kartu tunggal ini dengan daftar (lihat MyClassesSheet).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../domain/class_repository.dart';
import 'join_class_sheet.dart';
import 'my_classes_sheet.dart';
import 'student_class_detail_sheet.dart';

class ClassStatusCard extends StatefulWidget {
  const ClassStatusCard({super.key});

  @override
  State<ClassStatusCard> createState() => _ClassStatusCardState();
}

class _ClassStatusCardState extends State<ClassStatusCard> {
  bool _loading = true;
  bool _failed = false;
  List<ClassInfo> _classes = const [];

  /// Kunci reentry: muatan tab + refresh tidak saling menimpa.
  bool _inflight = false;

  @override
  void initState() {
    super.initState();
    appShellTabActivated.addListener(_handleTabActivated);
    // Muat pertama: dashboard dibangun saat app start tanpa event tab.
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    appShellTabActivated.removeListener(_handleTabActivated);
    super.dispose();
  }

  void _handleTabActivated() {
    if (appShellTabActivated.value == 0) _load();
  }

  Future<void> _load() async {
    if (!mounted || _inflight) return;
    _inflight = true;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final items = await context.read<ClassRepository>().myClasses();
      if (!mounted) return;
      setState(() {
        _classes = items;
        _loading = false;
      });
    } catch (e) {
      debugPrint('ClassStatusCard.load gagal: $e');
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    } finally {
      _inflight = false;
    }
  }

  Future<void> _openJoin() async {
    final name = await showJoinClassSheet(context);
    if (name == null || !mounted) return;
    showAppSnack(context, 'Berhasil bergabung ke kelas $name!');
    _load();
  }

  Future<void> _openDetail(ClassInfo info) async {
    final left = await showStudentClassDetailSheet(context, classId: info.id);
    if (left != true || !mounted) return;
    showAppSnack(context, 'Kamu keluar dari kelas ${info.name}.');
    _load();
  }

  Future<void> _openAllClasses() async {
    final wantsJoin = await showMyClassesSheet(context);
    if (!mounted) return;
    if (wantsJoin == true) {
      await _openJoin();
      return;
    }
    // Daftar bisa berubah karena siswa keluar dari kelas di dalamnya.
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    if (_loading) {
      return AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Memuat kelas…',
              style: AppTypography.bodyM.copyWith(color: p.textMuted),
            ),
          ],
        ),
      );
    }

    if (_failed) {
      return AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, size: 20, color: p.textMuted),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Kelas gagal dimuat dari server',
                style: AppTypography.bodyM.copyWith(color: p.textMuted),
              ),
            ),
            TextButton(onPressed: _load, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (_classes.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: p.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.meeting_room_rounded,
                color: p.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belum masuk kelas',
                    style: AppTypography.label.copyWith(
                      color: p.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gabung pakai kode 6 karakter dari gurumu.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(color: p.textMuted),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: _openJoin,
              child: Text(
                'Gabung',
                style: AppTypography.label.copyWith(
                  color: p.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Aturan minggu 10: satu kelas aktif per siswa. Kartu tetap menyediakan
    // pintu ke lembar daftar agar struktur siap bila aturan itu berubah.
    final info = _classes.first;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => _openDetail(info),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: p.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.meeting_room_rounded, color: p.primary, size: 20),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label.copyWith(
                          color: p.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: p.successContainer,
                        borderRadius: AppRadius.pillBorder,
                      ),
                      child: Text(
                        'Aktif',
                        style: AppTypography.caption.copyWith(
                          color: p.success,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (info.teacherName.isNotEmpty) info.teacherName,
                    '${info.memberCount} teman sekelas',
                  ].join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: p.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            tooltip: 'Lihat semua kelas',
            onPressed: _openAllClasses,
            icon: Icon(Icons.chevron_right_rounded, color: p.textMuted),
          ),
        ],
      ),
    );
  }
}
