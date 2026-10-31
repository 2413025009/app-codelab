// FILE: lib/features/teacher/presentation/pages/teacher_class_analytics_page.dart
//
// TUGAS: Halaman Analitik Kelas & Mode Proyektor Lab Guru (Minggu 12).
// Sesuai Stitch v3: detail_analitik_kelas_guru_x_rpl_1_codelab_ai.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import 'package:mobile_codelab_ai/features/class/domain/class_repository.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';

class TeacherClassAnalyticsPage extends StatefulWidget {
  const TeacherClassAnalyticsPage({super.key, this.classId, this.initialClass});

  final String? classId;
  final ClassInfo? initialClass;

  @override
  State<TeacherClassAnalyticsPage> createState() =>
      _TeacherClassAnalyticsPageState();
}

class _TeacherClassAnalyticsPageState extends State<TeacherClassAnalyticsPage> {
  String? _selectedClassId;
  String _rosterFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _selectedClassId = widget.classId ?? widget.initialClass?.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initOrLoad());
  }

  void _initOrLoad() {
    if (!mounted) return;
    final cubit = context.read<TeacherCubit>();
    final classes = cubit.state.classes;
    if (_selectedClassId == null || _selectedClassId!.isEmpty) {
      if (classes.isNotEmpty) {
        setState(() => _selectedClassId = classes.first.id);
        cubit.loadClassAnalytics(classes.first.id);
      } else {
        cubit.loadDashboard().then((_) {
          if (!mounted) return;
          final updated = context.read<TeacherCubit>().state.classes;
          if (updated.isNotEmpty) {
            setState(() => _selectedClassId = updated.first.id);
            context.read<TeacherCubit>().loadClassAnalytics(updated.first.id);
          }
        });
      }
    } else {
      cubit.loadClassAnalytics(_selectedClassId!);
      if (classes.isEmpty) {
        cubit.loadDashboard();
      }
    }
  }

  void _selectClass(String id) {
    if (_selectedClassId == id) return;
    setState(() => _selectedClassId = id);
    context.go(AppRoutes.teacherAnalyticsRoute(id));
  }

  ClassInfo? _findClass(BuildContext context) {
    // Wajib `watch`, bukan `read`: kartu kode kelas harus ikut berubah saat
    // kode diacak ulang (state.classes diganti dengan kode terbaru).
    final classes = context.watch<TeacherCubit>().state.classes;
    final activeId =
        _selectedClassId ?? widget.classId ?? widget.initialClass?.id;
    if (activeId != null) {
      final found = classes.where((c) => c.id == activeId).firstOrNull;
      if (found != null) return found;
    }
    if (widget.initialClass != null) return widget.initialClass;
    return classes.isNotEmpty ? classes.first : null;
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    showAppSnack(context, 'Kode kelas "$code" disalin ke clipboard!');
  }

  void _showFullscreenProjector(String code, String className) {
    final p = context.palette;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: p.surface,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - AppSpacing.screen * 2)
                      .clamp(0.0, double.infinity)
                      .toDouble(),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, size: 28),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: p.primaryContainer.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fullscreen_rounded,
                              color: p.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'KODE KELAS (LAYAR PENUH)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelL.copyWith(
                                  color: p.primary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        className,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleL.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Buka aplikasi CodeLab AI dan masukkan kode kelas:',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyL.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: p.surfaceAlt,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: p.outline, width: 2),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            code,
                            style: AppTypography.titleL.copyWith(
                              color: p.primary,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Salin Kode'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _copyCode(code),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClassOptionsMenu(BuildContext context, ClassInfo room) {
    final p = context.palette;
    final cubit = context.read<TeacherCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'Opsi Kelas: ${room.name}',
                style: AppTypography.titleM.copyWith(color: p.text),
              ),
              const SizedBox(height: AppSpacing.md),

              // Acak ulang kode
              ListTile(
                leading: Icon(Icons.refresh_rounded, color: p.primary),
                title: Text(
                  'Acak Ulang Kode Kelas',
                  style: AppTypography.labelL.copyWith(color: p.text),
                ),
                subtitle: const Text('Hasilkan kode kelas baru.'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  cubit.regenerateClassCode(room.id);
                },
              ),

              // Arsip kelas
              ListTile(
                leading: Icon(Icons.archive_outlined, color: p.error),
                title: Text(
                  'Arsipkan Kelas',
                  style: AppTypography.labelL.copyWith(color: p.error),
                ),
                subtitle: const Text('Siswa tidak dapat bergabung lagi.'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  cubit.archiveClass(room.id);
                  // Dari tab analitik (StatefulShellRoute) belum tentu ada
                  // halaman untuk di-pop; kembali ke dashboard selalu aman.
                  context.go(AppRoutes.teacherHome);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTutorGroups(BuildContext context, List<StudentRosterRow> roster) {
    final p = context.palette;
    final tutors = roster.where((s) => s.completedCount > 0).toList()
      ..sort((a, b) => b.completedCount.compareTo(a.completedCount));
    final mentees = roster.where((s) => s.completedCount == 0).toList();
    final pairs = <MapEntry<StudentRosterRow, StudentRosterRow>>[];
    if (tutors.isNotEmpty) {
      for (var i = 0; i < mentees.length; i++) {
        pairs.add(MapEntry(tutors[i % tutors.length], mentees[i]));
      }
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.8,
          ),
          child: Padding(
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
                  'Saran Kelompok Tutor Sebaya',
                  style: AppTypography.titleM.copyWith(color: p.text),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tutors.isEmpty
                      ? 'Belum ada siswa dengan bab tuntas. Saran kelompok akan muncul setelah ada siswa yang menyelesaikan bab.'
                      : mentees.isEmpty
                      ? 'Semua siswa sudah memiliki bab tuntas. Tidak ada siswa yang perlu pendampingan saat ini.'
                      : 'Pasangan berikut disusun dari data bab tuntas: siswa dengan capaian tertinggi mendampingi siswa yang belum tuntas.',
                  style: AppTypography.bodySm.copyWith(color: p.textMuted),
                ),
                const SizedBox(height: AppSpacing.md),
                if (pairs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    child: Icon(
                      Icons.groups_rounded,
                      size: 48,
                      color: p.textMuted,
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: pairs.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final pair = pairs[index];
                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: p.surfaceAlt,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.group_work_rounded,
                                color: p.primary,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tutor: ${pair.key.name}',
                                      style: AppTypography.labelM.copyWith(
                                        color: p.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Pendamping: ${pair.value.name}',
                                      style: AppTypography.bodySm.copyWith(
                                        color: p.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${pair.key.completedCount} bab',
                                style: AppTypography.caption.copyWith(
                                  color: p.success,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Tutup',
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final room = _findClass(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisa Kelas'),
        leading: widget.classId == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Kembali',
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.teacherHome);
                  }
                },
              ),
        actions: [
          if (room != null)
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              tooltip: 'Opsi Kelas',
              onPressed: () => _showClassOptionsMenu(context, room),
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
            final analytics = state.analytics;
            final roster = state.roster;
            final classCode = room?.classCode ?? 'RPL-XXX';
            final className = room?.name ?? 'Kelas Laboratorium';

            if (state.isLoading && analytics == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: p.primary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Memuat data analisa kelas...',
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.classes.isEmpty && !state.isLoading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        'Buat kelas pertamamu di Dashboard untuk memantau analitik kurikulum dan progres belajar siswa.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Buka Dashboard',
                        leadingIcon: Icons.dashboard_rounded,
                        onPressed: () => context.go(AppRoutes.teacherHome),
                      ),
                    ],
                  ),
                ),
              );
            }

            final activeClassId =
                room?.id ??
                (state.classes.isNotEmpty ? state.classes.first.id : '');

            return RefreshIndicator(
              onRefresh: () async {
                if (activeClassId.isNotEmpty) {
                  await context.read<TeacherCubit>().loadClassAnalytics(
                    activeClassId,
                  );
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Class Selector Tabs (if more than 1 class)
                    if (state.classes.length > 1) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: state.classes.map((c) {
                            final isSelected = c.id == activeClassId;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(c.name),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) _selectClass(c.id);
                                },
                                selectedColor: p.primary,
                                labelStyle: AppTypography.labelSm.copyWith(
                                  color: isSelected ? Colors.white : p.text,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                backgroundColor: p.surfaceAlt,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    // Class Header Title
                    Text(
                      className,
                      style: AppTypography.titleL.copyWith(color: p.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${room?.schoolName ?? 'Sekolah belum diatur'} • Tahun Ajaran ${room?.academicYear ?? '-'}",
                      style: AppTypography.bodySm.copyWith(color: p.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Projector Lab Banner (Hero Card)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.outline),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: p.primaryContainer.withAlpha(40),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.qr_code_rounded,
                                      size: 14,
                                      color: p.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Kode Kelas',
                                      style: AppTypography.labelSm.copyWith(
                                        color: p.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock_open_rounded,
                                    size: 14,
                                    color: p.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Siap Join',
                                    style: AppTypography.labelSm.copyWith(
                                      color: p.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Bagikan kode ini agar siswa dapat bergabung ke kelas:',
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Monospace Code Box
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: p.surfaceAlt,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              classCode,
                              style: AppTypography.titleL.copyWith(
                                color: p.primary,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Quick Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(
                                    Icons.copy_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Salin Kode'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: p.primary,
                                    side: BorderSide(color: p.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () => _copyCode(classCode),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.fullscreen_rounded,
                                    size: 20,
                                  ),
                                  label: const Text('Perbesar ↗'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: p.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () => _showFullscreenProjector(
                                    classCode,
                                    className,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 4 Track Progress Bars
                    Text(
                      'Kemajuan Kurikulum Per Track',
                      style: AppTypography.titleM.copyWith(color: p.text),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.outline),
                      ),
                      child: Column(
                        children: [
                          if (analytics?.trackBars.isEmpty ?? true)
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Text(
                                'Data track akan terisi otomatis setelah siswa mulai belajar.',
                                style: AppTypography.bodySm.copyWith(
                                  color: p.textMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          else
                            for (final bar in analytics!.trackBars) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bar.track,
                                    style: AppTypography.labelL.copyWith(
                                      color: p.text,
                                    ),
                                  ),
                                  Text(
                                    '${bar.avgPercent.toStringAsFixed(1)}%',
                                    style: AppTypography.codeSm.copyWith(
                                      color: p.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (bar.avgPercent / 100).clamp(0.0, 1.0),
                                  backgroundColor: p.surfaceAlt,
                                  color: p.primary,
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Bab Tersulit / Diagnostik
                    Text(
                      'Bab Tersulit (Perlu Pendampingan)',
                      style: AppTypography.titleM.copyWith(color: p.text),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (analytics?.hardestChapters.isEmpty ?? true)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: p.surface,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(color: p.outline),
                        ),
                        child: Center(
                          child: Text(
                            'Tidak ada tantangan yang terdeteksi sulit pada kelas ini 🎉',
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      for (final h in analytics!.hardestChapters)
                        Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: p.surface,
                            borderRadius: AppRadius.cardBorder,
                            border: Border.all(color: p.outline),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: p.accent,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  h.lessonTitle,
                                  style: AppTypography.labelL.copyWith(
                                    color: p.text,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: p.error.withAlpha(30),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${h.failCount} siswa gagal',
                                  style: AppTypography.labelSm.copyWith(
                                    color: p.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: AppSpacing.lg),

                    // Leaderboard Roster & Filter Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Peringkat Siswa Kelas',
                          style: AppTypography.titleM.copyWith(
                            color: p.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${roster.length} Siswa',
                          style: AppTypography.codeSm.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Filter Chips: Semua, Tuntas, Perlu Bimbingan
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text('Semua (${roster.length})'),
                            selected: _rosterFilter == 'ALL',
                            selectedColor: p.primary,
                            labelStyle: AppTypography.labelSm.copyWith(
                              color: _rosterFilter == 'ALL'
                                  ? Colors.white
                                  : p.text,
                              fontWeight: _rosterFilter == 'ALL'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() => _rosterFilter = 'ALL');
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(
                              'Tuntas (${roster.where((s) => s.completedCount > 0).length})',
                            ),
                            selected: _rosterFilter == 'TUNTAS',
                            selectedColor: p.success,
                            labelStyle: AppTypography.labelSm.copyWith(
                              color: _rosterFilter == 'TUNTAS'
                                  ? Colors.white
                                  : p.text,
                              fontWeight: _rosterFilter == 'TUNTAS'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() => _rosterFilter = 'TUNTAS');
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: Text(
                              'Perlu Bimbingan (${roster.where((s) => s.completedCount == 0).length})',
                            ),
                            selected: _rosterFilter == 'BIMBINGAN',
                            selectedColor: p.accent,
                            labelStyle: AppTypography.labelSm.copyWith(
                              color: _rosterFilter == 'BIMBINGAN'
                                  ? Colors.white
                                  : p.text,
                              fontWeight: _rosterFilter == 'BIMBINGAN'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() => _rosterFilter = 'BIMBINGAN');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Saran kelompok tutor sebaya (dihitung dari data nyata).
                    if (roster.isNotEmpty) ...[
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          foregroundColor: p.primary,
                          side: BorderSide(color: p.primary.withAlpha(120)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.group_work_rounded, size: 18),
                        label: const Text('Saran Kelompok Tutor Sebaya'),
                        onPressed: () => _showTutorGroups(context, roster),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],

                    if (roster.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: p.surface,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(color: p.outline),
                        ),
                        child: Center(
                          child: Text(
                            'Belum ada siswa yang bergabung di kelas ini.',
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      () {
                        final displayedRoster = roster.where((s) {
                          if (_rosterFilter == 'TUNTAS') {
                            return s.completedCount > 0;
                          }
                          if (_rosterFilter == 'BIMBINGAN') {
                            return s.completedCount == 0;
                          }
                          return true;
                        }).toList();

                        if (displayedRoster.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Center(
                              child: Text(
                                'Tidak ada siswa pada kategori filter ini.',
                                style: AppTypography.bodySm.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedRoster.length,
                          itemBuilder: (ctx, i) {
                            final student = displayedRoster[i];
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: AppSpacing.xs,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: p.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: p.outline),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: i < 3
                                          ? p.primaryContainer.withAlpha(40)
                                          : p.surfaceAlt,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${i + 1}',
                                      style: AppTypography.codeSm.copyWith(
                                        color: i < 3 ? p.primary : p.textMuted,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: AppTypography.labelL.copyWith(
                                            color: p.text,
                                          ),
                                        ),
                                        Text(
                                          student.completedCount > 0
                                              ? (student.lastBabTitle.isNotEmpty
                                                    ? '${student.lastBabTitle} • ${student.completedCount} bab tuntas'
                                                    : '${student.completedCount} bab tuntas')
                                              : 'Perlu Pendampingan Guru',
                                          style: AppTypography.caption.copyWith(
                                            color: student.completedCount > 0
                                                ? p.success
                                                : p.accent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bolt_rounded,
                                        color: p.accent,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${student.xpPoints} XP',
                                        style: AppTypography.codeSm.copyWith(
                                          color: p.text,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
