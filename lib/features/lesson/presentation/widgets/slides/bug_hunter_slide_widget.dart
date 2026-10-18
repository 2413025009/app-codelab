import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_tag.dart';
import '../../../../../core/widgets/code_window_shell.dart';
import '../../../domain/slide_models.dart';

class BugHunterSlideWidget extends StatefulWidget {
  const BugHunterSlideWidget({
    super.key,
    required this.slide,
    required this.onAnswerChanged,
  });

  final BugHunterSlide slide;
  final ValueChanged<bool> onAnswerChanged;

  @override
  BugHunterSlideWidgetState createState() => BugHunterSlideWidgetState();
}

class BugHunterSlideWidgetState extends State<BugHunterSlideWidget> {
  int? _selectedLine;

  void resetAnswer() {
    setState(() {
      _selectedLine = null;
      widget.onAnswerChanged(false);
    });
  }

  bool checkAnswer() {
    return _selectedLine == widget.slide.correctLine;
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
                'Bug Hunter',
                background: const Color(0xFFFDECEE),
                foreground: p.error,
                icon: Icons.bug_report_rounded,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.slide.errorType,
                  style: AppTypography.code.copyWith(color: p.error, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.slide.title,
            style: AppTypography.titleL.copyWith(color: p.text, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.slide.instruction,
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Code container — editor terang ala Stitch v2 (§2.3 bug hunter)
          CodeWindowShell(
            fileName: 'script_bermasalah.py',
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: widget.slide.lines.map((line) {
                  final isSelected = _selectedLine == line.number;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLine = line.number;
                        widget.onAnswerChanged(true);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: isSelected
                          ? p.error.withValues(alpha: 0.10)
                          : Colors.transparent,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${line.number}',
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                color: isSelected ? p.error : p.textMuted,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              line.code,
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                color: isSelected ? p.error : p.text,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.bug_report_rounded, color: p.error, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Ketuk baris yang menurutmu mengandung galat penulisan di atas.',
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
        ],
      ),
    );
  }
}
