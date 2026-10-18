import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/app_tag.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../domain/lesson_repository.dart';
import '../../domain/slide_models.dart';

class LessonCatalogPage extends StatefulWidget {
  const LessonCatalogPage({super.key});

  @override
  State<LessonCatalogPage> createState() => _LessonCatalogPageState();
}

class _LessonCatalogPageState extends State<LessonCatalogPage> {
  late Future<List<LessonDetailData>> _future;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  /// Filter status yang datanya seluruhnya dari DB backend (GET /lessons).
  static const _statusFilters = ['Sedang Dipelajari', 'Selesai', 'Belum Dimulai'];
  static const _statusLabels = {
    'Sedang Dipelajari': 'sedang',
    'Selesai': 'selesai',
    'Belum Dimulai': 'belum',
  };

  @override
  void initState() {
    super.initState();
    _loadLessons();
    _searchController.addListener(() => setState(() {}));
  }

  void _loadLessons() {
    _future = context.read<LessonRepository>().listAllLessons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.dashboard),
        ),
        title: const Text('Katalog Materi & Track'),
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
                  SkeletonBox(height: 38, radius: 20),
                  SizedBox(height: 24),
                  SkeletonBox(height: 180, radius: 20),
                ],
              ),
            );
          }

          if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat katalog materi.', style: AppTypography.bodyM.copyWith(color: p.textMuted)),
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
          final query = _searchController.text.trim().toLowerCase();

          // Status belajar dari DB backend (GET /lessons):
          // selesai = completed; sedang dipelajari = aktif & sudah dibuka; sisanya belum dimulai.
          String statusOf(LessonDetailData l) {
            if (l.status == 'completed') return 'selesai';
            if (l.status == 'active' && l.progressPercent > 0) return 'sedang';
            return 'belum';
          }

          int countStatus(String key) =>
              allLessons.where((l) => statusOf(l) == key).length;
          final sedangCount = countStatus('sedang');
          final selesaiCount = countStatus('selesai');
          final belumCount = countStatus('belum');

          // Group by Topic
          final grouped = <String, List<LessonDetailData>>{};
          for (final l in allLessons) {
            grouped.putIfAbsent(l.topic, () => []).add(l);
          }

          // Active Lesson
          final activeLesson = allLessons.firstWhere(
            (l) => l.status == 'active',
            orElse: () => allLessons.first,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.xxl),
            children: [
              // Search Input
              Container(
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: p.outline),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari topik materi, sintaks, atau bahasa...',
                    hintStyle: AppTypography.caption.copyWith(color: p.textMuted),
                    prefixIcon: Icon(Icons.search_rounded, color: p.textMuted),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Category filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua (${allLessons.length})',
                      isSelected: _selectedFilter == 'Semua',
                      onTap: () => setState(() => _selectedFilter = 'Semua'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Sedang Dipelajari ($sedangCount)',
                      isSelected: _selectedFilter == 'Sedang Dipelajari',
                      onTap: () => setState(() => _selectedFilter = 'Sedang Dipelajari'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Selesai ($selesaiCount)',
                      isSelected: _selectedFilter == 'Selesai',
                      onTap: () => setState(() => _selectedFilter = 'Selesai'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Belum Dimulai ($belumCount)',
                      isSelected: _selectedFilter == 'Belum Dimulai',
                      onTap: () => setState(() => _selectedFilter = 'Belum Dimulai'),
                    ),
                    const SizedBox(width: 8),
                    ...grouped.keys.map((topic) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: topic,
                          isSelected: _selectedFilter == topic,
                          onTap: () => setState(() => _selectedFilter = topic),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Active Enrolled Track Card
              if (_selectedFilter == 'Semua' || _selectedFilter == 'Sedang Dipelajari') ...[
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Track yang Sedang Kamu Ikuti', style: AppTypography.titleM.copyWith(fontWeight: FontWeight.bold, color: p.text)),
                    const Spacer(),
                    AppTag('1 Berjalan', background: p.primaryContainer, foreground: p.primary),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: p.primaryContainer, borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.terminal_rounded, color: p.primary, size: 26),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppTag('Sedang Aktif', background: p.primaryContainer, foreground: p.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Bab ${activeLesson.orderIndex}',
                                      style: AppTypography.caption.copyWith(color: p.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  activeLesson.topic,
                                  style: AppTypography.titleM.copyWith(fontWeight: FontWeight.bold, color: p.text),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Bab ${activeLesson.orderIndex}: ${activeLesson.title}',
                                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: p.text),
                                ),
                                Text(
                                  '${activeLesson.progressPercent.round()}%',
                                  style: AppTypography.label.copyWith(color: p.primary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AppProgressBar(value: activeLesson.progressPercent / 100.0),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Lanjutkan Belajar',
                        trailingIcon: Icons.arrow_forward_rounded,
                        onPressed: () => context.push(AppRoutes.lesson(activeLesson.id)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              // Other Tracks
              Text(
                'Pilihan Track Belajar',
                style: AppTypography.titleM.copyWith(fontWeight: FontWeight.bold, color: p.text),
              ),
              const SizedBox(height: AppSpacing.md),
              ...grouped.entries.map((entry) {
                final topic = entry.key;
                final lessons = entry.value;

                if (_selectedFilter != 'Semua' &&
                    _selectedFilter != topic &&
                    !_statusFilters.contains(_selectedFilter)) {
                  return const SizedBox.shrink();
                }

                // Filter by search query + status filter (dari DB backend).
                final filteredLessons = lessons.where((l) {
                  if (_statusFilters.contains(_selectedFilter) &&
                      statusOf(l) != _statusLabels[_selectedFilter]) {
                    return false;
                  }
                  if (query.isEmpty) return true;
                  return l.title.toLowerCase().contains(query) ||
                      l.topic.toLowerCase().contains(query);
                }).toList();

                if (filteredLessons.isEmpty) {
                  return const SizedBox.shrink();
                }

                final isHtml = topic.toLowerCase().contains('html') || topic.toLowerCase().contains('web');

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                isHtml ? Icons.language_rounded : Icons.code_rounded,
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
                                    style: AppTypography.titleM.copyWith(fontWeight: FontWeight.bold, color: p.text),
                                  ),
                                  Text(
                                    '${lessons.length} Bab • Kurikulum SMK RPL',
                                    style: AppTypography.caption.copyWith(color: p.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(),
                        const SizedBox(height: AppSpacing.sm),
                        ...filteredLessons.map((l) {
                          final isLocked = l.status == 'locked';
                          final isCompleted = l.status == 'completed';

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? p.success.withValues(alpha: 0.15)
                                    : isLocked
                                        ? p.surfaceAlt
                                        : p.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCompleted
                                    ? Icons.check
                                    : isLocked
                                        ? Icons.lock_outline_rounded
                                        : Icons.play_arrow_rounded,
                                size: 18,
                                color: isCompleted
                                    ? p.success
                                    : isLocked
                                        ? p.textMuted
                                        : p.primary,
                              ),
                            ),
                            title: Text(
                              'Bab ${l.orderIndex}: ${l.title}',
                              style: AppTypography.bodyM.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isLocked ? p.textMuted : p.text,
                              ),
                            ),
                            subtitle: Text(
                              isLocked
                                  ? (l.requiredLessonTitle != null ? 'Syarat: ${l.requiredLessonTitle}' : 'Terkunci')
                                  : '+${l.xpReward} XP',
                              style: AppTypography.caption.copyWith(color: p.textMuted),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                            onTap: () {
                              if (isLocked) {
                                showAppSnack(
                                  context,
                                  l.requiredLessonTitle != null
                                      ? 'Selesaikan ${l.requiredLessonTitle} terlebih dahulu.'
                                      : 'Bab ini masih terkunci.',
                                );
                              } else {
                                context.push(AppRoutes.lesson(l.id));
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? p.primary : p.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? p.primary : p.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: isSelected ? Colors.white : p.text,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
