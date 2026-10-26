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
import '../../../../core/widgets/app_tag.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../domain/lesson_repository.dart';
import '../../domain/slide_models.dart';

/// Katalog Materi (Minggu 9): daftar lesson per topik dari GET /lessons
/// (tanpa mock) — kini dilengkapi pencarian, chip filter status (Semua /
/// Selesai / Sedang Aktif / Belum Dimulai — pola katalog tantangan), dan
/// tarik-ke-bawah untuk muat ulang (permintaan owner). Menekan baris topik
/// → dashboard memetakan SEMUA bab lesson itu (selesai maupun belum) lewat
/// [appShellFocusTopic].
enum _MaterialFilter {
  all('Semua'),
  selesai('Selesai'),
  sedangAktif('Sedang Aktif'),
  belumMulai('Belum Dimulai');

  const _MaterialFilter(this.label);
  final String label;
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
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _loadLessons() {
    _future = context.read<LessonRepository>().listAllLessons();
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.dashboard),
        ),
        title: const Text('Katalog Materi'),
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
                    'Gagal memuat katalog materi.',
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Coba lagi',
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
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari materi atau deskripsinya…',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _search.clear();
                              setState(() {});
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
                        label: f.label,
                        selected: _filter == f,
                        onTap: () => setState(() => _filter = f),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
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
                          'Tidak ada materi yang cocok dengan pencarian '
                          'atau filter.',
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
                      onTap: () {
                        // Lesson dipilih → dashboard memuat seluruh bab-nya.
                        appShellFocusTopic.value = entry.key;
                        context.go(AppRoutes.dashboard);
                      },
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
  });

  final String topic;
  final List<LessonDetailData> lessons;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
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
        child: InkWell(
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
                      Text(
                        '$done/${lessons.length} bab tuntas',
                        style: AppTypography.caption.copyWith(
                          color: p.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                AppTag(
                  hasActive
                      ? 'Sedang Aktif'
                      : allDone
                      ? 'Selesai'
                      : done > 0
                      ? 'Berjalan'
                      : 'Belum Dimulai',
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
              color: selected ? Colors.white : p.text,
            ),
          ),
        ),
      ),
    );
  }
}
