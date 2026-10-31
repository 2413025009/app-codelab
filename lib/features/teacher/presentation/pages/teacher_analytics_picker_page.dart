// FILE: lib/features/teacher/presentation/pages/teacher_analytics_picker_page.dart
//
// TUGAS: Layar pemilih kelas untuk tab "Analisa".
// Route /analisa-pengajar hanya menampilkan daftar kelas; analisa satu kelas
// punya layar sendiri di /analisa-pengajar/:classId.

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

class TeacherAnalyticsPickerPage extends StatefulWidget {
  const TeacherAnalyticsPickerPage({super.key});

  @override
  State<TeacherAnalyticsPickerPage> createState() =>
      _TeacherAnalyticsPickerPageState();
}

class _TeacherAnalyticsPickerPageState
    extends State<TeacherAnalyticsPickerPage> {
  String? _shownError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<TeacherCubit>();
      // Dashboard/profil biasanya sudah memuat daftar kelas; hindari memuat
      // ulang saat layar ini dibuka dari deep link agar tidak beradu dengan
      // permintaan analisa kelas di layar anak.
      if (cubit.state.classes.isEmpty) {
        cubit.loadDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('Analisa Kelas')),
      body: SafeArea(
        child: BlocConsumer<TeacherCubit, TeacherState>(
          listener: (context, state) {
            if (state.isLoading) _shownError = null;
            if (state.errorMessage != null) {
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
            final classes = state.classes;

            return RefreshIndicator(
              onRefresh: () => context.read<TeacherCubit>().loadDashboard(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screen),
                children: [
                  Text(
                    'Pilih Kelas',
                    style: AppTypography.titleL.copyWith(color: p.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih kelas untuk melihat peringkat materi dan latihan '
                    'siswa, lalu kelola anggotanya.',
                    style: AppTypography.bodySm.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (state.isLoading && classes.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (classes.isEmpty)
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
                            Icons.analytics_outlined,
                            size: 56,
                            color: p.textMuted,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Belum Ada Kelas',
                            style: AppTypography.titleL.copyWith(color: p.text),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Buat kelas pertamamu di Dashboard untuk mulai '
                            'memantau analisa siswa.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyM.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            label: 'Buka Dashboard',
                            leadingIcon: Icons.dashboard_rounded,
                            onPressed: () => context.go(AppRoutes.teacherHome),
                          ),
                        ],
                      ),
                    )
                  else
                    for (final room in classes)
                      _ClassAnalyticsCard(room: room),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ClassAnalyticsCard extends StatelessWidget {
  const _ClassAnalyticsCard({required this.room});

  final ClassInfo room;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        child: InkWell(
          borderRadius: AppRadius.cardBorder,
          onTap: () => context.go(AppRoutes.teacherAnalyticsRoute(room.id)),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.cardBorder,
              border: Border.all(color: p.outline),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: p.primaryContainer.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics_rounded,
                    color: p.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelL.copyWith(
                          color: p.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${room.schoolName.isEmpty ? 'Sekolah belum diatur' : room.schoolName} • ${room.academicYear}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySm.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${room.memberCount} siswa',
                        style: AppTypography.caption.copyWith(
                          color: p.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: p.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
