// FILE: lib/features/teacher/presentation/pages/teacher_class_analytics_page.dart
//
// TUGAS: Halaman Analisa Kelas & Mode Proyektor Lab Guru (Minggu 12).
// Sesuai Stitch v3: detail_analisa_kelas_guru_x_rpl_1_codelab_ai.

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
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';
import 'package:mobile_codelab_ai/features/class/domain/class_repository.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';
import '../cubit/teacher_cubit.dart';
import '../cubit/teacher_state.dart';

class TeacherClassAnalyticsPage extends StatefulWidget {
  const TeacherClassAnalyticsPage({super.key, required this.classId});

  /// Kelas yang dianalisa. Route: /analisa-kelas-pengajar/:classId
  final String classId;

  @override
  State<TeacherClassAnalyticsPage> createState() =>
      _TeacherClassAnalyticsPageState();
}

class _TeacherClassAnalyticsPageState extends State<TeacherClassAnalyticsPage> {
  late String _selectedClassId;
  String _rosterFilter = 'ALL';

  /// Sub-filter "Latihan Terbanyak": SEMUA | BIASA | MINI.
  String _practiceFilter = 'SEMUA';

  /// Sub-filter "Belum Memulai": SEMUA (materi & latihan) | MATERI | LATIHAN.
  String _belumFilter = 'SEMUA';

  /// Materi yang dipakai menyaring daftar siswa (null = semua materi).
  String? _materialFilter;

  /// Peringkat hanya menampilkan 10 siswa teratas per kategori. Daftar siswa
  /// di bawahnya tetap memuat seluruh anggota kelas.
  static const int _maxRankedStudents = 10;

