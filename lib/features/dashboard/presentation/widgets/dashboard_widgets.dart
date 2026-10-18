import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_tag.dart';
import '../../../../core/widgets/competency_radar.dart';
import '../../domain/dashboard_repository.dart';

/// "Lanjutkan Belajar" card matching Stitch v2 (20px rounded, clean progress bar, topic & bab indicator).
class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.resume,
    required this.onPressed,
    this.currentChapter = 3,
    this.totalChapters = 6,
  });

  final ResumeInfo? resume;
  final VoidCallback onPressed;
  final int currentChapter;
  final int totalChapters;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final r = resume;
    final progress = r?.progress ?? 0.0;
    final percent = (progress * 100).round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.outline.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Topic uppercase + Bab X dari Y
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (r?.topic ?? 'Python Dasar & Logika').toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: p.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Bab $currentChapter dari $totalChapters',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: p.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Middle row: Chapter title + Progress percent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      r?.title ?? '1. Pengenalan Logika Koding',
                      style: AppTypography.bodyL.copyWith(
                        fontWeight: FontWeight.w600,
                        color: p.text,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '$percent% Selesai',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: p.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Bottom row: Slim progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 8,
                  width: double.infinity,
                  color: p.surfaceAlt,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: p.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Radar + per-axis score chips. Empty state shows microcopy from DESIGN.md §4.
class CompetencyCard extends StatelessWidget {
  const CompetencyCard({super.key, required this.skills, required this.hasSkills, required this.onDetail});

  final Map<String, double> skills;
  final bool hasSkills;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Kompetensimu', style: AppTypography.titleM.copyWith(color: p.text))),
              TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch)),
                onPressed: onDetail,
                child: Text('Lihat detail', style: AppTypography.label.copyWith(color: p.primary)),
              ),
            ],
          ),
          if (hasSkills) ...[
            const SizedBox(height: AppSpacing.sm),
            Center(child: CompetencyRadar(scores: skills, size: 250)),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 3.4,
              children: [for (final e in skills.entries) _ScoreChip(label: e.key, value: e.value)],
            ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: p.primaryContainer, shape: BoxShape.circle),
                    child: Icon(Icons.radar_rounded, color: p.primary, size: 30),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Text(
                      'Selesaikan satu tantangan, nanti kompetensimu muncul di sini.',
                      style: AppTypography.bodyM.copyWith(color: p.textMuted),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.value});
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyM.copyWith(color: p.textMuted))),
          Text(
            '${value.round()}',
            style: AppTypography.code.copyWith(color: p.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Vertical learning path with a 2pt connector (DESIGN.md §3.3).
class LearningPathList extends StatelessWidget {
  const LearningPathList({super.key, required this.modules, required this.onTap});

  final List<LearningModule> modules;
  final ValueChanged<LearningModule> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      child: Column(
        children: [
          for (var i = 0; i < modules.length; i++)
            _PathItem(
              module: modules[i],
              isLast: i == modules.length - 1,
              lineColor: p.outline,
              onTap: () => onTap(modules[i]),
            ),
        ],
      ),
    );
  }
}

class _PathItem extends StatelessWidget {
  const _PathItem({required this.module, required this.isLast, required this.lineColor, required this.onTap});

  final LearningModule module;
  final bool isLast;
  final Color lineColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final m = module;
    final locked = m.status == ModuleStatus.locked;
    final active = m.status == ModuleStatus.active;

    final statusLabel = switch (m.status) {
      ModuleStatus.completed => 'Selesai',
      ModuleStatus.active => 'Sedang dipelajari',
      ModuleStatus.locked => 'Terkunci',
    };

    return Semantics(
      button: true,
      label: '${m.order}. ${m.title}, $statusLabel',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    _Node(status: m.status),
                    if (!isLast) Expanded(child: Container(width: 2, color: lineColor)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${m.order}. ${m.title}',
                              style: AppTypography.bodyL.copyWith(
                                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                                color: locked ? p.textMuted : p.text,
                              ),
                            ),
                          ),
                          if (m.status == ModuleStatus.completed)
                            Text('Selesai', style: AppTypography.caption.copyWith(color: p.success, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      if (active) ...[
                        const SizedBox(height: 6),
                        AppTag('Sedang dipelajari', background: p.primaryContainer, foreground: p.primary),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        locked ? (m.requirement ?? '') : m.description,
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.status});
  final ModuleStatus status;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    switch (status) {
      case ModuleStatus.completed:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: p.success, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: Colors.white),
        );
      case ModuleStatus.active:
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: p.primaryContainer, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
            child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 20),
          ),
        );
      case ModuleStatus.locked:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: p.surfaceAlt, shape: BoxShape.circle),
          child: Icon(Icons.lock_outline_rounded, color: p.textMuted, size: 20),
        );
    }
  }
}
