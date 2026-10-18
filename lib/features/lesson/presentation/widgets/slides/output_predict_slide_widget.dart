import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_tag.dart';
import '../../../../../core/widgets/code_card.dart';
import '../../../domain/slide_models.dart';

class OutputPredictSlideWidget extends StatefulWidget {
  const OutputPredictSlideWidget({
    super.key,
    required this.slide,
    required this.onAnswerChanged,
  });

  final OutputPredictSlide slide;
  final ValueChanged<bool> onAnswerChanged;

  @override
  OutputPredictSlideWidgetState createState() => OutputPredictSlideWidgetState();
}

class OutputPredictSlideWidgetState extends State<OutputPredictSlideWidget> {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTag(
                'Tebak Output',
                background: p.primaryContainer,
                foreground: p.primary,
                icon: Icons.psychology_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.slide.title,
            style: AppTypography.titleL.copyWith(color: p.text, fontWeight: FontWeight.bold),
          ),
          if (widget.slide.codeSnippet != null && widget.slide.codeSnippet!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            CodeCard(
              fileName: 'latihan_output.py',
              code: widget.slide.codeSnippet!,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.slide.question,
            style: AppTypography.titleM.copyWith(color: p.text),
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            children: widget.slide.options.map((opt) {
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
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? p.primary : p.textMuted,
                              width: 2,
                            ),
                            color: isSelected ? p.primary : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Center(
                                  child: Icon(Icons.check, size: 14, color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              color: isSelected ? p.primary : p.text,
                              fontSize: 15,
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
