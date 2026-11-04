// FILE: lib/features/class/presentation/widgets/my_classes_sheet.dart
//
// TUGAS: modal "Daftar Kelas Saya" siswa (Minggu 10 lanjutan) — daftar
// rombel tempat siswa tergabung dari GET /classes/my. Tiap baris membuka
// StudentClassDetailSheet; bila daftar kosong tersedia tombol Gabung Kelas
// yang hasilnya dikembalikan ke pemanggil (null = tidak minta gabung).
//
// Catatan aturan backend: satu siswa hanya boleh tergabung di satu kelas
// aktif, jadi daftar ini umumnya berisi satu baris. Struktur tetap dibuat
// sebagai daftar agar tidak perlu ditulis ulang bila aturan berubah.
//
// WAJIB DIUBAH BILA: backend mengizinkan multi-kelas — tambahkan aksi
// "Gabung Kelas Lain" di bagian bawah daftar.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/class_exceptions.dart';
import '../../domain/class_repository.dart';
import 'class_sheet_shell.dart';
import 'student_class_detail_sheet.dart';

/// Hasil `true` = siswa menekan "Gabung Kelas"; null = hanya menutup sheet.
Future<bool?> showMyClassesSheet(BuildContext context) =>
    showClassSheet<bool>(context, builder: (_) => const _MyClassesSheet());

enum _SheetPhase { loading, ready, error }

class _MyClassesSheet extends StatefulWidget {
  const _MyClassesSheet();

  @override
  State<_MyClassesSheet> createState() => _MyClassesSheetState();
}

class _MyClassesSheetState extends State<_MyClassesSheet> {
  late final ClassRepository _repo = context.read<ClassRepository>();

  _SheetPhase _phase = _SheetPhase.loading;
  String _errorMessage = '';
  List<ClassInfo> _classes = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _phase = _SheetPhase.loading);
    try {
      final items = await _repo.myClasses();
      if (!mounted) return;
      setState(() {
        _classes = items;
        _phase = _SheetPhase.ready;
      });
    } on ApiClassException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _phase = _SheetPhase.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context).classServerUnreachable;
        _phase = _SheetPhase.error;
      });
    }
  }

  Future<void> _openDetail(ClassInfo info) async {
    final left = await showStudentClassDetailSheet(context, classId: info.id);
    if (!mounted) return;
    if (left == true) {
      showAppSnack(context, AppLocalizations.of(context).classLeftSnack(info.name));
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final count = _classes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.primaryContainer,
                shape: BoxShape.circle,
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
                  Text(
                    l10n.myClassesTitle,
                    style: AppTypography.titleM.copyWith(
                      color: p.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _phase == _SheetPhase.ready && count > 0
                        ? l10n.myClassesActiveCount(count)
                        : l10n.myClassesSubtitle,
                    style: AppTypography.caption.copyWith(color: p.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        switch (_phase) {
          _SheetPhase.loading => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
          _SheetPhase.error => _ErrorBox(
            message: _errorMessage,
            onRetry: _load,
          ),
          _SheetPhase.ready when count == 0 => const _EmptyBox(),
          _SheetPhase.ready => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final info in _classes)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _ClassRow(info: info, onTap: () => _openDetail(info)),
                ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.myClassesOneActiveNote,
                style: AppTypography.caption.copyWith(color: p.textMuted),
              ),
            ],
          ),
        },
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: _phase == _SheetPhase.ready && count == 0
              ? l10n.classJoinButton
              : l10n.actionClose,
          leadingIcon: _phase == _SheetPhase.ready && count == 0
              ? Icons.login_rounded
              : null,
          kind: _phase == _SheetPhase.ready && count == 0
              ? AppButtonKind.primary
              : AppButtonKind.secondary,
          onPressed: () {
            if (_phase == _SheetPhase.ready && count == 0) {
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _ClassRow extends StatelessWidget {
  const _ClassRow({required this.info, required this.onTap});

  final ClassInfo info;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: p.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.input),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.school_rounded, color: p.primary, size: 20),
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
                            color: p.surface,
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
              Icon(Icons.chevron_right_rounded, color: p.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Column(
        children: [
          Icon(Icons.meeting_room_outlined, size: 36, color: p.textMuted),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.myClassesEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTypography.label.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.myClassesEmptyBody,
            textAlign: TextAlign.center,
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 32, color: p.error),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.classLoadFailedTitle,
            style: AppTypography.label.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l10n.dashRetryButton),
          ),
        ],
      ),
    );
  }
}
