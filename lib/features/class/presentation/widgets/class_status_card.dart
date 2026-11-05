// FILE: lib/features/class/presentation/widgets/class_status_card.dart
//
// TUGAS: seksi KECIL kelas di Dashboard siswa (Minggu 10 lanjutan):
// - sedang tergabung  → satu kartu ringkas berisi kelas UTAMA (paling baru
//   diikuti — backend mengurutkan joined_at DESC), guru, dan jumlah teman;
//   diketuk membuka StudentClassDetailSheet kelas tersebut.
// - multi-kelas       → chip "{n} kelas" di kanan membuka MyClassesSheet
//   (daftar SEMUA kelas + aksi "Gabung Kelas Lain"), supaya dashboard tetap
//   ringkas dan tidak menumpuk kartu kelas.
// - belum tergabung   → ajakan "Gabung Kelas" yang membuka JoinClassSheet.
//
// Data 100% dari backend (GET /classes/my) dan disegarkan senyap setiap tab
// Dashboard diaktifkan kembali — tidak ada kelas tiruan.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/app_localizations.dart';
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
    showAppSnack(context, AppLocalizations.of(context).classJoinedSnack(name));
    _load();
  }

  Future<void> _openDetail(ClassInfo info) async {
    final left = await showStudentClassDetailSheet(context, classId: info.id);
    if (left != true || !mounted) return;
    showAppSnack(context, AppLocalizations.of(context).classLeftSnack(info.name));
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
    final l10n = AppLocalizations.of(context);

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
              l10n.classLoadingInline,
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
                l10n.classLoadFailedFromServer,
                style: AppTypography.bodyM.copyWith(color: p.textMuted),
              ),
            ),
            TextButton(onPressed: _load, child: Text(l10n.dashRetryButton)),
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
                    l10n.classNotInClassTitle,
                    style: AppTypography.label.copyWith(
                      color: p.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.classJoinHintShort,
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
                l10n.classJoinShort,
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

    // Multi-kelas: kartu menampilkan kelas UTAMA (paling baru diikuti —
    // urutan GET /classes/my adalah joined_at DESC). Kelas lain tetap
    // terjangkau lewat chip jumlah di kanan → MyClassesSheet.
    final info = _classes.first;
    final classCount = _classes.length;
    final hasMultipleClasses = classCount > 1;
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
                    // Badge "Aktif" hanya bermakna saat siswa punya satu
                    // kelas. Saat multi-kelas, jumlahnya diwakili chip di
                    // sisi kanan agar tidak ada dua pesan yang bersaing.
                    if (!hasMultipleClasses) ...[
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
                          l10n.classActiveBadge,
                          style: AppTypography.caption.copyWith(
                            color: p.success,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (info.teacherName.isNotEmpty) info.teacherName,
                    l10n.classMemberCountInline(info.memberCount),
                  ].join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: p.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          // Satu elemen untuk dua pesan: "ada berapa kelas" sekaligus pintu
          // ke daftar lengkap. Saat hanya satu kelas, cukup panah biasa.
          if (hasMultipleClasses)
            Tooltip(
              message: l10n.classSeeAllTooltip,
              child: TextButton(
                onPressed: _openAllClasses,
                style: TextButton.styleFrom(
                  foregroundColor: p.primary,
                  backgroundColor: p.primaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  minimumSize: const Size(0, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.classCountBadge(classCount),
                      style: AppTypography.caption.copyWith(
                        color: p.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: p.primary,
                    ),
                  ],
                ),
              ),
            )
          else
            IconButton(
              tooltip: l10n.classSeeAllTooltip,
              onPressed: _openAllClasses,
              icon: Icon(Icons.chevron_right_rounded, color: p.textMuted),
            ),
        ],
      ),
    );
  }
}
