import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/name_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loading_screen.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/dashboard_repository.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/winding_roadmap.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;
    return BlocProvider(
      create: (ctx) => DashboardCubit(ctx.read<DashboardRepository>(), user.email),
      child: _DashboardView(userName: user.name),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.userName});

  final String userName;

  void _openModule(BuildContext context, LearningModule m) {
    if (m.status == ModuleStatus.locked) {
      showAppSnack(context, m.requirement ?? 'Modul ini masih terkunci.');
      return;
    }
    context.push(AppRoutes.lesson(m.id));
  }

  void _showQuickTip(BuildContext context) {
    final p = context.palette;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: p.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lightbulb_rounded, color: p.primary, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Trik Cepat Python',
                    style: AppTypography.titleM.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Gunakan konstruksi elif untuk mengevaluasi beberapa kondisi berurutan secara bersih:\n\n'
                'if skor >= 90:\n'
                '    hasil = "A"\n'
                'elif skor >= 75:\n'
                '    hasil = "B"\n'
                'else:\n'
                '    hasil = "C"\n\n'
                'Dengan elif, evaluasi berhenti begitu kondisi pertama terpenuhi tanpa if bertingkat.',
                style: AppTypography.bodyM.copyWith(color: p.text),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Paham, Lanjutkan Belajar!',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTypography.titleM.copyWith(fontWeight: FontWeight.w700, color: p.text),
        ),
        actions: [ProfileActionButton(onTap: () => context.go(AppRoutes.profile))],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            DashboardLoading(:final done, :final total, :final stage) =>
                AppLoadingScreen(
                  title: 'Menyiapkan dashboard',
                  subtitle: 'Menarik data belajar dari server',
                  completedSteps: done,
                  totalSteps: total,
                  stageLabel: stage,
                  showTips: false,
                  compact: true,
                ),
            DashboardError() => _ErrorView(onRetry: () => context.read<DashboardCubit>().load()),
            DashboardLoaded(:final data) => RefreshIndicator(
                color: p.primary,
                onRefresh: () => context.read<DashboardCubit>().load(silent: true),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.xxl),
                  children: [
                    // 1. Greeting Section (Halo, Farhan 👋 + Tantangan Selesai + Avatar)
                    _Header(
                      userName: userName,
                      completed: data.completedChallenges,
                      onAvatar: () => context.go(AppRoutes.profile),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 2. Active Lesson / Progress Card (Stitch v2)
                    ResumeCard(
                      resume: data.resume,
                      currentChapter: data.modules.isNotEmpty
                          ? data.modules
                              .firstWhere(
                                (m) => m.status == ModuleStatus.active,
                                orElse: () => data.modules.first,
                              )
                              .order
                          : 1,
                      // P1-11: total bab dari data nyata — tanpa +n artifisial.
                      totalChapters: data.modules.length,
                      onPressed: () => context.push(AppRoutes.lesson(data.resume?.lessonId ?? data.firstLessonId)),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 3. Winding Roadmap ("Peta Petualangan Belajar" with blueprint dotted canvas)
                    if (data.modules.isEmpty)
                      Text('Belum ada modul. Cek lagi sebentar.', style: AppTypography.bodyM.copyWith(color: p.textMuted))
                    else
                      WindingRoadmap(
                        modules: data.modules,
                        onModuleTap: (m) => _openModule(context, m),
                        onOpenCatalog: () => context.push(AppRoutes.catalog),
                      ),
                    const SizedBox(height: AppSpacing.lg),

                    // 4. Quick Tip Banner ("Trik Cepat Python" from Stitch v2)
                    _QuickTipCard(onTap: () => _showQuickTip(context)),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.userName, required this.completed, required this.onAvatar});

  final String userName;
  final int completed;
  final VoidCallback onAvatar;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final initials = InitialAvatar.initialsOf(userName);

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greeting & Challenge Selesai
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Halo, ${displayFirstName(userName)}',
                        style: AppTypography.titleL.copyWith(
                          color: p.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.waving_hand_rounded, color: p.accent, size: 22),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, color: p.success, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      '$completed tantangan selesai',
                      style: AppTypography.bodyM.copyWith(
                        color: p.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Avatar circle with green school cap badge (Stitch v2)
          InkWell(
            onTap: onAvatar,
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4E8F8), // surface-container-high
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: p.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      color: p.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: p.surface, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 10),
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

class _QuickTipCard extends StatelessWidget {
  const _QuickTipCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: const Color(0xFFDEE2F3), // surface-container-highest
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.outline.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: p.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.lightbulb_rounded, color: p.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trik Cepat Python',
                      style: AppTypography.bodyM.copyWith(
                        fontWeight: FontWeight.w700,
                        color: p.text,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Gunakan elif untuk evaluasi multi-kondisi',
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                        fontSize: 12,
                      ),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: p.textMuted),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Ada kendala di sisi kami. Coba lagi sebentar.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyL.copyWith(color: p.textMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Coba lagi', expand: false, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