  @override
  void initState() {
    super.initState();
    _selectedClassId = widget.classId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initOrLoad());
  }

  @override
  void didUpdateWidget(covariant TeacherClassAnalyticsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.classId != widget.classId) {
      _selectedClassId = widget.classId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<TeacherCubit>().loadClassAnalytics(widget.classId);
      });
    }
  }

  void _initOrLoad() {
    if (!mounted) return;
    final cubit = context.read<TeacherCubit>();
    cubit.loadClassAnalytics(_selectedClassId);
    if (cubit.state.classes.isEmpty) {
      cubit.loadDashboard();
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
    final found = classes.where((c) => c.id == _selectedClassId).firstOrNull;
    return found;
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    showAppSnack(context, AppLocalizations.of(context).tAnalyticsCodeCopied(code));
  }

  Future<void> _confirmRemoveStudent(StudentRosterRow student) async {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    // `read` (bukan `watch`): method ini dipanggil dari callback, di luar build.
    final classes = context.read<TeacherCubit>().state.classes;
    final room = classes
        .where((item) => item.id == _selectedClassId)
        .firstOrNull;
    final className = room?.name ?? l10n.tAnalyticsThisClass;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.tAnalyticsRemoveTitle),
        content: Text(l10n.tAnalyticsRemoveBody(student.name, className)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: p.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.tAnalyticsRemoveConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await context.read<TeacherCubit>().removeStudentFromClass(
      _selectedClassId,
      student.studentId,
    );
  }

  void _showFullscreenProjector(String code, String className) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
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
                                l10n.tDashCodeFullscreen,
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
                        l10n.tDashProjectorHint,
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
                        label: Text(l10n.tDashProjectorCopy),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primary,
                          foregroundColor: p.onPrimary,
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
                l10n.tAnalyticsClassOptions(room.name),
                style: AppTypography.titleM.copyWith(color: p.text),
              ),
              const SizedBox(height: AppSpacing.md),

              // Acak ulang kode
              ListTile(
                leading: Icon(Icons.refresh_rounded, color: p.primary),
                title: Text(
                  l10n.tAnalyticsRegenerateCode,
                  style: AppTypography.labelL.copyWith(color: p.text),
                ),
                subtitle: Text(l10n.tAnalyticsRegenerateCodeSub),
                onTap: () {
                  Navigator.of(ctx).pop();
                  cubit.regenerateClassCode(room.id);
                },
              ),

              // Arsip kelas
              ListTile(
                leading: Icon(Icons.archive_outlined, color: p.error),
                title: Text(
                  l10n.tAnalyticsArchiveClass,
                  style: AppTypography.labelL.copyWith(color: p.error),
                ),
                subtitle: Text(l10n.tAnalyticsArchiveClassSub),
                onTap: () {
                  Navigator.of(ctx).pop();
                  cubit.archiveClass(room.id);
                  // Dari tab analisa (StatefulShellRoute) belum tentu ada
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

  /// Nilai latihan yang sedang dipakai filter: semua / latihan biasa / mini
  /// proyek. Dipakai untuk penyaringan sekaligus pengurutan.
  int _practiceValue(StudentRosterRow s) {
    switch (_practiceFilter) {
      case 'BIASA':
        return s.regularPracticeCount;
      case 'MINI':
        return s.miniProjectCount;
      default:
        return s.practiceCompletedCount;
    }
  }

  /// Siswa memenuhi sub-filter "Belum Memulai" yang aktif?
  bool _belumMatch(StudentRosterRow s) {
    switch (_belumFilter) {
      case 'MATERI':
        return s.completedCount == 0;
      case 'LATIHAN':
        return s.practiceCompletedCount == 0;
      default:
        return s.completedCount == 0 && s.practiceCompletedCount == 0;
    }
  }

  /// Chip filter kecil yang dipakai berulang di bagian Daftar Siswa.
  Widget _filterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required Color accent,
    required VoidCallback onSelected,
  }) {
    final p = context.palette;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: accent,
      labelStyle: AppTypography.labelSm.copyWith(
        // accent bisa amber terang (p.accent); onPrimary tetap terbaca di
        // kedua mode, sedangkan putih gagal di mode gelap.
        color: selected ? p.onPrimary : p.text,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (val) {
        if (val) onSelected();
      },
    );
  }

  /// Penjelasan spesifik untuk filter yang sedang aktif, supaya guru tahu
  /// persis siswa mana yang muncul dan bagaimana urutannya.
  String _rosterFilterHint(AppLocalizations l10n, List<MaterialProgress> materials) {
    final material = materials
        .where((m) => m.lessonId == _materialFilter)
        .firstOrNull;
    final materi = material == null
        ? ''
        : l10n.tAnalyticsHintMaterialSuffix(material.title);

    switch (_rosterFilter) {
      case 'TUNTAS':
        return l10n.tAnalyticsHintCompleted(materi);
      case 'LATIHAN':
        final jenis = switch (_practiceFilter) {
          'BIASA' => l10n.tAnalyticsPracticeRegular,
          'MINI' => l10n.tAnalyticsPracticeMini,
          _ => l10n.tAnalyticsPracticeAny,
        };
        return l10n.tAnalyticsHintPractice(jenis, materi);
      case 'BELUM':
        final cakupan = switch (_belumFilter) {
          'MATERI' => l10n.tAnalyticsNotStartedMaterial,
          'LATIHAN' => l10n.tAnalyticsNotStartedPractice,
          _ => l10n.tAnalyticsNotStartedBoth,
        };
        return l10n.tAnalyticsHintNotStarted(cakupan, materi);
      default:
        return l10n.tAnalyticsHintAll(materi);
    }
  }

  /// Tombol satu-per-satu untuk tiap materi kurikulum resmi. Menekan tombol
  /// menyaring Daftar Siswa ke materi tersebut (tekan lagi untuk melepas).
  Widget _materialFilterButtons(
    BuildContext context,
    List<MaterialProgress> materials,
    List<StudentRosterRow> roster,
  ) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.filter_list_rounded, size: 16, color: p.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                l10n.tAnalyticsFilterByMaterial,
                style: AppTypography.labelL.copyWith(
                  color: p.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_materialFilter != null)
              TextButton(
                onPressed: () => setState(() => _materialFilter = null),
                child: Text(l10n.tDashFilterReset),
              ),
          ],
        ),
        Text(
          l10n.tAnalyticsFilterByMaterialHint,
          style: AppTypography.caption.copyWith(
            color: p.textMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(
                context,
                label: l10n.tAnalyticsFilterAllMaterials(roster.length),
                selected: _materialFilter == null,
                accent: p.primary,
                onSelected: () => setState(() => _materialFilter = null),
              ),
              for (final m in materials) ...[
                const SizedBox(width: 8),
                _filterChip(
                  context,
                  label: l10n.tAnalyticsFilterMaterialCount(m.title, m.completedCount),
                  selected: _materialFilter == m.lessonId,
                  accent: p.success,
                  onSelected: () => setState(() {
                    _materialFilter = _materialFilter == m.lessonId
                        ? null
                        : m.lessonId;
                  }),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Penjelasan rumus bar "Kemajuan Kurikulum Per Track".
  void _showTrackInfo() {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.tAnalyticsTrackBasisTitle),
        content: SingleChildScrollView(
          child: Text(
            l10n.tAnalyticsTrackBasisBody,
            style: AppTypography.bodySm.copyWith(color: p.text),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.tAnalyticsGotIt),
          ),
        ],
      ),
    );
  }

  /// Susun daftar siswa sesuai filter yang aktif:
  ///  - Semua          : seluruh anggota kelas, materi tuntas terbanyak di atas;
  ///  - Materi Tuntas  : sudah menuntaskan ≥1 materi;
  ///  - Latihan Terbanyak: diurutkan menurut jenis latihan yang dipilih
  ///    (semua / latihan biasa / mini proyek);
  ///  - Belum Memulai  : belum menuntaskan materi & belum menyelesaikan
  ///    latihan, dapat dipersempit ke salah satunya.
  /// Filter materi (`_materialFilter`) berlaku untuk semua kategori.
  List<StudentRosterRow> _displayedRoster(List<StudentRosterRow> roster) {
    final filtered = roster.where((s) {
      if (_materialFilter != null && !s.hasCompletedLesson(_materialFilter!)) {
        return false;
      }
      switch (_rosterFilter) {
        case 'TUNTAS':
          return s.completedCount > 0;
        case 'LATIHAN':
          return _practiceValue(s) > 0;
        case 'BELUM':
          return _belumMatch(s);
        default:
          return true;
      }
    }).toList();

    int byName(StudentRosterRow a, StudentRosterRow b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase());

    filtered.sort((a, b) {
      if (_rosterFilter == 'LATIHAN') {
        final byPractice = _practiceValue(b).compareTo(_practiceValue(a));
        if (byPractice != 0) return byPractice;
      } else if (_rosterFilter == 'BELUM') {
        final byPractice = b.practiceCompletedCount.compareTo(
          a.practiceCompletedCount,
        );
        if (byPractice != 0) return byPractice;
      }
      final byMaterial = b.completedCount.compareTo(a.completedCount);
      if (byMaterial != 0) return byMaterial;
      final byPractice = b.practiceCompletedCount.compareTo(
        a.practiceCompletedCount,
      );
      if (byPractice != 0) return byPractice;
      return byName(a, b);
    });
    return filtered;
  }

  /// Papan peringkat kecil untuk satu kategori (Materi / Latihan).
  /// Dua papan ini ditampilkan bersampingan, bukan sebagai section terpisah.
  Widget _rankPanel(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
    required List<StudentRosterRow> roster,
    required int Function(StudentRosterRow) valueOf,
  }) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final ranked = roster.where((s) => valueOf(s) > 0).toList()
      ..sort((a, b) {
        final byValue = valueOf(b).compareTo(valueOf(a));
        return byValue != 0 ? byValue : a.name.compareTo(b.name);
      });
    final visible = ranked.take(_maxRankedStudents).toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelL.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                l10n.tAnalyticsNoStudents,
                style: AppTypography.bodySm.copyWith(color: p.textMuted),
              ),
            )
          else
            for (var i = 0; i < visible.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      // 26px cukup untuk nomor 2-3 digit tanpa pecah vertikal.
                      width: 26,
                      child: Text(
                        '${i + 1}',
                        maxLines: 1,
                        softWrap: false,
                        style: AppTypography.codeSm.copyWith(
                          color: i < 3 ? accent : p.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        visible[i].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySm.copyWith(color: p.text),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${valueOf(visible[i])}',
                      style: AppTypography.codeSm.copyWith(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final room = _findClass(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tAnalyticsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: l10n.actionBack,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.teacherAnalytics);
            }
          },
        ),
        actions: [
          if (room != null)
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              tooltip: l10n.tAnalyticsClassOptionsLabel,
              onPressed: () => _showClassOptionsMenu(context, room),
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
            final analytics = state.analytics;
            final roster = state.roster;
            final materials =
                analytics?.materials ?? const <MaterialProgress>[];
            final classCode = room?.classCode ?? 'XXX-XXX';
            final className = room?.name ?? l10n.tAnalyticsLabClass;

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
                        l10n.tAnalyticsLoading,
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
                        l10n.tPickerEmptyTitle,
                        style: AppTypography.titleL.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.tAnalyticsEmptyBody,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: l10n.tPickerOpenDashboard,
                        leadingIcon: Icons.dashboard_rounded,
                        onPressed: () => context.go(AppRoutes.teacherHome),
                      ),
                    ],
                  ),
                ),
              );
            }

            final activeClassId = _selectedClassId;

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
                                  color: isSelected ? p.onPrimary : p.text,
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
                      "${room?.schoolName ?? l10n.tPickerSchoolUnset} • ${l10n.tAnalyticsAcademicYear(room?.academicYear ?? '-')}",
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
                                      l10n.tAnalyticsClassCode,
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
                                    l10n.tAnalyticsReadyJoin,
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
                            l10n.tAnalyticsShareCodeHint,
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
                                  label: Text(l10n.tDashProjectorCopy),
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
                                  label: Text(l10n.tAnalyticsEnlarge),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: p.primary,
                                    foregroundColor: p.onPrimary,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.tAnalyticsTrackTitle,
                            style: AppTypography.titleM.copyWith(color: p.text),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline_rounded),
                          iconSize: 18,
                          color: p.textMuted,
                          tooltip: l10n.tAnalyticsTrackTooltip,
                          visualDensity: VisualDensity.compact,
                          onPressed: _showTrackInfo,
                        ),
                      ],
                    ),
                    Text(
                      l10n.tAnalyticsTrackSubtitle,
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                        fontSize: 11,
                      ),
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
                                l10n.tAnalyticsTrackEmpty,
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
                      l10n.tAnalyticsHardestTitle,
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
                            l10n.tAnalyticsHardestEmpty,
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
                                  l10n.tAnalyticsFailCount(h.failCount),
                                  style: AppTypography.labelSm.copyWith(
                                    color: p.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: AppSpacing.lg),

                    // Peringkat Siswa: materi & latihan bersampingan.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.tAnalyticsRankingTitle,
                          style: AppTypography.titleM.copyWith(
                            color: p.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          roster.length > _maxRankedStudents
                              ? l10n.tAnalyticsRankingTop(_maxRankedStudents, roster.length)
                              : l10n.tAnalyticsStudentCount(roster.length),
                          style: AppTypography.codeSm.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.tAnalyticsRankingHint(_maxRankedStudents),
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _rankPanel(
                            context,
                            title: l10n.tAnalyticsRankMaterial,
                            subtitle: l10n.tAnalyticsRankMaterialSub,
                            icon: Icons.menu_book_rounded,
                            accent: p.primary,
                            roster: roster,
                            valueOf: (student) => student.completedCount,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _rankPanel(
                            context,
                            title: l10n.tAnalyticsRankPractice,
                            subtitle: l10n.tAnalyticsRankPracticeSub,
                            icon: Icons.code_rounded,
                            accent: p.success,
                            roster: roster,
                            valueOf: (student) =>
                                student.practiceCompletedCount,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Daftar siswa + aksi kelola anggota.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.tAnalyticsRosterTitle,
                          style: AppTypography.titleM.copyWith(
                            color: p.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.tAnalyticsStudentCount(roster.length),
                          style: AppTypography.codeSm.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Filter utama Daftar Siswa: Semua, Materi Tuntas,
                    // Latihan Terbanyak, Belum Memulai.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _filterChip(
                            context,
                            label: l10n.tAnalyticsFilterAllCount(roster.length),
                            selected: _rosterFilter == 'ALL',
                            accent: p.primary,
                            onSelected: () => setState(() {
                              _rosterFilter = 'ALL';
                            }),
                          ),
                          const SizedBox(width: 8),
                          _filterChip(
                            context,
                            label: l10n.tAnalyticsFilterCompletedCount(roster.where((s) => s.completedCount > 0).length),
                            selected: _rosterFilter == 'TUNTAS',
                            accent: p.success,
                            onSelected: () => setState(() {
                              _rosterFilter = 'TUNTAS';
                            }),
                          ),
                          const SizedBox(width: 8),
                          _filterChip(
                            context,
                            label: l10n.tAnalyticsFilterPractice,
                            selected: _rosterFilter == 'LATIHAN',
                            accent: p.primary,
                            onSelected: () => setState(() {
                              _rosterFilter = 'LATIHAN';
                            }),
                          ),
                          const SizedBox(width: 8),
                          _filterChip(
                            context,
                            label: l10n.tAnalyticsFilterNotStartedCount(roster.where((s) => _belumMatch(s)).length),
                            selected: _rosterFilter == 'BELUM',
                            accent: p.accent,
                            onSelected: () => setState(() {
                              _rosterFilter = 'BELUM';
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Sub-filter Latihan Terbanyak: semua / biasa / mini proyek.
                    if (_rosterFilter == 'LATIHAN') ...[
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip(
                              context,
                              label: l10n.tAnalyticsPracticeAll,
                              selected: _practiceFilter == 'SEMUA',
                              accent: p.primary,
                              onSelected: () => setState(() {
                                _practiceFilter = 'SEMUA';
                              }),
                            ),
                            const SizedBox(width: 8),
                            _filterChip(
                              context,
                              label: l10n.tAnalyticsPracticeRegularLabel,
                              selected: _practiceFilter == 'BIASA',
                              accent: p.primary,
                              onSelected: () => setState(() {
                                _practiceFilter = 'BIASA';
                              }),
                            ),
                            const SizedBox(width: 8),
                            _filterChip(
                              context,
                              label: l10n.filterMiniProject,
                              selected: _practiceFilter == 'MINI',
                              accent: p.primary,
                              onSelected: () => setState(() {
                                _practiceFilter = 'MINI';
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Sub-filter Belum Memulai: materi / latihan.
                    if (_rosterFilter == 'BELUM') ...[
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip(
                              context,
                              label: l10n.tAnalyticsNotStartedAll,
                              selected: _belumFilter == 'SEMUA',
                              accent: p.accent,
                              onSelected: () => setState(() {
                                _belumFilter = 'SEMUA';
                              }),
                            ),
                            const SizedBox(width: 8),
                            _filterChip(
                              context,
                              label: l10n.tAnalyticsNotStartedMaterialLabel,
                              selected: _belumFilter == 'MATERI',
                              accent: p.accent,
                              onSelected: () => setState(() {
                                _belumFilter = 'MATERI';
                              }),
                            ),
                            const SizedBox(width: 8),
                            _filterChip(
                              context,
                              label: l10n.tAnalyticsNotStartedPracticeLabel,
                              selected: _belumFilter == 'LATIHAN',
                              accent: p.accent,
                              onSelected: () => setState(() {
                                _belumFilter = 'LATIHAN';
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 6),
                    Text(
                      // Jelaskan persis basis filter yang aktif.
                      _rosterFilterHint(l10n, materials),
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Tombol satu-per-satu tiap materi kurikulum.
                    if (roster.isNotEmpty && materials.isNotEmpty) ...[
                      _materialFilterButtons(context, materials, roster),
                      const SizedBox(height: AppSpacing.md),
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
                            l10n.tAnalyticsRosterEmpty,
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      () {
                        final displayedRoster = _displayedRoster(roster);

                        if (displayedRoster.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Center(
                              child: Text(
                                l10n.tAnalyticsRosterFilterEmpty,
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
                                    width: 32,
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: i < 3
                                          ? p.primaryContainer.withAlpha(40)
                                          : p.surfaceAlt,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${i + 1}',
                                      maxLines: 1,
                                      softWrap: false,
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
                                          // Sebutkan angka nyata, bukan label
                                          // samar: berapa materi & latihan tuntas.
                                          _rosterFilter == 'LATIHAN'
                                              ? l10n.tAnalyticsRowPracticeDetail(
                                                  student.completedCount,
                                                  student.regularPracticeCount,
                                                  student.miniProjectCount,
                                                )
                                              : l10n.tAnalyticsRowDetail(
                                                  student.completedCount,
                                                  student.practiceCompletedCount,
                                                ),
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
                                        l10n.tAnalyticsXp(student.xpPoints),
                                        style: AppTypography.codeSm.copyWith(
                                          color: p.text,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 2),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.person_remove_rounded,
                                      size: 18,
                                    ),
                                    color: p.error,
                                    tooltip: l10n.tAnalyticsRemoveFromClass,
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    onPressed: state.isLoading
                                        ? null
                                        : () => _confirmRemoveStudent(student),
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
