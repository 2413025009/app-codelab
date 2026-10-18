import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/shell/app_shell.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/competency_radar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../dashboard/domain/dashboard_repository.dart';
import '../../../lesson/domain/lesson_repository.dart';
import '../../../lesson/domain/slide_models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// Data hasil fetch SUKSES terakhir. Selama refresh latar berjalan nilainya
  /// dipakai terus (stale-while-revalidate); bila fetch gagal (mis. offline)
  /// tampilan lama dipertahankan, tanpa data kosong palsu.
  Future<_ProfileData>? _dataFuture;

  /// Identitas user yang dipakai memuat data terakhir (email + XP) untuk
  /// mendeteksi perubahan progres tanpa membaca ulang seluruh layar.
  String? _loadedEmail;
  int? _loadedXp;
  bool _loading = false;
  bool _rerunNeeded = false;

  @override
  void initState() {
    super.initState();
    appShellTabActivated.addListener(_handleTabActivated);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dulu: future dibuat ulang di build() sehingga SETIAP rebuild (termasuk
    // perubahan XP) memicu fetch baru + berkedip skeleton. Sekarang: perubahan
    // email/XP mendeteksi di sini dan memuat ulang SUNYI di latar belakang.
    final user = context.watch<AuthCubit>().state.user;
    if (user?.email != _loadedEmail || user?.xpPoints != _loadedXp) {
      _loadedEmail = user?.email;
      _loadedXp = user?.xpPoints;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSilently());
    }
  }

  /// Tab "Profil" (index 3 pada AppShell) baru diaktifkan. IndexedStack
  /// Caption mempermanenkan halaman di memori, jadi segarkan data di latar
  /// belakang supaya XP/statistik selalu segar tanpa refresh manual.
  void _handleTabActivated() {
    if (appShellTabActivated.value == 3) {
      _loadSilently();
    }
  }

  @override
  void dispose() {
    appShellTabActivated.removeListener(_handleTabActivated);
    super.dispose();
  }

  /// Refresh latar: fetch dulu, dan hanya bila sukses data ditukar via
  /// setState - FutureBuilder mempertahankan tampilan lama selama menunggu,
  /// sehingga layar TIDAK berkedip dan tidak butuh "sekali refresh" lagi.
  Future<void> _loadSilently() async {
    if (!mounted) return;
    if (_loading) {
      _rerunNeeded = true;
      return;
    }
    _loading = true;
    try {
      final user = context.read<AuthCubit>().state.user;
      final lessonRepo = context.read<LessonRepository>();
      final dashRepo = context.read<DashboardRepository>();
      final data = await _loadData(lessonRepo, dashRepo, user?.email ?? '');
      if (!mounted) return;
      setState(() => _dataFuture = Future.value(data));
    } catch (_) {
      // Muat ulang latar gagal: pertahankan tampilan lama (jujur, tanpa
      // format palsu; pemakai tetap bisa coba lewat tab lain).
    } finally {
      _loading = false;
      if (_rerunNeeded) {
        _rerunNeeded = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadSilently());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;
    final userName = user?.name ?? 'Siswa Baru';
    final xp = user?.xpPoints ?? 0;
    final initial = _initials(userName);
    final school = user?.schoolName;
    final className = user?.className;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: p.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.terminal, color: Colors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Profil & Kompetensi'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan Profil',
            onPressed: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: FutureBuilder<_ProfileData>(
        // Data cache terakhir; refresh latar menukar future ini via setState
        // begitu fetch baru sukses. FutureBuilder mempertahankan snapshot lama
        // selama menunggu, jadi layar tak berkedip dan tak butuh refresh manual.
        future: _dataFuture ?? Future<_ProfileData>.value(const _ProfileData.empty()),
        builder: (context, snap) {
          final data = snap.data ?? const _ProfileData.empty();
          final lessons = data.lessons;

          // Agregasi per track (topic) — seluruhnya dari GET /lessons (DB).
          final topics = <String, List<LessonDetailData>>{};
          for (final l in lessons) {
            topics.putIfAbsent(l.topic, () => []).add(l);
          }
          final completedLessons = lessons.where((l) => l.status == 'completed').length;
          final tracksDone = topics.entries.where((e) => e.value.every((l) => l.status == 'completed')).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.md,
              AppSpacing.screen,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Student Profile Hero Card (Stitch v2)
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: p.primary,
                                child: Text(
                                  initial,
                                  style: AppTypography.titleL.copyWith(color: Colors.white),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: p.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: p.surface, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: p.surfaceAlt,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.military_tech_outlined, size: 14, color: p.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Siswa RPL • Tingkat Pemula',
                                        style: AppTypography.caption.copyWith(
                                          color: p.textMuted,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userName,
                                  style: AppTypography.titleM.copyWith(color: p.text, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (school == null || school.isEmpty) && (className == null || className.isEmpty)
                                      ? 'Lengkapi identitas di Pengaturan.'
                                      : '${school ?? ''}${school != null && school.isNotEmpty && className != null && className.isNotEmpty ? ' • ' : ''}${className ?? ''}',
                                  style: AppTypography.caption.copyWith(color: p.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Statistik langsung dari DB (GET /me/skills, /challenges, XP user)
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.task_alt,
                              value: '${data.completedChallenges}',
                              label: 'Tantangan',
                              iconColor: p.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.bolt,
                              value: '$xp',
                              label: 'Poin XP',
                              iconColor: p.accent,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.school,
                              value: '$tracksDone / ${topics.length}',
                              label: 'Track Selesai',
                              iconColor: p.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 2. Progres per track — semua angka dari DB (GET /lessons).
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progres Track Belajar',
                            style: AppTypography.label.copyWith(color: p.text, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$completedLessons/${lessons.length} bab',
                            style: AppTypography.caption.copyWith(color: p.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (topics.isEmpty)
                        Text(
                          'Belum ada materi yang dimuat.',
                          style: AppTypography.bodyM.copyWith(color: p.textMuted),
                        )
                      else
                        for (final entry in topics.entries)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _TrackRow(
                              topic: entry.key,
                              lessons: entry.value,
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 3. Statistik & Sertifikat Track (Stitch v2) — realitik dari DB.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statistik & Sertifikat Track',
                            style: AppTypography.titleM.copyWith(color: p.text),
                          ),
                          Text(
                            'Sertifikat track otomatis terbuka saat seluruh babnya tuntas',
                            style: AppTypography.caption.copyWith(color: p.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$tracksDone/${topics.length} Tuntas',
                        style: AppTypography.caption.copyWith(color: p.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final entry in topics.entries) ...[
                        if (entry.key != topics.keys.first)
                          Divider(height: 1, color: p.outline.withValues(alpha: 0.5)),
                        _CertificateItem(
                          topic: entry.key,
                          lessons: entry.value,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 4. Competency Radar (PRD Section 4) — skor dari GET /me/skills.
                Text(
                  'Peta Radar Kompetensi',
                  style: AppTypography.titleM.copyWith(color: p.text),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Skor dihitung dari bukti tantangan dan materi yang kamu tuntaskan',
                  style: AppTypography.bodyM.copyWith(color: p.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
                  child: data.skills.values.any((v) => v > 0)
                      ? Center(
                          child: CompetencyRadar(
                            scores: data.skills,
                            showValueInLabel: true,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                          child: Column(
                            children: [
                              Icon(Icons.radar_rounded, size: 40, color: p.textMuted.withValues(alpha: 0.5)),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Radar masih kosong. Selesaikan materi dan tantangan pertamamu untuk mengisi skor kompetensi.',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyM.copyWith(color: p.textMuted),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Button to Settings
                AppButton(
                  label: 'Buka Pengaturan Akun & Lab',
                  kind: AppButtonKind.secondary,
                  leadingIcon: Icons.settings,
                  onPressed: () => context.push(AppRoutes.settings),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Muat data profil: semua sumber adalah endpoint DB backend.
  /// /lessons (status & progres bab), /me/skills + /challenges (radar & jumlah
  /// tantangan tuntas). Bila salah satu gagal, bagian itu jatuh ke nol - tanpa
  /// angka palsu.
  Future<_ProfileData> _loadData(
    LessonRepository lessonRepo,
    DashboardRepository dashRepo,
    String email,
  ) async {
    List<LessonDetailData> lessons;
    try {
      lessons = await lessonRepo.listAllLessons();
    } catch (_) {
      lessons = const <LessonDetailData>[];
    }

    int challenges = 0;
    Map<String, double> skills = const {};
    try {
      final dash = await dashRepo.load(studentEmail: email);
      challenges = dash.completedChallenges;
      skills = dash.skills;
    } catch (_) {
      // Tanpa angka palsu: biarkan default (nol, radar kosong).
    }

    return _ProfileData(
      lessons: lessons,
      completedChallenges: challenges,
      skills: skills,
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }
}

class _ProfileData {
  const _ProfileData({
    required this.lessons,
    required this.completedChallenges,
    required this.skills,
  });

  const _ProfileData.empty()
      : lessons = const [],
        completedChallenges = 0,
        skills = const {};

  final List<LessonDetailData> lessons;
  final int completedChallenges;
  final Map<String, double> skills;
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
              Text(
                value,
                style: AppTypography.label.copyWith(color: p.text, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Satu baris progres per track (topic) beserta persentase bab selesai.
class _TrackRow extends StatelessWidget {
  const _TrackRow({required this.topic, required this.lessons});

  final String topic;
  final List<LessonDetailData> lessons;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = lessons.length;
    final done = lessons.where((l) => l.status == 'completed').length;
    final pct = total == 0 ? 0.0 : done / total;
    final isHtml = topic.toLowerCase().contains('html') || topic.toLowerCase().contains('web');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isHtml ? p.errorContainer : p.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isHtml ? Icons.language_rounded : Icons.terminal_rounded,
                color: isHtml ? p.error : p.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                topic,
                style: AppTypography.label.copyWith(color: p.text, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '$done/$total',
              style: AppTypography.caption.copyWith(color: p.textMuted, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${(pct * 100).round()}%',
              style: AppTypography.caption.copyWith(color: p.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppProgressBar(value: pct),
      ],
    );
  }
}

/// Baris sertifikat per track: Tuntas saat seluruh bab 100%, selain itu
/// persentase realistis + status belajar. Tidak ada aksi unduh palsu.
class _CertificateItem extends StatelessWidget {
  const _CertificateItem({
    required this.topic,
    required this.lessons,
  });

  final String topic;
  final List<LessonDetailData> lessons;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = lessons.length;
    final done = lessons.where((l) => l.status == 'completed').length;
    final pct = total == 0 ? 0 : (done * 100 ~/ total);
    final isComplete = total > 0 && done == total;
    final isHtml = topic.toLowerCase().contains('html') || topic.toLowerCase().contains('web');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isComplete ? p.primaryContainer : p.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isHtml ? Icons.language_rounded : Icons.terminal_rounded,
              color: isComplete ? p.primary : p.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: AppTypography.label.copyWith(color: p.text, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isComplete ? p.success : (done > 0 ? p.primary : p.textMuted),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isComplete
                          ? 'Tuntas'
                          : (done > 0 ? 'Sedang belajar' : 'Belum dimulai'),
                      style: AppTypography.caption.copyWith(
                        color: isComplete ? p.success : p.textMuted,
                        fontWeight: isComplete ? FontWeight.bold : FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isComplete ? p.success.withValues(alpha: 0.12) : p.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isComplete)
                  Icon(Icons.military_tech_rounded, size: 13, color: p.success)
                else
                  Icon(Icons.lock_outline, size: 12, color: p.primary),
                const SizedBox(width: 4),
                Text(
                  isComplete ? 'Tuntas' : '$pct%',
                  style: AppTypography.caption.copyWith(
                    color: isComplete ? p.success : p.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
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
