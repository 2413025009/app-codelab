import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/shell/app_shell.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/topic_icons.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_tag.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../certificate/presentation/certificate_actions.dart';
import '../../../notifications/new_material_watcher.dart';
import '../../domain/lesson_repository.dart';
import '../../domain/slide_models.dart';

/// Katalog Materi (Minggu 9): daftar lesson per topik dari GET /lessons
/// (tanpa mock) — kini dilengkapi pencarian, chip filter status (Semua /
/// Selesai / Sedang Aktif / Belum Dimulai — pola katalog tantangan), dan
/// tarik-ke-bawah untuk muat ulang (permintaan owner). Menekan baris topik
/// → dashboard memetakan SEMUA bab lesson itu (selesai maupun belum) lewat
/// [appShellFocusTopic].
enum _MaterialFilter {
  all,
  selesai,
  sedangAktif,
  belumMulai;

  /// Label chip mengikuti bahasa aktif (nilai enum tidak menyimpan teks).
  String label(AppLocalizations l10n) => switch (this) {
    _MaterialFilter.all => l10n.filterAll,
    _MaterialFilter.selesai => l10n.filterDone,
    _MaterialFilter.sedangAktif => l10n.materialFilterActive,
    _MaterialFilter.belumMulai => l10n.materialFilterNotStarted,
  };
}

/// Deskripsi topik = kolom description bab dengan orderIndex terkecil
/// (diseed migrasi 000019 sebagai deskripsi topik).
String lessonTopicDescription(List<LessonDetailData> lessons) {
  if (lessons.isEmpty) return '';
  return lessons
      .reduce((a, b) => a.orderIndex <= b.orderIndex ? a : b)
      .description;
}

class LessonCatalogPage extends StatefulWidget {
  const LessonCatalogPage({super.key});

  @override
  State<LessonCatalogPage> createState() => _LessonCatalogPageState();
}

class _LessonCatalogPageState extends State<LessonCatalogPage> {
  late Future<List<LessonDetailData>> _future;
  final _search = TextEditingController();
  _MaterialFilter _filter = _MaterialFilter.all;

  @override
  void initState() {
    super.initState();
    _loadLessons();
    // Minggu 13: membuka katalog = siswa sudah melihat modul terbaru, jadi
    // lencana "Baru" dihapus (notifikasi HP tidak diulang).
    WidgetsBinding.instance.addPostFrameCallback((_) => _markSeen());
  }

  Future<void> _markSeen() async {
    if (!mounted) return;
    try {
      await NewMaterialWatcher.instance.markAllSeen(
        context.read<LessonRepository>(),
      );
      if (mounted) setState(() {});
    } catch (_) {
      // abaikan: lencana bersifat tambahan.
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  /// Minggu 13: hasil pencarian sampai ke ISI bab (GET /lessons/search).
  /// Kosong = belum mencari / tidak ada hasil; tidak pernah melempar.
  List<LessonSearchHit> _contentHits = const [];
  Timer? _searchDebounce;

  void _loadLessons() {
    _future = context.read<LessonRepository>().listAllLessons();
  }

  /// Mencari ke isi bab dengan jeda singkat agar tidak menembak server pada
  /// setiap ketukan tombol.
  void _searchContent(String raw) {
    _searchDebounce?.cancel();
    final q = raw.trim();
    if (q.isEmpty) {
      if (_contentHits.isNotEmpty) setState(() => _contentHits = const []);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 320), () async {
      if (!mounted) return;
      try {
        final hits = await context.read<LessonRepository>().searchLessons(q);
        if (mounted) setState(() => _contentHits = hits);
      } catch (_) {
        if (mounted) setState(() => _contentHits = const []);
      }
    });
  }

  /// Minggu 9 (owner): tarik layar dari atas → muat ulang katalog dari
  /// server (lingkaran pemuat mengikuti jarak tarikan).
  Future<void> _reload() {
    setState(_loadLessons);
    return _future;
  }

  /// Saring kata kunci pada nama topik + deskripsi materi.
  bool _matchesQuery(String topic, List<LessonDetailData> lessons) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return topic.toLowerCase().contains(q) ||
        lessonTopicDescription(lessons).toLowerCase().contains(q);
  }

