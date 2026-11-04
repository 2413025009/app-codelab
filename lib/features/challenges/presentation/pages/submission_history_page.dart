import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_tag.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../../core/widgets/code_card.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/challenge_repository.dart';

class SubmissionHistoryPage extends StatefulWidget {
  const SubmissionHistoryPage({super.key, required this.challengeId});

  final String challengeId;

  @override
  State<SubmissionHistoryPage> createState() => _SubmissionHistoryPageState();
}

class _SubmissionHistoryPageState extends State<SubmissionHistoryPage> {
  /// Pintasan kamus UI supaya semua pembangun layar ini konsisten.
  AppLocalizations get l10n => AppLocalizations.of(context);

  late final ChallengeRepository _repo = context.read<ChallengeRepository>();
  late Future<SubmissionHistory> _future = _repo.getHistory(widget.challengeId);
  int? _expanded = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.challenges),
        ),
        centerTitle: true,
        title: Text(l10n.historyTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InitialAvatar(name: user.name, size: 40, onTap: () => context.go(AppRoutes.profile)),
          ),
        ],
      ),
      body: FutureBuilder<SubmissionHistory>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: AppSpacing.screenPadding,
              child: Column(children: [
                SkeletonBox(height: 140, radius: AppRadius.card),
                SizedBox(height: 16),
                SkeletonBox(height: 200, radius: AppRadius.card),
              ]),
            );
          }
          if (snap.hasError) {
            return Center(
              child: AppButton(
                label: l10n.dashRetryButton,
                expand: false,
                onPressed: () => setState(() => _future = _repo.getHistory(widget.challengeId)),
              ),
            );
          }
          return _content(context, snap.data!);
        },
      ),
    );
  }

  Widget _content(BuildContext context, SubmissionHistory h) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.xxl),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: p.primaryContainer, borderRadius: BorderRadius.circular(14)),
                  child: Icon(Icons.terminal_rounded, color: p.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.challengeTitle, style: AppTypography.titleM.copyWith(color: p.text)),
                      Text(h.context, style: AppTypography.bodyM.copyWith(color: p.textMuted)),
                    ],
                  ),
                ),
                AppTag.success(context, l10n.historyStatusPassed, icon: Icons.check_circle_outline_rounded),
              ]),
              const SizedBox(height: AppSpacing.lg),
              Divider(color: p.outline),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.historyBestScore, style: AppTypography.bodyM.copyWith(color: p.textMuted)),
                      Text.rich(TextSpan(children: [
                        TextSpan(text: '${h.bestScore}', style: AppTypography.display.copyWith(color: p.text, fontFamily: AppFonts.mono, fontSize: 40)),
                        TextSpan(text: ' /100', style: AppTypography.bodyL.copyWith(color: p.textMuted)),
                      ])),
                    ],
                  ),
                ),
                AppTag(l10n.historyAttemptsCount(h.submissions.length), icon: Icons.history_rounded),
              ]),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(children: [
          Expanded(child: Text(l10n.historySubmissionsHeader, style: AppTypography.titleM.copyWith(color: p.text, fontSize: 18))),
          Text(l10n.historySortedByTime, style: AppTypography.caption.copyWith(color: p.textMuted)),
        ]),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < h.submissions.length; i++) ...[
          _SubmissionCard(
            submission: h.submissions[i],
            expanded: _expanded == i,
            onToggle: () => setState(() => _expanded = _expanded == i ? null : i),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.historyOpenPlayground,
          kind: AppButtonKind.secondary,
          leadingIcon: Icons.play_circle_outline_rounded,
          onPressed: () => context.push(AppRoutes.lab, extra: h.submissions.first.code),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch)),
            onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.challenges),
            child: Text(l10n.historyBackToChallenge, style: AppTypography.label.copyWith(color: p.primary, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({required this.submission, required this.expanded, required this.onToggle});

  final Submission submission;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final s = submission;
    final (Color c, Color bg, IconData icon, String label) = switch (s.status) {
      SubmissionStatus.passed => (p.success, p.successContainer, Icons.check_circle_outline_rounded, l10n.historyStatusPassed),
      SubmissionStatus.failed => (p.error, p.errorContainer, Icons.cancel_outlined, l10n.challengeFailed),
      SubmissionStatus.error => (p.error, p.errorContainer, Icons.cancel_outlined, l10n.historyStatusError),
    };

    return AppCard(
      borderColor: expanded ? p.primary.withValues(alpha: 0.5) : null,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                    child: Icon(icon, color: c),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                          Text(l10n.historySubmissionNumber(s.number), style: AppTypography.titleM.copyWith(color: p.text, fontSize: 18)),
                          if (s.whenLabel.isNotEmpty) AppTag(s.whenLabel, background: p.primaryContainer, foreground: p.primary),
                        ]),
                        const SizedBox(height: 4),
                        Text.rich(TextSpan(children: [
                          TextSpan(text: label, style: AppTypography.label.copyWith(color: c)),
                          TextSpan(text: l10n.historyScoreInline(s.score), style: AppTypography.label.copyWith(color: p.text)),
                        ])),
                        const SizedBox(height: 2),
                        Text(s.detail, style: AppTypography.bodyM.copyWith(color: p.textMuted, fontSize: 13)),
                        if (s.problem != null) ...[
                          const SizedBox(height: 6),
                          Row(children: [
                            Icon(Icons.error_outline_rounded, size: 16, color: p.error),
                            const SizedBox(width: 4),
                            Expanded(child: Text(s.problem!, style: AppTypography.caption.copyWith(color: p.error))),
                          ]),
                        ],
                        if (s.hintsUsed > 0) ...[
                          const SizedBox(height: 8),
                          AppTag(l10n.historyHintsUsed(s.hintsUsed), background: p.warningContainer, foreground: p.warningText, icon: Icons.lightbulb_outline_rounded),
                        ],
                      ],
                    ),
                  ),
                  Icon(expanded ? Icons.keyboard_arrow_up_rounded : Icons.chevron_right_rounded, color: p.textMuted),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(color: p.outline),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.code_rounded, size: 18, color: p.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l10n.historySubmissionCode(s.number), style: AppTypography.label.copyWith(color: p.text, fontSize: 14))),
                    CopyChip(textToCopy: s.code, tinted: true),
                  ]),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(color: p.codeBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.outline)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text.rich(
                        TextSpan(style: AppTypography.code.copyWith(color: p.text, fontSize: 12.5), children: highlightPython(context, s.code)),
                      ),
                    ),
                  ),
                  if (s.aiReview != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(color: p.primaryContainer.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: p.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.historyAiReview, style: AppTypography.label.copyWith(color: p.text, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(s.aiReview!, style: AppTypography.bodyM.copyWith(color: p.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
