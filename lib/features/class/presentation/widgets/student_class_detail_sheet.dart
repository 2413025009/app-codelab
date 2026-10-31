// FILE: lib/features/class/presentation/widgets/student_class_detail_sheet.dart
//
// TUGAS: modal "Detail Rombel Siswa & Keluar Kelas" (PROMPT.md Bagian 2 +
// Stitch v3 modal_detail_rombel_siswa_keluar_kelas): kartu kelas, guru
// pembimbing dengan lencana verifikasi, tumpukan avatar teman sekelas,
// keterangan pemantauan di lab, salin info rombel, dan aksi keluar dengan
// konfirmasi (playAlertWarning saat dialog peringatan dibuka per TODO W10).
//
// WAJIB DIUBAH BILA: profil avatar siswa/guru punya foto nyata (URL) atau
// data mapel guru tersedia di backend.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/avatars.dart';
import '../../domain/class_exceptions.dart';
import '../../domain/class_repository.dart';
import 'class_sheet_shell.dart';

enum _DetailPhase { loading, ready, error }

/// Buka lembar detail kelas; hasil pop `true` bila siswa menyelesaikan
/// keluar dari kelas (pemanggil menampilkan snack + memuat ulang seksi).
Future<bool?> showStudentClassDetailSheet(
  BuildContext context, {
  required String classId,
}) => showClassSheet<bool>(
  context,
  builder: (_) => _StudentClassDetailSheet(classId: classId),
);

class _StudentClassDetailSheet extends StatefulWidget {
  const _StudentClassDetailSheet({required this.classId});

  final String classId;

  @override
  State<_StudentClassDetailSheet> createState() =>
      _StudentClassDetailSheetState();
}

class _StudentClassDetailSheetState extends State<_StudentClassDetailSheet> {
  late final ClassRepository _repo = context.read<ClassRepository>();

  _DetailPhase _phase = _DetailPhase.loading;
  String _errorMessage = '';
  ClassDetail? _detail;