  /// Saring chip status — definisi sama dengan chip pada tile materi.
  bool _passesFilter(_MaterialFilter f, List<LessonDetailData> lessons) {
    final done = lessons.where((l) => l.status == 'completed').length;
    final hasActive = lessons.any((l) => l.status == 'active');
    final allDone = lessons.isNotEmpty && done == lessons.length;
    return switch (f) {
      _MaterialFilter.all => true,
      _MaterialFilter.selesai => allDone,
      _MaterialFilter.sedangAktif => hasActive,
      _MaterialFilter.belumMulai => done == 0 && !hasActive,
    };
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: l10n.actionBack,
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.dashboard),
        ),
        title: Text(l10n.materialCatalogTitle),
      ),
      body: FutureBuilder<List<LessonDetailData>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  SkeletonBox(height: 48, radius: 12),
                  SizedBox(height: 16),
                  SkeletonBox(height: 88, radius: 20),
                  SizedBox(height: 12),
                  SkeletonBox(height: 88, radius: 20),
                ],
              ),
            );
          }

          if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.materialLoadFailed,
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: l10n.dashRetryButton,
                    expand: false,
                    onPressed: () => setState(_loadLessons),
                  ),
                ],
              ),
            );
          }

          final allLessons = snap.data!;

          // Group per topik (lesson top-level) — isi bab tidak dijabarkan.
          final grouped = <String, List<LessonDetailData>>{};
          for (final l in allLessons) {
            grouped.putIfAbsent(l.topic, () => []).add(l);
          }

          // Minggu 9 (owner): saring hasil sesuai kata kunci + chip filter.
          final visible = grouped.entries
              .where((e) => _matchesQuery(e.key, e.value))
              .where((e) => _passesFilter(_filter, e.value))
              .toList();

          return AppRefresh(
            onRefresh: _reload,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.xxl,
              ),
              children: [
                // Pencarian materi — gaya sama seperti katalog tantangan.
                TextField(
                  controller: _search,
                  onChanged: (value) {
                    setState(() {});
                    _searchContent(value);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.materialSearchHint,
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.materialClearSearch,
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _search.clear();
                              _searchDebounce?.cancel();
                              setState(() => _contentHits = const []);
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: p.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: p.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: p.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _MaterialFilter.values.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final f = _MaterialFilter.values[i];
                      return _FilterChip(
                        label: f.label(l10n),
                        selected: _filter == f,
                        onTap: () => setState(() => _filter = f),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Minggu 13: hasil pencarian sampai ke ISI bab — ditampilkan
                // di atas daftar modul supaya siswa melihat konteksnya.
                if (_contentHits.isNotEmpty) ...[
                  Text(
                    l10n.materialSearchContentTitle,
                    style: AppTypography.label.copyWith(
                      color: p.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < _contentHits.length; i++) ...[
                          if (i > 0)
                            Divider(
                              height: 1,
                              color: p.outline.withValues(alpha: 0.5),
                            ),
                          _ContentHitTile(
                            hit: _contentHits[i],
                            onTap: () => context.push(
                              AppRoutes.lesson(_contentHits[i].lessonId),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xl),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 44,
                          color: p.textMuted,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.materialNoMatch,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyM.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  for (final entry in visible)
                    _LessonTile(
                      topic: entry.key,
                      lessons: entry.value,
                      isNew: NewMaterialWatcher.instance.isNew(
                        entry.value.first.id,
                      ),
                      onTap: () {
                        // Lesson dipilih → dashboard memuat seluruh bab-nya.
                        appShellFocusTopic.value = entry.key;
                        showAppSnack(
                          context,
                          l10n.materialSwitchedSnack(entry.key),
                        );
                        context.go(AppRoutes.dashboard);
                      },
                      // Minggu 12: modul yang seluruh babnya tuntas langsung
                      // menawarkan e-Sertifikat Kompetensi.
                      onCertificate: () =>
                          openModuleCertificate(context, entry.key),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Satu baris = satu lesson (topik): ikon, tajuk, bar progres bab, chip
/// status, dan chevron — cukup menawarkan BUKA di dashboard.
class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.topic,
    required this.lessons,
    required this.onTap,
    this.onCertificate,
    this.isNew = false,
  });

  final String topic;
  final List<LessonDetailData> lessons;
  final VoidCallback onTap;

  /// Minggu 13: modul ini baru diterbitkan pengajar sejak terakhir dilihat.
  final bool isNew;

  /// Minggu 12: aksi e-Sertifikat modul (aktif hanya bila seluruh bab tuntas).
  final VoidCallback? onCertificate;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final done = lessons.where((l) => l.status == 'completed').length;
    final pct = lessons.isEmpty ? 0.0 : done / lessons.length;
    final hasActive = lessons.any((l) => l.status == 'active');
    final allDone = lessons.isNotEmpty && done == lessons.length;
    final isHtml =
        topic.toLowerCase().contains('html') ||
        topic.toLowerCase().contains('web');
    // Minggu 9 (owner): deskripsi singkat materi dari kolom lessons
    // .description (bab pertama topik mewakili deskripsi topik).
    final desc = lessonTopicDescription(lessons);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              borderRadius: AppRadius.cardBorder,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isHtml
                            ? Colors.orange.withValues(alpha: 0.15)
                            : p.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isHtml ? Icons.language_rounded : topicIcon(topic),
                        color: isHtml ? Colors.orange.shade800 : p.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic,
                            style: AppTypography.label.copyWith(
                              color: p.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          // Deskripsi singkat materi tepat di bawah nama lesson.
                          if (desc.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                          ] else
                            const SizedBox(height: AppSpacing.xs),
                          AppProgressBar(value: pct, height: 6),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Text(
                                l10n.materialChaptersDone(
                                  done,
                                  lessons.length,
                                ),
                                style: AppTypography.caption.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                              // Minggu 13: lencana "Baru" untuk modul yang
                              // baru diterbitkan pengajar sejak katalog
                              // terakhir dibuka.
                              if (isNew) ...[
                                const SizedBox(width: AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p.accent.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    l10n.notifNewBadge,
                                    style: AppTypography.caption.copyWith(
                                      color: p.warningText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AppTag(
                      hasActive
                          ? l10n.materialFilterActive
                          : allDone
                          ? l10n.filterDone
                          : done > 0
                          ? l10n.materialStatusRunning
                          : l10n.materialFilterNotStarted,
                      background: hasActive
                          ? p.primaryContainer
                          : allDone
                          ? p.success.withValues(alpha: 0.15)
                          : p.surfaceAlt,
                      foreground: hasActive
                          ? p.primary
                          : allDone
                          ? p.success
                          : p.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: p.primary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            // Minggu 12: baris aksi sertifikat hanya muncul saat seluruh bab
            // tuntas (backend penentu penerbitan; tidak mengarang nomor).
            if (allDone && onCertificate != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: onCertificate,
                    icon: const Icon(
                      Icons.workspace_premium_rounded,
                      size: 16,
                    ),
                    label: Text(
                      l10n.profileDownload,
                      style: AppTypography.caption.copyWith(
                        color: p.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: p.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      minimumSize: const Size(0, AppSizes.tagHeight),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Hasil pencarian yang cocok karena ISI bab (Minggu 13), bukan hanya judul.
class _ContentHitTile extends StatelessWidget {
  const _ContentHitTile({required this.hit, required this.onTap});

  final LessonSearchHit hit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 2,
      ),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: p.surfaceAlt,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          hit.source == 'chapter' ? Icons.menu_book_outlined : Icons.search,
          size: 17,
          color: p.primary,
        ),
      ),
      title: Text(
        hit.lessonTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.label.copyWith(
          color: p.text,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hit.topic,
            style: AppTypography.caption.copyWith(color: p.primary),
          ),
          const SizedBox(height: 2),
          Text(
            hit.snippet.isEmpty ? l10n.materialSearchContentNoSnippet : hit.snippet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13,
        color: p.primary,
      ),
    );
  }
}

/// Chip pilihan filter status — gaya sama dengan chip katalog tantangan.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: selected ? p.primary : p.surface,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? p.primary : p.outline),
      ),
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
              color: selected ? p.onPrimary : p.text,
            ),
          ),
        ),
      ),
    );
  }
}
