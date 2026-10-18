import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_tag.dart';
import '../../../domain/slide_models.dart';

class QuizSlideWidget extends StatefulWidget {
  const QuizSlideWidget({
    super.key,
    required this.slide,
    required this.onAnswerChanged,
  });

  final QuizSlide slide;
  final ValueChanged<bool> onAnswerChanged;

  @override
  QuizSlideWidgetState createState() => QuizSlideWidgetState();
}

class QuizSlideWidgetState extends State<QuizSlideWidget> {
  String? _selectedOption;

  void resetAnswer() {
    setState(() {
      _selectedOption = null;
      widget.onAnswerChanged(false);
    });
  }

  bool checkAnswer() {
    final actual = _selectedOption?.trim();
    final expected = widget.slide.correctAnswer.trim();
    return actual == expected;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const letters = ['A', 'B', 'C', 'D'];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTag(
                'Kuis Konsep',
                background: p.primaryContainer,
                foreground: p.primary,
                icon: Icons.quiz_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.slide.title,
            style: AppTypography.titleL.copyWith(color: p.text, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            color: p.surfaceAlt,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              widget.slide.question,
              style: AppTypography.titleM.copyWith(color: p.text, height: 1.4),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Column(
            children: widget.slide.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              final letter = idx < letters.length ? letters[idx] : '${idx + 1}';
              final isSelected = _selectedOption == opt;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedOption = opt;
                      widget.onAnswerChanged(true);
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: AppCard(
                    color: isSelected ? p.primaryContainer.withValues(alpha: 0.35) : p.surface,
                    borderColor: isSelected ? p.primary : p.outline,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelected ? p.primary : p.surfaceAlt,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : p.text,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            opt,
                            style: AppTypography.bodyM.copyWith(
                              color: isSelected ? p.primary : p.text,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
