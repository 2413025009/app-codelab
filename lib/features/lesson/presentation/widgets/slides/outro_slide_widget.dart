import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../domain/slide_models.dart';

class OutroSlideWidget extends StatelessWidget {
  const OutroSlideWidget({
    super.key,
    required this.slide,
    /// P2-15: reward efektif dari DB (lessons.xp_reward) menggantikan angka
    /// statis markdown bila tersedia — reward guru terbaru selalu tampil.
    this.effectiveXp,
  });

  final OutroSlide slide;

  /// XP resmi dari DB; null berarti fallback ke nilai markdown saat offline.
  final int? effectiveXp;

  int get _xp => effectiveXp ?? slide.xpEarned;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.lg, AppSpacing.screen, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.md),
          // Celebration Icon
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: p.accent.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.emoji_events_rounded,
              size: 50,
              color: p.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTypography.titleL.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            slide.summary,
            textAlign: TextAlign.center,
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          // 3 Stats Row
          Row(
            children: [
              Expanded(
                child: AppCard(
                  color: p.surfaceAlt,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      Icon(Icons.star_rounded, color: p.accent, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        '+$_xp XP',
                        style: AppTypography.titleM.copyWith(
                          fontWeight: FontWeight.bold,
                          color: p.text,
                        ),
                      ),
                      Text(
                        'Hadiah XP',
                        style: AppTypography.caption.copyWith(color: p.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppCard(
                  color: p.surfaceAlt,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_rounded, color: p.success, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        slide.accuracy,
                        style: AppTypography.titleM.copyWith(
                          fontWeight: FontWeight.bold,
                          color: p.text,
                        ),
                      ),
                      Text(
                        'Akurasi',
                        style: AppTypography.caption.copyWith(color: p.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppCard(
                  color: p.surfaceAlt,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      Icon(Icons.timer_rounded, color: p.primary, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        slide.learningTime,
                        style: AppTypography.titleM.copyWith(
                          fontWeight: FontWeight.bold,
                          color: p.text,
                        ),
                      ),
                      Text(
                        'Waktu Belajar',
                        style: AppTypography.caption.copyWith(color: p.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Mastered Concepts Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified_rounded, color: p.success, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Konsep yang Kamu Kuasai',
                      style: AppTypography.titleM.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...slide.masteredConcepts.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4, right: 10),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: p.success.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, size: 12, color: p.success),
                        ),
                        Expanded(
                          child: Text(
                            c,
                            style: AppTypography.bodyM.copyWith(
                              color: p.text,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
