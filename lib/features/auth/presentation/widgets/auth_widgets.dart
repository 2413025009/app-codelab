import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/auth_repository.dart';

/// Inline error / info banner for forms.
class FormBanner extends StatelessWidget {
  const FormBanner({super.key, required this.message, this.isError = true});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fg = isError ? p.error : p.success;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isError ? p.errorContainer : p.successContainer,
          borderRadius: AppRadius.inputBorder,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              size: 20,
              color: fg,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyM.copyWith(color: p.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Checklist keamanan sandi — dipakai register siswa & register guru (minggu 9).
/// Minggu 9: kini juga dipakai sheet "Ubah Password" di Pengaturan
/// (siswa & pengajar), sehingga pindah ke widget bersama sini.
class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final okLength = Validators.hasMinLength(password);
    final okChar = Validators.hasDigitOrSymbol(password);
    final status = password.isEmpty
        ? 'Belum diisi'
        : (okLength && okChar ? 'Sangat Bagus!' : 'Perlu ditingkatkan');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'KEAMANAN SANDI',
                  style: AppTypography.caption.copyWith(
                    color: p.textMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Text(
                status,
                style: AppTypography.caption.copyWith(
                  color: p.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _CheckRow(ok: okLength, label: 'Minimal 8 karakter'),
          const SizedBox(height: AppSpacing.sm),
          _CheckRow(ok: okChar, label: 'Ada angka atau simbol'),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.ok, required this.label});

  final bool ok;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      label: '$label, ${ok ? 'terpenuhi' : 'belum terpenuhi'}',
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: ok ? p.success : p.surfaceAlt,
              shape: BoxShape.circle,
              border: ok ? null : Border.all(color: p.textMuted, width: 1.5),
            ),
            child: ok
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.bodyL.copyWith(
              color: ok ? p.text : p.textMuted,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

/// Illustration for the welcome screen: tinted circle, terminal glyph, accent badge.
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ExcludeSemantics(
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: p.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 90,
              height: 66,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.terminal_rounded, color: p.primary, size: 34),
            ),
            Positioned(
              top: 6,
              right: 8,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: p.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 20,
                  color: AppPalette.onAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu verifikasi sekolah read-only (Minggu 9 — PROMPT.md Bagian 3).
/// Muncul dengan animasi fade saat kode sekolah cocok dengan database:
/// badge hijau "Sekolah Terdaftar Resmi", nama, alamat, dan keterangan
/// bahwa data instansi tidak dapat diubah oleh instruktur.
class VerifiedSchoolCard extends StatelessWidget {
  const VerifiedSchoolCard({super.key, required this.school});

  final VerifiedSchool school;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.successContainer,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.success.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  height: AppSizes.tagHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: p.success,
                    borderRadius: AppRadius.pillBorder,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Sekolah Terdaftar Resmi',
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Flexible(
                child: Text(
                  'Kode: ${school.schoolCode}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.code.copyWith(color: p.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: p.success.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  size: 20,
                  color: p.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name,
                      style: AppTypography.label.copyWith(
                        color: p.text,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      school.address,
                      style: AppTypography.bodyM.copyWith(color: p.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(
            height: 1,
            thickness: 1,
            color: p.success.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: p.success),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Data sekolah ini bersifat read-only dan terverifikasi otomatis; tidak dapat diubah oleh instruktur.',
                  style: AppTypography.caption.copyWith(
                    color: p.success,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
