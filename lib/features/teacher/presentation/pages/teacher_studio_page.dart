// FILE: lib/features/teacher/presentation/pages/teacher_studio_page.dart
//
// TUGAS: Studio Pengajar / Materi Saya (Minggu 11).
// Berdasarkan desain Stitch v3: studio_pengajar_materi_saya.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/topic_icons.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';

class TeacherStudioPage extends StatefulWidget {
  const TeacherStudioPage({super.key});

  @override
  State<TeacherStudioPage> createState() => _TeacherStudioPageState();
}

class _TeacherStudioPageState extends State<TeacherStudioPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TeacherCubit>();
    cubit.loadMaterials();
    cubit.loadDashboard();
  }

  void _openActionSheet(BuildContext context, TeacherLesson lesson) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<TeacherCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.82,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: p.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    lesson.title,
                    style: AppTypography.titleM.copyWith(color: p.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.tStudioActionHint,
                    style: AppTypography.bodySm.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 1. Edit Bab & Silabus
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: p.primaryContainer.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: p.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      l10n.tStudioEditSyllabus,
                      style: AppTypography.labelL.copyWith(color: p.text),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      context.push(AppRoutes.teacherBabList(lesson.id));
                    },
                  ),

                  // 2. Edit Pengaturan Materi
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: p.surfaceAlt,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.edit_outlined, color: p.text, size: 20),
                    ),
                    title: Text(
                      l10n.tStudioEditInfo,
                      style: AppTypography.labelL.copyWith(color: p.text),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      context.push(
                        AppRoutes.teacherMaterialEdit(lesson.id),
                        extra: lesson,
                      );
                    },
                  ),

                  // 3. Duplikat Materi
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: p.surfaceAlt,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.content_copy_rounded,
                        color: p.text,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      l10n.tStudioDuplicate,
                      style: AppTypography.labelL.copyWith(color: p.text),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      cubit.duplicateMaterial(lesson.id);
                    },
                  ),

                  // 4. Terbitkan / Tarik ke Draft
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: lesson.isPublished
                            ? p.surfaceAlt
                            : p.primaryContainer.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        lesson.isPublished
                            ? Icons.unpublished_outlined
                            : Icons.rocket_launch_rounded,
                        color: lesson.isPublished ? p.textMuted : p.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      lesson.isPublished
                          ? l10n.tStudioUnpublish
                          : l10n.tStudioPublish,
                      style: AppTypography.labelL.copyWith(
                        color: lesson.isPublished ? p.text : p.primary,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      if (lesson.isPublished) {
                        cubit.unpublishMaterial(lesson.id);
                      } else {
                        cubit.publishMaterial(lesson.id);
                      }
                    },
                  ),

                  // 5. Hapus Materi
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: p.error.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: p.error,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      l10n.tStudioDeleteForever,
                      style: AppTypography.labelL.copyWith(color: p.error),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _confirmDeleteLesson(context, lesson);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteLesson(BuildContext context, TeacherLesson lesson) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.tStudioDeleteTitle),
        content: Text(
          l10n.tStudioDeleteBody(lesson.title),
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TeacherCubit>().deleteMaterial(lesson.id);
            },
            child: Text(l10n.actionDelete, style: TextStyle(color: p.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final user = context.watch<AuthCubit>().state.user;
    final schoolLabel = user?.schoolName?.trim() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tStudioTitle),
        actions: [
          IconButton(
            tooltip: l10n.tProfileTitle,
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.go(AppRoutes.teacherProfile),
          ),
          IconButton(
            tooltip: l10n.tStudioSettingsTooltip,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.teacherSettings),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<TeacherCubit, TeacherState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context);
            if (state.errorMessage != null) {
              showAppSnack(
                context,
                teacherErrorText(l10n, state.errorCode, state.errorMessage!),
              );
              context.read<TeacherCubit>().clearMessages();
            } else if (state.actionSuccessMessage != null) {
              showAppSnack(
                context,
                teacherSuccessText(
                  l10n,
                  state.actionSuccessCode,
                  state.actionSuccessArg,
                  state.actionSuccessMessage!,
                ),
              );
              context.read<TeacherCubit>().clearMessages();
            }
          },
          builder: (context, state) {
            final materials = state.filteredMaterials;
            final filter = state.materialFilter;

            return RefreshIndicator(
              onRefresh: () async {
                final cubit = context.read<TeacherCubit>();
                await cubit.loadMaterials();
                await cubit.loadDashboard();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Bar & Tambah Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.tStudioMyMaterials,
                                style: AppTypography.titleL.copyWith(
                                  color: p.text,
                                ),
                              ),
                              Text(
                                l10n.tStudioSubtitle,
                                style: AppTypography.bodySm.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(l10n.tStudioAdd),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: p.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            context.push(AppRoutes.teacherMaterialCreate);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Classroom Context Banner
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: p.primaryContainer.withAlpha(30),
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.primary.withAlpha(50)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: p.primaryContainer.withAlpha(40),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.campaign_outlined,
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
                                  l10n.tStudioBannerTitle,
                                  style: AppTypography.labelL.copyWith(
                                    color: p.text,
                                  ),
                                ),
                                Text(
                                  l10n.tStudioBanner(state.publishedCount, state.totalStudentCount, schoolLabel.isEmpty ? l10n.tStudioYourSchool : schoolLabel),
                                  style: AppTypography.bodySm.copyWith(
                                    color: p.textMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Segmented Control Tabs (Semua | Draft | Terbit)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: p.surfaceAlt,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          _buildFilterTab(
                            context,
                            label: l10n.tStudioFilterAll(state.materials.length),
                            isSelected: filter == 'all',
                            onTap: () => context
                                .read<TeacherCubit>()
                                .setMaterialFilter('all'),
                            p: p,
                          ),
                          _buildFilterTab(
                            context,
                            label: l10n.tStudioFilterDraft(state.draftCount),
                            isSelected: filter == 'draft',
                            onTap: () => context
                                .read<TeacherCubit>()
                                .setMaterialFilter('draft'),
                            p: p,
                          ),
                          _buildFilterTab(
                            context,
                            label: l10n.tStudioFilterPublished(state.publishedCount),
                            isSelected: filter == 'published',
                            onTap: () => context
                                .read<TeacherCubit>()
                                .setMaterialFilter('published'),
                            p: p,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Loading State
                    if (state.isLoading && state.materials.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    // Empty State
                    else if (materials.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: p.surface,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(color: p.outline),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: 48,
                              color: p.textMuted,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              filter == 'all'
                                  ? l10n.tStudioEmptyTitle
                                  : filter == 'draft'
                                      ? l10n.tStudioEmptyDraftTitle
                                      : l10n.tStudioEmptyPublishedTitle,
                              style: AppTypography.titleM.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              filter == 'all'
                                  ? l10n.tStudioEmptyBody
                                  : l10n.tStudioEmptyFilterBody,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            AppButton(
                              label: l10n.tStudioCreateNew,
                              leadingIcon: Icons.add_rounded,
                              onPressed: () {
                                context.push(AppRoutes.teacherMaterialCreate);
                              },
                            ),
                          ],
                        ),
                      )
                    // Materials Cards List
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: materials.length,
                        itemBuilder: (ctx, index) {
                          final lesson = materials[index];
                          return _buildMaterialCard(context, lesson, p);
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppPalette p,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? p.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: p.primary.withAlpha(50),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppTypography.labelM.copyWith(
              color: isSelected ? Colors.white : p.textMuted,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(
    BuildContext context,
    TeacherLesson lesson,
    AppPalette p,
  ) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.outline),
      ),
      child: InkWell(
        borderRadius: AppRadius.cardBorder,
        onTap: () {
          context.push(AppRoutes.teacherBabList(lesson.id));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Topic Icon, Status Chip, Title, Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: p.primaryContainer.withAlpha(35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    // Ikon mengikuti pilihan guru di form materi (icon_code),
                    // bukan ditebak dari nama topik.
                    materialIcon(lesson.iconCode, topic: lesson.topic),
                    color: p.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: lesson.isPublished
                              ? p.primaryContainer.withAlpha(40)
                              : p.surfaceAlt,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          lesson.isPublished ? l10n.tProfilePublished : l10n.tProfileDraft,
                          style: AppTypography.labelSm.copyWith(
                            color: lesson.isPublished ? p.primary : p.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.title,
                        style: AppTypography.titleM.copyWith(
                          color: p.text,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_stories_rounded,
                            size: 12,
                            color: p.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              // Ringkasan nyata dari server: topik, jumlah
                              // bab, dan total XP materi ini.
                              [
                                lesson.topic,
                                l10n.tStudioBabCount(lesson.babCount),
                                '${lesson.totalXp} XP',
                              ].where((s) => s.isNotEmpty).join(' • '),
                              style: AppTypography.codeSm.copyWith(
                                color: p.textMuted,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () => _openActionSheet(context, lesson),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description
            if (lesson.description.isNotEmpty) ...[
              Text(
                lesson.description,
                style: AppTypography.bodyM.copyWith(color: p.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Warning Chip for Draft
            if (lesson.isDraft) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_off_outlined,
                      size: 14,
                      color: p.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.tStudioNotVisible,
                      style: AppTypography.labelSm.copyWith(color: p.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),

            // Meta Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        size: 16,
                        color: p.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.tStudioBabCount(lesson.babCount),
                        style: AppTypography.labelM.copyWith(color: p.text),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: p.textMuted)),
                      const SizedBox(width: 8),
                      Icon(Icons.bolt_rounded, size: 16, color: p.accent),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${lesson.totalXp} XP',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelM.copyWith(color: p.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    lesson.topic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTypography.labelSm.copyWith(color: p.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
