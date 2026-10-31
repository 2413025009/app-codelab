// FILE: lib/features/teacher/presentation/pages/teacher_archived_classes_page.dart
//
// TUGAS: Layar "Arsip Kelas" — tempat guru melihat rombel yang sudah
// diarsipkan dan memulihkannya bila perlu. Sebelumnya fitur arsip ada tetapi
// tidak punya layar tujuan sama sekali.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import 'package:mobile_codelab_ai/features/class/domain/class_repository.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';

class TeacherArchivedClassesPage extends StatefulWidget {
  const TeacherArchivedClassesPage({super.key});

  @override
  State<TeacherArchivedClassesPage> createState() =>
      _TeacherArchivedClassesPageState();
}

class _TeacherArchivedClassesPageState
    extends State<TeacherArchivedClassesPage> {
  String? _shownError;

  @override
  void initState() {
    super.initState();
    context.read<TeacherCubit>().loadArchivedClasses();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arsip Kelas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.teacherHome),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<TeacherCubit, TeacherState>(
          listener: (context, state) {
            if (state.isLoading) _shownError = null;
            if (state.errorMessage != null) {
              // Tampilkan sekali; state error tetap disimpan agar layar bisa
              // menampilkan kartu "gagal memuat" alih-alih empty state palsu.
              if (_shownError != state.errorMessage) {
                _shownError = state.errorMessage;
                showAppSnack(context, state.errorMessage!);
              }
            } else if (state.actionSuccessMessage != null) {
              showAppSnack(context, state.actionSuccessMessage!);
              context.read<TeacherCubit>().clearMessages();
            }
          },
          builder: (context, state) {
            final archived = state.archivedClasses;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<TeacherCubit>().loadArchivedClasses(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screen),
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: p.surfaceAlt,
                      borderRadius: AppRadius.cardBorder,
                      border: Border.all(color: p.outline),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: p.textMuted,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Kelas arsip tidak bisa diikuti siswa baru. '
                            'Pulihkan kelas bila ingin mengaktifkannya lagi.',
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (state.isLoading && archived.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state.errorMessage != null && archived.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.error.withAlpha(90)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_off_rounded,
                            size: 48,
                            color: p.error,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Gagal Memuat Arsip',
                            style: AppTypography.titleM.copyWith(color: p.text),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyM.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            label: 'Coba Lagi',
                            leadingIcon: Icons.refresh_rounded,
                            onPressed: () => context
                                .read<TeacherCubit>()
                                .loadArchivedClasses(),
                          ),
                        ],
                      ),
                    )
                  else if (archived.isEmpty)
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
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: p.textMuted,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Belum Ada Kelas Diarsipkan',
                            style: AppTypography.titleM.copyWith(color: p.text),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Kelas yang kamu arsipkan dari halaman analitik '
                            'akan muncul di sini.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyM.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            label: 'Kembali ke Dashboard',
                            leadingIcon: Icons.dashboard_rounded,
                            onPressed: () => context.go(AppRoutes.teacherHome),
                          ),
                        ],
                      ),
                    )
                  else
                    for (final room in archived) _ArchivedClassCard(room: room),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ArchivedClassCard extends StatelessWidget {
  const _ArchivedClassCard({required this.room});

  final ClassInfo room;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final cubit = context.read<TeacherCubit>();
    final isLoading = context.watch<TeacherCubit>().state.isLoading;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Diarsipkan',
                  style: AppTypography.labelSm.copyWith(
                    color: p.textMuted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.person_rounded, size: 14, color: p.textMuted),
              const SizedBox(width: 4),
              Text(
                '${room.memberCount} Siswa',
                style: AppTypography.labelSm.copyWith(color: p.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            room.name,
            style: AppTypography.titleM.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${room.schoolName} • Tahun Ajaran ${room.academicYear}',
            style: AppTypography.bodySm.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: p.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KODE KELAS',
                      style: AppTypography.labelSm.copyWith(
                        color: p.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      room.classCode,
                      style: AppTypography.titleM.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Nonaktif',
                  style: AppTypography.labelSm.copyWith(color: p.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Pulihkan Kelas',
            leadingIcon: Icons.unarchive_rounded,
            onPressed: isLoading ? null : () => cubit.restoreClass(room.id),
          ),
        ],
      ),
    );
  }
}
