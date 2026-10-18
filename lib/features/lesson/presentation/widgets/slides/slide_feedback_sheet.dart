import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_button.dart';

/// Sheet feedback jawaban slide — mengikuti Stitch v2
/// modal_feedback_evaluasi_benar_salah / jawaban_salah:
/// sheet putih dengan handle, badge pedagogis, kartu konsep/petunjuk,
/// dan aksi [Tanya AI Tutor | Coba Lagi] atau CTA lanjut tunggal.
class SlideFeedbackSheet extends StatelessWidget {
  const SlideFeedbackSheet({
    super.key,
    required this.isCorrect,
    required this.title,
    required this.message,
    required this.onContinue,
    this.onRetry,
    this.onAskTutor,
  });

  final bool isCorrect;
  final String title;
  final String message;
  final VoidCallback onContinue;
  final VoidCallback? onRetry;
  final VoidCallback? onAskTutor;

  static Future<void> show(
    BuildContext context, {
    required bool isCorrect,
    required String title,
    required String message,
    required VoidCallback onContinue,
    VoidCallback? onRetry,
    VoidCallback? onAskTutor,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => SlideFeedbackSheet(
        isCorrect: isCorrect,
        title: title,
        message: message,
        onContinue: onContinue,
        onRetry: onRetry,
        onAskTutor: onAskTutor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(color: p.outline, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          if (isCorrect) ..._successBody(context, p) else ..._errorBody(context, p),
        ],
      )),
    );
  }

  // --- STATE 1: Sukses ("Langkah Tervalidasi") ---
  List<Widget> _successBody(BuildContext context, AppPalette p) {
    return [
      Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: p.successContainer, shape: BoxShape.circle),
            child: Icon(Icons.check_circle_rounded, color: p.success, size: 24),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: p.successContainer, borderRadius: BorderRadius.circular(999)),
            child: Text(
              'Langkah Tervalidasi',
              style: AppTypography.label.copyWith(color: p.success, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save_rounded, size: 14, color: p.textMuted),
                const SizedBox(width: 6),
                Text('Progres Tersimpan', style: AppTypography.label.copyWith(color: p.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Text.rich(
        TextSpan(children: [
          TextSpan(text: title),
          const WidgetSpan(child: Text(' 🎉', style: TextStyle(fontSize: 22))),
        ]),
        style: AppTypography.titleM.copyWith(color: p.text, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: AppSpacing.md),
      _ConceptCard(icon: Icons.menu_book_rounded, title: 'Mengapa Jawabanmu Benar?', body: message, palette: p),
      const SizedBox(height: AppSpacing.lg),
      AppButton(
        label: 'Lanjut ke Slide Berikutnya',
        trailingIcon: Icons.arrow_forward_rounded,
        onPressed: () {
          Navigator.of(context).pop();
          onContinue();
        },
      ),
    ];
  }

  // --- STATE 2: Salah ("Evaluasi Sintaksis") ---
  List<Widget> _errorBody(BuildContext context, AppPalette p) {
    return [
      Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: p.warningContainer, shape: BoxShape.circle),
            child: Icon(Icons.smart_toy_rounded, color: p.warningText, size: 24),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: p.warningContainer, borderRadius: BorderRadius.circular(999)),
            child: Text(
              'Evaluasi Sintaksis',
              style: AppTypography.label.copyWith(color: p.warningText, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, size: 14, color: p.textMuted),
                const SizedBox(width: 6),
                Text(
                  '0 XP • Semangat Coba Lagi',
                  style: AppTypography.label.copyWith(color: p.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Text.rich(
        TextSpan(children: [
          TextSpan(text: title),
          const WidgetSpan(child: Text(' 🤔', style: TextStyle(fontSize: 22))),
        ]),
        style: AppTypography.titleM.copyWith(color: p.text, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        'Jangan khawatir, kesalahan kecil adalah bagian alami dari proses belajar koding.',
        style: AppTypography.bodyM.copyWith(color: p.textMuted),
      ),
      const SizedBox(height: AppSpacing.md),
      _HintCard(body: message, palette: p),
      const SizedBox(height: AppSpacing.lg),
      Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Tanya AI Tutor',
              kind: AppButtonKind.secondary,
              leadingIcon: Icons.help_outline_rounded,
              onPressed: onAskTutor != null
                  ? () {
                      Navigator.of(context).pop();
                      onAskTutor?.call();
                    }
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppButton(
              label: 'Coba Lagi',
              leadingIcon: Icons.restart_alt_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                onRetry?.call();
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onContinue();
        },
        child: Text('Lewati Slide →', style: AppTypography.label.copyWith(color: p.textMuted)),
      ),
    ];
  }
}

/// Kartu konsep bawah badge sukses (surface-alt, ikon menu_book).
class _ConceptCard extends StatelessWidget {
  const _ConceptCard({required this.icon, required this.title, required this.body, required this.palette});

  final IconData icon;
  final String title;
  final String body;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: p.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTypography.label.copyWith(color: p.text, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTypography.bodyM.copyWith(color: p.textMuted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// Kartu petunjuk pemantik pada state salah (warning container).
class _HintCard extends StatelessWidget {
  const _HintCard({required this.body, required this.palette});

  final String body;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: p.warningContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.warningText.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_rounded, size: 20, color: p.warningText),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Di Mana Letak Kesalahannya?',
                style: AppTypography.label.copyWith(color: p.warningText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTypography.bodyM.copyWith(color: p.warningText, height: 1.5),
          ),
        ],
      ),
    );
  }
}
