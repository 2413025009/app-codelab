// FILE: lib/features/teacher/presentation/pages/teacher_dashboard_page.dart
//
// TUGAS: Dashboard Guru "Ruang Kelas Saya" (Minggu 11-12).
// Sesuai desain Stitch v3: dashboard_guru_ruang_kelas_saya_codelab_ai.

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
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/teacher_class_filter.dart';
import 'package:mobile_codelab_ai/features/class/domain/class_repository.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  String _classQuery = '';
  String? _academicYearFilter;

  @override
  void initState() {
    super.initState();
    context.read<TeacherCubit>().loadDashboard();
  }

  bool get _hasClassFilter =>
      _classQuery.trim().isNotEmpty || _academicYearFilter != null;

  void _clearClassFilters() {
    setState(() {
      _classQuery = '';
      _academicYearFilter = null;
    });
  }

  Future<void> _openClassFilterSheet(List<ClassInfo> classes) async {
    final p = context.palette;
    final searchCtrl = TextEditingController(text: _classQuery);
    var selectedYear = _academicYearFilter;
    final years =
        classes
            .map((room) => room.academicYear.trim())
            .where((year) => year.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final result = await showModalBottomSheet<_ClassFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
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
                    'Filter Daftar Kelas',
                    style: AppTypography.titleM.copyWith(color: p.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pencarian dan tahun ajaran disaring dari data kelas yang sudah dimuat.',
                    style: AppTypography.bodySm.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: searchCtrl,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau kode kelas',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: searchCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Bersihkan pencarian',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                searchCtrl.clear();
                                setSheetState(() {});
                              },
                            ),
                      filled: true,
                      fillColor: p.surfaceAlt,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (_) => setSheetState(() {}),
                  ),
                  if (years.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Tahun Ajaran',
                      style: AppTypography.labelSm.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Semua'),
                          selected: selectedYear == null,
                          selectedColor: p.primaryContainer,
                          onSelected: (_) =>
                              setSheetState(() => selectedYear = null),
                        ),
                        for (final year in years)
                          ChoiceChip(
                            label: Text(year),
                            selected: selectedYear == year,
                            selectedColor: p.primaryContainer,
                            onSelected: (_) =>
                                setSheetState(() => selectedYear = year),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            searchCtrl.clear();
                            setSheetState(() => selectedYear = null);
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(
                            _ClassFilterResult(
                              query: searchCtrl.text.trim(),
                              year: selectedYear,
                            ),
                          ),
                          child: const Text('Terapkan Filter'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    searchCtrl.dispose();
    if (!mounted || result == null) return;
    setState(() {
      _classQuery = result.query;
      _academicYearFilter = result.year;
    });
  }

  void _copyClassCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    showAppSnack(context, 'Kode kelas "$code" disalin ke clipboard!');
  }

  void _showFullscreenProjector(
    BuildContext context,
    String code,
    String className,
  ) {
    final p = context.palette;
    showDialog<void>(
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
                        onPressed: () => _copyClassCode(code),
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

  void _openCreateClassSheet(BuildContext context) {
    final p = context.palette;
    final now = DateTime.now();
    final academicStart = now.month >= 7 ? now.year : now.year - 1;
    final nameCtrl = TextEditingController();
    final yearCtrl = TextEditingController(
      text: '$academicStart/${academicStart + 1}',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SafeArea(
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
                  'Buat Kelas Baru',
                  style: AppTypography.titleM.copyWith(color: p.text),
                ),
                Text(
                  'Wadah identitas kelas untuk memantau kemajuan belajar siswa.',
                  style: AppTypography.bodySm.copyWith(color: p.textMuted),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Nama Kelas
                Text(
                  'Nama Kelas *',
                  style: AppTypography.labelSm.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Contoh: X RPL 1',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Tahun Ajaran
                Text(
                  'Tahun Ajaran *',
                  style: AppTypography.labelSm.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: yearCtrl,
                  decoration: InputDecoration(
                    hintText: 'Contoh: $academicStart/${academicStart + 1}',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                AppButton(
                  label: 'Buat Kelas',
                  leadingIcon: Icons.add_circle_outline_rounded,
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final year = yearCtrl.text.trim();
                    if (name.isEmpty || year.isEmpty) {
                      showAppSnack(
                        ctx,
                        'Nama kelas dan tahun ajaran wajib diisi.',
                      );
                      return;
                    }
                    Navigator.of(ctx).pop();
                    context.read<TeacherCubit>().createClass(
                      name: name,
                      academicYear: year,
                      scheduleNote: '',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      nameCtrl.dispose();
      yearCtrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;
    final schoolName = user?.schoolName?.trim() ?? '';
    final schoolLabel = schoolName.isEmpty
        ? 'Sekolah belum terhubung'
        : schoolName;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${user?.name ?? 'Guru'} 👋',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleM.copyWith(color: p.text),
            ),
            Text(
              schoolLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(color: p.textMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Profil Pengajar',
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.go(AppRoutes.teacherProfile),
          ),
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.teacherSettings),
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
            final classes = state.classes;
            final filteredClasses = filterTeacherClasses(
              classes,
              query: _classQuery,
              academicYear: _academicYearFilter,
            );
            final studentCount = state.totalStudentCount;

            return RefreshIndicator(
              onRefresh: () => context.read<TeacherCubit>().loadDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.screen,
                  AppSpacing.screen,
                  96,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Quick Metrics Summary Cards
                    Row(
                      children: [
                        // Card 1: Rombel Aktif
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: p.surface,
                              borderRadius: AppRadius.cardBorder,
                              border: Border.all(color: p.outline),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: p.primaryContainer.withAlpha(40),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.co_present_rounded,
                                        color: p.primary,
                                        size: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: p.surfaceAlt,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Total',
                                        style: AppTypography.labelSm.copyWith(
                                          color: p.textMuted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '${classes.length} Kelas',
                                  style: AppTypography.titleM.copyWith(
                                    color: p.text,
                                  ),
                                ),
                                Text(
                                  'Kelas Aktif',
                                  style: AppTypography.bodySm.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),

                        // Card 2: Siswa Terbimbing
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: p.surface,
                              borderRadius: AppRadius.cardBorder,
                              border: Border.all(color: p.outline),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: p.accent.withAlpha(40),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.groups_rounded,
                                        color: p.accent,
                                        size: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: p.surfaceAlt,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Terdaftar',
                                        style: AppTypography.labelSm.copyWith(
                                          color: p.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '$studentCount Siswa',
                                  style: AppTypography.titleM.copyWith(
                                    color: p.text,
                                  ),
                                ),
                                Text(
                                  'Siswa Terdaftar',
                                  style: AppTypography.bodySm.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 2. Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daftar Kelas Belajar',
                                style: AppTypography.titleM.copyWith(
                                  color: p.text,
                                ),
                              ),
                              Text(
                                'Pilih kelas untuk memantau kemajuan atau bagikan kode.',
                                style: AppTypography.bodySm.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          tooltip: 'Filter daftar kelas',
                          onPressed: classes.isEmpty
                              ? null
                              : () => _openClassFilterSheet(classes),
                          icon: Icon(
                            _hasClassFilter
                                ? Icons.filter_alt_rounded
                                : Icons.filter_list_rounded,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            foregroundColor: p.primary,
                            backgroundColor: _hasClassFilter
                                ? p.primaryContainer.withAlpha(40)
                                : null,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              context.push(AppRoutes.teacherArchivedClasses),
                          icon: const Icon(
                            Icons.inventory_2_outlined,
                            size: 18,
                          ),
                          label: const Text('Arsip'),
                          style: TextButton.styleFrom(
                            foregroundColor: p.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_hasClassFilter) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (_classQuery.trim().isNotEmpty)
                            InputChip(
                              label: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 170,
                                ),
                                child: Text(
                                  'Cari: ${_classQuery.trim()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              onDeleted: () => setState(() => _classQuery = ''),
                            ),
                          if (_academicYearFilter != null)
                            InputChip(
                              label: Text(_academicYearFilter!),
                              onDeleted: () =>
                                  setState(() => _academicYearFilter = null),
                            ),
                          TextButton(
                            onPressed: _clearClassFilters,
                            child: const Text('Reset filter'),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),

                    // 3. Class List
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
                              Icons.school_rounded,
                              size: 48,
                              color: p.textMuted,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Belum Ada Kelas',
                              style: AppTypography.titleM.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Buat kelas pertamamu untuk mendapatkan kode kelas dan mulai memantau kemajuan belajar siswa.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            AppButton(
                              label: 'Buat Kelas Baru',
                              leadingIcon: Icons.add_rounded,
                              onPressed: () => _openCreateClassSheet(context),
                            ),
                          ],
                        ),
                      )
                    else if (filteredClasses.isEmpty)
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
                              Icons.filter_alt_off_rounded,
                              size: 48,
                              color: p.textMuted,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Tidak Ada Kelas yang Cocok',
                              style: AppTypography.titleM.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Coba kata kunci lain atau tampilkan semua tahun ajaran.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            OutlinedButton.icon(
                              onPressed: _clearClassFilters,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Tampilkan Semua Kelas'),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredClasses.length,
                        itemBuilder: (ctx, index) {
                          final room = filteredClasses[index];
                          return _buildClassCard(context, room, p);
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
        label: const Text('Buat Kelas'),
        onPressed: () => _openCreateClassSheet(context),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassInfo room, AppPalette p) {
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: p.primaryContainer.withAlpha(35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Aktif ${room.academicYear}',
                  style: AppTypography.labelSm.copyWith(
                    color: p.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.person_rounded, size: 14, color: p.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${room.memberCount} Siswa',
                    style: AppTypography.labelSm.copyWith(color: p.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title
          Text(
            room.name,
            style: AppTypography.titleM.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Data kelas nyata (bukan angka demo).
          Row(
            children: [
              Expanded(
                child: _MetaPill(
                  icon: Icons.calendar_month_rounded,
                  label: 'Tahun Ajaran',
                  value: room.academicYear,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetaPill(
                  icon: Icons.groups_rounded,
                  label: 'Anggota',
                  value: '${room.memberCount} siswa',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Kode Kelas Box
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
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Salin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.surface,
                    foregroundColor: p.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: p.outline),
                    ),
                  ),
                  onPressed: () => _copyClassCode(room.classCode),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Actions
          LayoutBuilder(
            builder: (context, constraints) {
              final projector = OutlinedButton.icon(
                icon: const Icon(Icons.tv_rounded, size: 18),
                label: const Text('Proyektor Kode'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  foregroundColor: p.primary,
                  side: BorderSide(color: p.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _showFullscreenProjector(
                  context,
                  room.classCode,
                  room.name,
                ),
              );
              final monitor = ElevatedButton.icon(
                icon: const Icon(Icons.query_stats_rounded, size: 18),
                label: const Text('Pantau Kelas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  context.push(
                    AppRoutes.teacherClassAnalytics(room.id),
                    extra: room,
                  );
                },
              );

              // Di layar sempit dua tombol berlabel panjang tidak muat
              // berdampingan; susun vertikal agar tidak overflow.
              if (constraints.maxWidth < 360) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    projector,
                    const SizedBox(height: AppSpacing.sm),
                    monitor,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: projector),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: monitor),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ClassFilterResult {
  const _ClassFilterResult({required this.query, this.year});

  final String query;
  final String? year;
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: p.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: p.textMuted,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.w600,
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
