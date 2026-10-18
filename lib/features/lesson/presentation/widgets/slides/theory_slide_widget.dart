import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_tag.dart';
import '../../../../../core/widgets/code_card.dart';
import '../../../domain/slide_models.dart';

class TheorySlideWidget extends StatelessWidget {
  const TheorySlideWidget({super.key, required this.slide});

  final TheorySlide slide;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTag(
                'Teori & Konsep',
                background: p.primaryContainer,
                foreground: p.primary,
                icon: Icons.menu_book_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            slide.title,
            style: AppTypography.titleL.copyWith(color: p.text, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          _MarkdownBody(content: slide.content),
          if (slide.codeSnippet != null && slide.codeSnippet!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            CodeCard(
              fileName: slide.codeFileName ?? 'contoh_kode.py',
              code: slide.codeSnippet!,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            color: p.surfaceAlt,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: p.accent, size: 24),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Pahami konsep di atas dengan seksama sebelum melanjutkan ke latihan interaktif.',
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
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

class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final paragraphs = content.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        final text = para.trim();
        if (text.isEmpty) return const SizedBox.shrink();

        if (text.startsWith('- ') || text.startsWith('* ')) {
          final items = text.split('\n');
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                final cleaned = item.replaceAll(RegExp(r'^[-*]\s*'), '').trim();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Text(
                          cleaned,
                          style: AppTypography.bodyL.copyWith(color: p.text, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            text,
            style: AppTypography.bodyL.copyWith(color: p.text, height: 1.5),
          ),
        );
      }).toList(),
    );
  }
}
