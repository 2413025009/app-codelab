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
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/challenge_repository.dart';

enum _StatusFilter {
  all('Semua'),
  todo('Belum Selesai'),
  done('Selesai'),
  miniProject('Mini Proyek');

  const _StatusFilter(this.label);
  final String label;
}

class ChallengeCatalogPage extends StatefulWidget {
  const ChallengeCatalogPage({super.key});

  @override
  State<ChallengeCatalogPage> createState() => _ChallengeCatalogPageState();
}

class _ChallengeCatalogPageState extends State<ChallengeCatalogPage> {
  late Future<ChallengeCatalog> _future;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  _StatusFilter _status = _StatusFilter.all;
  ChallengeLevel? _level;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _future = context.read<ChallengeRepository>().getCatalog(userXp: user?.xpPoints);
    appShellTabActivated.addListener(_handleTabActivated);
  }

  @override
  void dispose() {
    appShellTabActivated.removeListener(_handleTabActivated);
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  /// Tab "Tantangan" (index 1 pada AppShell) baru diaktifkan. Halaman ini
  /// tetap hidup di IndexedStack (initState tidak jalan ulang), jadi status
  /// soal/XP disegarkan SUNYI di latar belakang saat user balik ke tab ini.
  void _handleTabActivated() {
    if (appShellTabActivated.value == 1) {
      _refreshSilent();
    }
  }

  /// Refresh latar tanpa skeleton: fetch dulu, future lama baru ditukar bila
  /// sukses (FutureBuilder mempertahankan daftar lama selama menunggu). Bila
  /// gagal (mis. jaringan), diamkan - jangan rusak tampilan yang sudah ada.
  Future<void> _refreshSilent() async {
    final user = context.read<AuthCubit>().state.user;
    try {
      final fresh = await context.read<ChallengeRepository>().getCatalog(userXp: user?.xpPoints);
      if (!mounted) return;
      setState(() => _future = Future.value(fresh));
    } catch (_) {}
  }

  void _refresh() {
    final user = context.read<AuthCubit>().state.user;
    setState(() {
      _future = context.read<ChallengeRepository>().getCatalog(userXp: user?.xpPoints);
    });
  }

  bool _matches(ChallengeSummary c) {
    final q = _search.text.trim().toLowerCase();
    if (q.isNotEmpty &&
        !('${c.title} ${c.topicTag} ${c.subtitle ?? ''}'.toLowerCase().contains(q))) {
      return false;
    }
    if (_level != null && c.level != _level) return false;
    return switch (_status) {
      _StatusFilter.all => true,
      _StatusFilter.todo => c.status != ChallengeStatus.completed,
      _StatusFilter.done => c.status == ChallengeStatus.completed,
      _StatusFilter.miniProject => c.isMiniProject,
    };
  }

  void _openFilterSheet() {
    showAppSheet<void>(
      context,
      title: 'Filter Tantangan',
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tingkat kesulitan', style: AppTypography.label.copyWith(color: ctx.palette.textMuted)),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _ChoiceChip(
                    label: 'Semua',
                    selected: _level == null,
                    onTap: () {
                      setState(() => _level = null);
                      setSheet(() {});
                    },
                  ),
                  for (final l in ChallengeLevel.values)
                    _ChoiceChip(
                      label: l.label,
                      selected: _level == l,
                      onTap: () {
                        setState(() => _level = l);
                        setSheet(() {});
                      },
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'Terapkan', onPressed: () => Navigator.of(ctx).pop()),
            ],
          ),
        ),
      ),
    );
  }

  void _onChallengeTap(ChallengeSummary c, int userXp) {
    if (c.isLocked) {
      showAppSheet<void>(
        context,
        title: 'Tantangan Terkunci',
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ctx.palette.warningContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.lock_rounded, color: ctx.palette.warningText, size: 28),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(c.title, style: AppTypography.titleM.copyWith(color: ctx.palette.text)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Syarat: Butuh minimal ${c.minXpRequired} XP untuk membuka tantangan ini. Saat ini kamu memiliki $userXp XP.',
                style: AppTypography.bodyM.copyWith(color: ctx.palette.textMuted, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Jalur Belajar',
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go(AppRoutes.dashboard);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Tutup',
                      kind: AppButtonKind.secondary,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      context.push(AppRoutes.challenge(c.id)).then((_) => _refresh());
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;
    final userName = user?.name ?? 'Siswa SMK';
    final userXp = user?.xpPoints ?? 0;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ChallengeCatalog>(
          future: _future,
          builder: (context, snap) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.xxl),
              children: [
                _TopBar(
                  userName: userName,
                  onSearch: () => _searchFocus.requestFocus(),
                  onAvatar: () => context.go(AppRoutes.profile),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Katalog Tantangan', style: AppTypography.titleL.copyWith(color: p.text, fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('Asah logika algoritma & koding bertahap', style: AppTypography.bodyM.copyWith(color: p.textMuted)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(AppSizes.minTouch, 40),
                        side: BorderSide(color: p.outline),
                        foregroundColor: p.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _openFilterSheet,
                      icon: const Icon(Icons.tune_rounded, size: 16),
                      label: Text(_level == null ? 'Filter' : 'Filter • 1', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _search,
                  focusNode: _searchFocus,
                  onChanged: (_) => setState(() {}),
                  style: AppTypography.bodyL.copyWith(color: p.text),
                  decoration: InputDecoration(
                    hintText: 'Cari topik, fungsi, atau algoritma...',
                    prefixIcon: Icon(Icons.search_rounded, color: p.textMuted, size: 20),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () => setState(_search.clear),
                          ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.outline)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.outline)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.primary, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (snap.connectionState != ConnectionState.done)
                  const _CatalogSkeleton()
                else if (snap.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xl),
                    child: Column(
                      children: [
                        Text('Ada kendala di sisi kami. Coba lagi sebentar.',
                            style: AppTypography.bodyM.copyWith(color: p.textMuted)),
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(
                          label: 'Coba lagi',
                          expand: false,
                          onPressed: _refresh,
                        ),
                      ],
                    ),
                  )
                else
                  ..._content(context, snap.data!, userXp),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, ChallengeCatalog catalog, int userXp) {
    final p = context.palette;
    final groups = [
      for (final g in catalog.groups)
        (g, g.challenges.where(_matches).toList()),
    ].where((e) => e.$2.isNotEmpty).toList();

    return [
      SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _StatusFilter.values.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, i) {
            final f = _StatusFilter.values[i];
            return _ChoiceChip(
              label: f == _StatusFilter.all ? '${f.label} (${catalog.total})' : f.label,
              selected: _status == f,
              onTap: () => setState(() => _status = f),
            );
          },
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      _ProgressSummary(catalog: catalog),
      const SizedBox(height: AppSpacing.xl),
      if (groups.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 40, color: p.textMuted),
              const SizedBox(height: AppSpacing.md),
              Text('Tidak ada tantangan yang cocok. Coba ubah kata kunci atau filter.',
                  textAlign: TextAlign.center, style: AppTypography.bodyM.copyWith(color: p.textMuted)),
            ],
          ),
        ),
      for (final (group, items) in groups) ...[
        if (group.isMiniProject) ...[
          _MiniProjectHeader(group: group),
          const SizedBox(height: AppSpacing.md),
          for (final c in items) ...[
            _MiniProjectCard(
              challenge: c,
              userXp: userXp,
              onTap: () => _onChallengeTap(c, userXp),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ] else ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  group.title.toUpperCase(),
                  style: AppTypography.label.copyWith(
                    color: p.textMuted,
                    letterSpacing: 0.8,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: group.completed > 0 ? p.primaryContainer : p.surfaceAlt,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${group.completed} / ${group.challenges.length} Selesai',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: group.completed > 0 ? p.primary : p.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final c in items) ...[
            _ChallengeTile(
              challenge: c,
              userXp: userXp,
              onTap: () => _onChallengeTap(c, userXp),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
        const SizedBox(height: AppSpacing.sm),
      ],
    ];
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName, required this.onSearch, required this.onAvatar});

  final String userName;
  final VoidCallback onSearch;
  final VoidCallback onAvatar;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: p.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.code_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CodeLab AI', style: AppTypography.titleM.copyWith(color: p.text, fontSize: 16)),
              Text('SMK RPL Platform', style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Cari tantangan',
          style: IconButton.styleFrom(
            side: BorderSide(color: p.outline),
            minimumSize: const Size(36, 36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: Icon(Icons.search_rounded, color: p.text, size: 18),
          onPressed: onSearch,
        ),
        const SizedBox(width: AppSpacing.sm),
        Stack(
          children: [
            InitialAvatar(name: userName, size: 38, onTap: onAvatar),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: p.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: p.bg, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: selected ? p.primary : p.surface,
      shape: StadiumBorder(side: BorderSide(color: selected ? p.primary : p.outline)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected ? Colors.white : p.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.catalog});
  final ChallengeCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.outline),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: p.warningContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Icon(Icons.emoji_events_rounded, color: p.warningText, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${catalog.completed} dari ${catalog.total} Selesai',
                        style: AppTypography.titleM.copyWith(color: p.text, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text('Kemahiran Kurikulum Algoritma RPL',
                        style: AppTypography.bodyM.copyWith(color: p.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${(catalog.progress * 100).round()}%',
                      style: AppTypography.titleL.copyWith(color: p.primary, fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('+${catalog.xpEarned} XP Didapat',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 11, color: p.success, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(value: catalog.progress, trackColor: p.surfaceAlt),
        ],
      ),
    );
  }
}

class _ChallengeTile extends StatelessWidget {
  const _ChallengeTile({
    required this.challenge,
    required this.userXp,
    required this.onTap,
  });

  final ChallengeSummary challenge;
  final int userXp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = challenge;

    final (Color bg, Color fg, IconData icon, String statusText) = switch (c.status) {
      ChallengeStatus.completed => (const Color(0xFFECFDF5), p.success, Icons.check_rounded, 'Selesai'),
      ChallengeStatus.inProgress => (const Color(0xFFFFFBEB), const Color(0xFFD97706), Icons.more_horiz_rounded, 'Sedang Dicoba'),
      ChallengeStatus.notStarted => (p.surfaceAlt, p.textMuted, c.isLocked ? Icons.lock_rounded : Icons.code_rounded, ''),
    };

    return Opacity(
      opacity: c.isLocked ? 0.75 : 1.0,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(color: fg.withValues(alpha: 0.35)),
              ),
              child: Icon(icon, color: fg, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, style: AppTypography.titleM.copyWith(color: p.text, fontSize: 15)),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.level == ChallengeLevel.intermediate ? const Color(0xFFE4EDFF) : p.surfaceAlt,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c.level.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: c.level == ChallengeLevel.intermediate ? p.primary : p.textMuted,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(6)),
                        child: Text(c.topicTag, style: TextStyle(fontSize: 10.5, color: p.textMuted)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Text(
                          '+${c.xp} XP',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                        ),
                      ),
                      if (c.isLocked)
                        Text(
                          'Butuh ${c.minXpRequired} XP',
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFFD97706), fontWeight: FontWeight.bold),
                        )
                      else if (statusText.isNotEmpty)
                        Text(
                          statusText,
                          style: TextStyle(fontSize: 10.5, color: fg, fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(c.isLocked ? Icons.lock_outline_rounded : Icons.chevron_right_rounded, color: p.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _MiniProjectHeader extends StatelessWidget {
  const _MiniProjectHeader({required this.group});
  final ChallengeGroup group;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'MINI-PROYEK TERAPAN',
                    style: AppTypography.label.copyWith(color: p.textMuted, letterSpacing: 0.8, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4EDFF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Real-World',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: p.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Praktik implementasi logika komprehensif khas SMK RPL',
                style: TextStyle(fontSize: 11.5, color: p.textMuted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE4EDFF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${group.unlockedCount} / ${group.challenges.length} Dibuka',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.primary),
          ),
        ),
      ],
    );
  }
}

class _MiniProjectCard extends StatelessWidget {
  const _MiniProjectCard({
    required this.challenge,
    required this.userXp,
    required this.onTap,
  });

  final ChallengeSummary challenge;
  final int userXp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = challenge;

    IconData projectIcon = Icons.point_of_sale_rounded;
    if (c.id.contains('parkir')) projectIcon = Icons.local_parking_rounded;
    if (c.id.contains('nilai')) projectIcon = Icons.school_rounded;

    final borderColor = c.isLocked ? p.outline : p.primary.withValues(alpha: 0.35);

    return Opacity(
      opacity: c.isLocked ? 0.8 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c.isLocked ? p.surfaceAlt : const Color(0xFFE4EDFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.isLocked ? p.outline : p.primary.withValues(alpha: 0.2)),
                        ),
                        child: Icon(
                          projectIcon,
                          color: c.isLocked ? p.textMuted : p.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    c.title,
                                    style: AppTypography.titleM.copyWith(color: p.text, fontSize: 15, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c.isLocked ? p.surfaceAlt : const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: c.isLocked ? p.outline : const Color(0xFFA7F3D0)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (c.isLocked) ...[
                                        const Icon(Icons.lock_rounded, size: 10, color: Color(0xFF5B6475)),
                                        const SizedBox(width: 3),
                                      ],
                                      Text(
                                        c.isLocked ? 'Terkunci' : 'Terbuka',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: c.isLocked ? p.textMuted : p.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (c.subtitle != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                c.subtitle!,
                                style: TextStyle(fontSize: 11.5, color: p.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        c.isLocked ? Icons.lock_rounded : Icons.chevron_right_rounded,
                        color: c.isLocked ? p.textMuted : p.primary,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(height: 1, color: p.outline.withValues(alpha: 0.6)),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.level == ChallengeLevel.intermediate ? const Color(0xFFE4EDFF) : p.surfaceAlt,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c.level.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: c.level == ChallengeLevel.intermediate ? p.primary : p.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule_rounded, size: 12, color: p.textMuted),
                            const SizedBox(width: 3),
                            Text('${c.estimatedMinutes} Menit', style: TextStyle(fontSize: 11, color: p.textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Text(
                          '+${c.xp} XP',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                        ),
                      ),
                      const Spacer(),
                      if (c.isLocked)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_rounded, size: 12, color: Color(0xFFD97706)),
                            const SizedBox(width: 4),
                            Text(
                              'Syarat: Butuh ${c.minXpRequired} XP',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFD97706), fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fact_check_rounded, size: 12, color: p.success),
                            const SizedBox(width: 4),
                            Text(
                              '${c.testCount} Unit Test',
                              style: TextStyle(fontSize: 11, color: p.success, fontWeight: FontWeight.w600),
                            ),
                          ],
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
  }
}

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonBox(height: 36, radius: 18),
        SizedBox(height: 16),
        SkeletonBox(height: 110, radius: 20),
        SizedBox(height: 24),
        SkeletonBox(height: 80, radius: 16),
        SizedBox(height: 12),
        SkeletonBox(height: 80, radius: 16),
        SizedBox(height: 12),
        SkeletonBox(height: 110, radius: 20),
      ],
    );
  }
}
