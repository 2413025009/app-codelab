import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

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
            Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded, size: 20, color: fg),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: AppTypography.bodyM.copyWith(color: p.text))),
          ],
        ),
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
            Container(width: 150, height: 150, decoration: BoxDecoration(color: p.primaryContainer, shape: BoxShape.circle)),
            Container(
              width: 90,
              height: 66,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14)),
              child: Icon(Icons.terminal_rounded, color: p.primary, size: 34),
            ),
            Positioned(
              top: 6,
              right: 8,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: p.accent, shape: BoxShape.circle),
                child: const Icon(Icons.star_rounded, size: 20, color: AppPalette.onAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