  /// Konfirmasi "Ya, Keluar Kelas?" terbuka — kotak peringatan inline.
  bool _confirming = false;
  bool _leaving = false;
  bool _copied = false;
  Timer? _copiedTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _phase = _DetailPhase.loading);
    try {
      final detail = await _repo.classDetail(widget.classId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _phase = _DetailPhase.ready;
      });
    } on ApiClassException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _phase = _DetailPhase.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Server belum terjangkau. Periksa koneksi lab, lalu coba lagi.';
        _phase = _DetailPhase.error;
      });
    }
  }

  /// Salin info rombel ke clipboard + label "Info Tersalin!" dua detik.
  void _copyInfo() {
    final d = _detail!;
    Clipboard.setData(
      ClipboardData(
        text:
            '${d.info.name} | ${d.info.schoolName} (Guru: ${d.info.teacherName})',
      ),
    );
    _copiedTimer?.cancel();
    setState(() => _copied = true);
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _toggleConfirm(bool open) {
    setState(() => _confirming = open);
    if (open) {
      // Dialog peringatan keluar kelas memakai nada tantangan gagal-terasa
      // (alert warning) sesuai butir aset audio TODO Minggu 10.
      SoundService.playAlertWarning();
    }
  }

  Future<void> _leave() async {
    if (_leaving) return;
    setState(() => _leaving = true);
    try {
      await _repo.leaveClass(widget.classId);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiClassException catch (e) {
      if (!mounted) return;
      setState(() => _leaving = false);
      showAppSnack(context, e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _leaving = false);
      showAppSnack(
        context,
        'Server belum terjangkau. Coba beberapa saat lagi, ya.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return switch (_phase) {
      _DetailPhase.loading => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.huge),
        child: Center(child: CircularProgressIndicator()),
      ),
      _DetailPhase.error => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Column(
          children: [
            Icon(Icons.cloud_off_outlined, size: 40, color: p.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Detail kelas gagal dimuat',
              style: AppTypography.titleM.copyWith(color: p.text),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: AppTypography.bodyM.copyWith(color: p.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
      _DetailPhase.ready => _DetailContent(
        detail: _detail!,
        confirming: _confirming,
        leaving: _leaving,
        copied: _copied,
        onToggleConfirm: _toggleConfirm,
        onLeave: _leave,
        onCopy: _copyInfo,
      ),
    };
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.detail,
    required this.confirming,
    required this.leaving,
    required this.copied,
    required this.onToggleConfirm,
    required this.onLeave,
    required this.onCopy,
  });

  final ClassDetail detail;
  final bool confirming;
  final bool leaving;
  final bool copied;
  final ValueChanged<bool> onToggleConfirm;
  final VoidCallback onLeave;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final info = detail.info;
    final members = detail.members;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        // ---- Header kelas: badge aktif + ID kode rombel ----
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: p.successContainer,
                borderRadius: AppRadius.pillBorder,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: p.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Terdaftar Aktif',
                    style: AppTypography.caption.copyWith(
                      color: p.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: p.surfaceAlt,
                borderRadius: AppRadius.pillBorder,
              ),
              child: Text(
                '#${info.classCode}',
                style: AppTypography.code.copyWith(
                  color: p.textMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          info.name,
          style: AppTypography.titleL.copyWith(
            color: p.text,
            letterSpacing: -0.5,
          ),
        ),
        if (info.schoolName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Row(
              children: [
                Icon(Icons.school_rounded, size: 17, color: p.textMuted),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    info.schoolName,
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),

        // ---- Kartu guru pembimbing ----
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: p.bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InitialAvatar(name: info.teacherName, size: 48),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: p.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.surface, width: 2),
                      ),
                      child: Icon(
                        Icons.verified_rounded,
                        size: 9,
                        color: p.surface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            info.teacherName,
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
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: p.primary.withValues(alpha: 0.12),
                            borderRadius: AppRadius.pillBorder,
                          ),
                          child: Text(
                            'Guru',
                            style: AppTypography.code.copyWith(
                              color: p.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Guru pembimbing kelas ini',
                      style: AppTypography.caption.copyWith(color: p.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // ---- Teman sekelas ----
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Teman Sekelas ',
                style: AppTypography.label.copyWith(
                  color: p.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '(${members.length} Siswa)',
                style: AppTypography.label.copyWith(color: p.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (members.isEmpty)
          Text(
            'Belum ada teman sekelas yang terdaftar.',
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          )
        else
          _AvatarStack(members: members),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: p.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.desktop_windows_rounded, size: 19, color: p.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Progres koding dan nilai tantanganmu dapat dipantau langsung oleh guru kelas ini di lab komputer.',
                  style: AppTypography.bodyM.copyWith(
                    color: p.primary,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ---- Kartu keamanan sebelum aksi keluar ----
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: p.warningContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: p.warningContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.verified_user_rounded,
                  size: 18,
                  color: p.warningText,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Poin XP dan progres belajarmu tetap aman di akunmu jika kamu keluar kelas.',
                  style: AppTypography.bodyM.copyWith(
                    color: p.textMuted,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // ---- Aksi: salin info & keluar ----
        _PillButton(
          label: copied ? 'Info Tersalin!' : 'Salin Info Kelas',
          icon: copied ? Icons.done_rounded : Icons.copy_rounded,
          iconColor: copied ? p.success : p.textMuted,
          labelColor: p.text,
          background: p.surface,
          borderColor: p.outline,
          onTap: onCopy,
        ),
        const SizedBox(height: AppSpacing.sm),
        _PillButton(
          label: 'Keluar dari Kelas',
          icon: Icons.logout_rounded,
          iconColor: p.error,
          labelColor: p.error,
          background: p.errorContainer.withValues(alpha: 0.6),
          onTap: leaving ? null : () => onToggleConfirm(true),
        ),

        // ---- Dialog konfirmasi keluar (inline sub-view ala Stitch) ----
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: confirming
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: p.errorContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: p.error,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Yakin Ingin Keluar dari Kelas?',
                                style: AppTypography.label.copyWith(
                                  color: p.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Poin XP dan progres belajarmu tetap aman di akunmu, '
                          'namun gurumu tidak dapat lagi memantau kemajuan belajarmu di lab.',
                          style: AppTypography.bodyM.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: OutlinedButton(
                                  onPressed: leaving
                                      ? null
                                      : () => onToggleConfirm(false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: p.text,
                                    side: BorderSide(color: p.outline),
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text('Batal'),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: Material(
                                  color: leaving
                                      ? p.error.withValues(alpha: 0.6)
                                      : p.error,
                                  shape: const StadiumBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: leaving ? null : onLeave,
                                    child: Center(
                                      child: leaving
                                          ? SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Ya, Keluar Kelas',
                                              style: AppTypography.label
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Tumpukan avatar ala Stitch: lingkaran bertumpuk + chip "+N lainnya";
/// memukul chip memperlihatkan seluruh nama (data nyata roster).
class _AvatarStack extends StatefulWidget {
  const _AvatarStack({required this.members});

  final List<Classmate> members;

  @override
  State<_AvatarStack> createState() => _AvatarStackState();
}

class _AvatarStackState extends State<_AvatarStack> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final members = widget.members;
    if (_expand) {
      return Column(
        children: [
          for (final m in members)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  InitialAvatar(name: m.name, size: 30),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      m.name,
                      style: AppTypography.bodyM.copyWith(color: p.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          TextButton(
            onPressed: () => setState(() => _expand = false),
            child: Text(
              'Sembunyikan',
              style: AppTypography.label.copyWith(
                color: p.primary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      );
    }

    final shown = members.take(5).toList();
    final rest = members.length - shown.length;
    return Row(
      children: [
        SizedBox(
          width: shown.length * 26.0 + 10,
          height: 36,
          child: Stack(
            children: [
              for (var i = 0; i < shown.length; i++)
                Positioned(
                  left: i * 26.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: p.surface, width: 2),
                    ),
                    child: InitialAvatar(name: shown[i].name, size: 36),
                  ),
                ),
            ],
          ),
        ),
        if (rest > 0)
          GestureDetector(
            onTap: () => setState(() => _expand = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: p.surfaceAlt,
                borderRadius: AppRadius.pillBorder,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group_rounded, size: 14, color: p.textMuted),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '+$rest lainnya',
                    style: AppTypography.label.copyWith(
                      color: p.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Tombol pil besar ala Stitch (surface / errorContainer) dengan teks + ikon.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.labelColor,
    required this.background,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color labelColor;
  final Color background;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Material(
        color: background,
        shape: StadiumBorder(
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(color: borderColor!),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTypography.label.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
