// FILE: lib/features/teacher/presentation/pages/bab_list_page.dart
//
// TUGAS: daftar bab terstruktur per materi (Minggu 11-12).
// Sesuai desain Stitch v3: daftar_bab_pemrograman_web.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';
import '../../domain/slide_adapter.dart';
import '../../../lesson/presentation/pages/lesson_reader_page.dart';

class BabListPage extends StatefulWidget {
  const BabListPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<BabListPage> createState() => _BabListPageState();
}

class _BabListPageState extends State<BabListPage> {
  TeacherLesson? _loadedLesson;

  @override
  void initState() {
    super.initState();
    context.read<TeacherCubit>().loadBabs(widget.lessonId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLesson());
  }

  Future<void> _loadLesson() async {
    final cubit = context.read<TeacherCubit>();
    if (cubit.state.materials.any((m) => m.id == widget.lessonId)) return;
    final lesson = await cubit.findMaterial(widget.lessonId);
    if (!mounted || lesson == null) return;
    setState(() => _loadedLesson = lesson);
  }

  TeacherLesson? _findLesson(BuildContext context) {
    final materials = context.watch<TeacherCubit>().state.materials;
    return materials.where((m) => m.id == widget.lessonId).firstOrNull ??
        _loadedLesson;
  }

  void _confirmDeleteBab(BuildContext context, Bab bab) {
    final p = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Bab Ini?'),
        content: Text(
          'Bab "${bab.title}" akan dihapus dari daftar materi. '
          'Riwayat belajar siswa yang sudah tercatat tetap tersimpan.',
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TeacherCubit>().deleteBab(bab.id, widget.lessonId);
            },
            child: Text('Hapus', style: TextStyle(color: p.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final lesson = _findLesson(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Silabus & Bab'),
        actions: [
          IconButton(
            tooltip: 'Tambah Bab',
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              context.push(AppRoutes.teacherBabCreate(widget.lessonId));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<TeacherCubit, TeacherState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              showAppSnack(context, state.errorMessage!);
              context.read<TeacherCubit>().clearMessages();
            } else if (state.actionSuccessMessage != null) {
              showAppSnack(context, state.actionSuccessMessage!);
              context.read<TeacherCubit>().clearMessages();
            }
          },
          builder: (context, state) {
            final babs = state.babs;
            final totalXp = babs.fold(0, (sum, b) => sum + b.xpReward);

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<TeacherCubit>().loadBabs(widget.lessonId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Status Materi
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (lesson?.isPublished ?? false)
                                ? p.primaryContainer.withAlpha(40)
                                : p.surfaceAlt,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: (lesson?.isPublished ?? false)
                                      ? p.primary
                                      : p.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (lesson?.isPublished ?? false)
                                    ? 'Terbit'
                                    : 'Draft',
                                style: AppTypography.labelSm.copyWith(
                                  color: (lesson?.isPublished ?? false)
                                      ? p.primary
                                      : p.textMuted,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          lesson?.topic ?? 'Materi Studio',
                          style: AppTypography.labelM.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      lesson?.title ?? 'Daftar Bab',
                      style: AppTypography.titleL.copyWith(color: p.text),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Progress Overview Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_stories_rounded,
                                    size: 18,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Status Kurikulum Bab',
                                    style: AppTypography.labelL.copyWith(
                                      color: p.text,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${babs.length} Bab • $totalXp XP',
                                style: AppTypography.codeSm.copyWith(
                                  color: p.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: babs.isNotEmpty ? 1.0 : 0.0,
                              backgroundColor: p.surfaceAlt,
                              color: p.primary,
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            (lesson?.isPublished ?? false)
                                ? 'Seluruh bab aktif terbaca oleh siswa di kelasmu.'
                                : 'Materi berstatus Draft. Siswa belum dapat melihat bab-bab ini.',
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Daftar Bab Terstruktur',
                              style: AppTypography.labelL.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: p.surfaceAlt,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${babs.length}',
                                style: AppTypography.codeSm.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Urutan Alur Belajar',
                          style: AppTypography.labelSm.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Empty State or List of Babs
                    if (state.isLoading && babs.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (babs.isEmpty)
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
                              Icons.library_books_rounded,
                              size: 48,
                              color: p.textMuted,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Belum Ada Bab',
                              style: AppTypography.titleM.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Materi ini belum memiliki bab pembelajaran. Tambahkan bab pertama untuk mulai menyusun slide kuis dan teori.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            AppButton(
                              label: 'Tambah Bab Pertama',
                              leadingIcon: Icons.add_rounded,
                              onPressed: () {
                                context.push(
                                  AppRoutes.teacherBabCreate(widget.lessonId),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: babs.length,
                        itemBuilder: (ctx, index) {
                          final bab = babs[index];
                          final orderNum = (index + 1).toString().padLeft(
                            2,
                            '0',
                          );

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: p.surface,
                              borderRadius: AppRadius.cardBorder,
                              border: Border.all(color: p.outline),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Order Badge
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: p.primaryContainer.withAlpha(35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '#$orderNum',
                                    style: AppTypography.codeSm.copyWith(
                                      color: p.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),

                                // Bab Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bab.title,
                                        style: AppTypography.labelL.copyWith(
                                          color: p.text,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${bab.slides.length} Slide • ${bab.xpReward} XP',
                                        style: AppTypography.bodySm.copyWith(
                                          color: p.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Action Buttons: Move Up/Down + Edit + Delete
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (index > 0)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_upward_rounded,
                                          size: 16,
                                        ),
                                        tooltip: 'Pindah ke atas',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          context.read<TeacherCubit>().moveBab(
                                            bab.id,
                                            widget.lessonId,
                                            'up',
                                          );
                                        },
                                      ),
                                    if (index < babs.length - 1)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_downward_rounded,
                                          size: 16,
                                        ),
                                        tooltip: 'Pindah ke bawah',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          context.read<TeacherCubit>().moveBab(
                                            bab.id,
                                            widget.lessonId,
                                            'down',
                                          );
                                        },
                                      ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.play_circle_outline_rounded,
                                        size: 20,
                                        color: p.primary,
                                      ),
                                      tooltip: 'Simulator Siswa (Pratinjau)',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        final previewData =
                                            SlideAdapter.toLessonDetailData(
                                              id: bab.id,
                                              title: bab.title,
                                              xpReward: bab.xpReward,
                                              rawSlides: bab.slides,
                                            );
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) => LessonReaderPage(
                                              lessonId: widget.lessonId,
                                              isTeacherPreview: true,
                                              previewData: previewData,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      tooltip: 'Edit Bab',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        context.push(
                                          AppRoutes.teacherBabEdit(
                                            widget.lessonId,
                                            bab.id,
                                          ),
                                          extra: bab,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                        color: p.error,
                                      ),
                                      tooltip: 'Hapus Bab',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () =>
                                          _confirmDeleteBab(context, bab),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Bab'),
        onPressed: () {
          context.push(AppRoutes.teacherBabCreate(widget.lessonId));
        },
      ),
    );
  }
}
