import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_tag.dart';
import '../../../../../core/widgets/code_window_shell.dart';
import '../../../domain/slide_models.dart';

class TypeCodeSlideWidget extends StatefulWidget {
  const TypeCodeSlideWidget({
    super.key,
    required this.slide,
    required this.onAnswerChanged,
  });

  final TypeCodeSlide slide;
  final ValueChanged<bool> onAnswerChanged;

  @override
  TypeCodeSlideWidgetState createState() => TypeCodeSlideWidgetState();
}

class TypeCodeSlideWidgetState extends State<TypeCodeSlideWidget> {
  late final TextEditingController _controller;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onAnswerChanged(_controller.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void resetAnswer() {
    setState(() {
      _controller.clear();
      _showHint = false;
      widget.onAnswerChanged(false);
    });
  }

  bool checkAnswer() {
    final actual = _controller.text.trim().toLowerCase();
    final expected = widget.slide.expectedAnswer.trim().toLowerCase();
    return actual == expected;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final parts = widget.slide.codeTemplate.split('[input]');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTag(
                'Ketik Kode',
                background: p.primaryContainer,
                foreground: p.primary,
                icon: Icons.keyboard_rounded,
              ),
              const Spacer(),
              if (widget.slide.hint.isNotEmpty)
                TextButton.icon(
                  onPressed: () => setState(() => _showHint = !_showHint),
                  icon: Icon(Icons.lightbulb_outline_rounded, size: 18, color: p.accent),
                  label: Text('Petunjuk', style: AppTypography.label.copyWith(color: p.accent)),
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
          if (_showHint && widget.slide.hint.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            AppCard(
              color: p.surfaceAlt,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.tips_and_updates_rounded, color: p.accent, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.slide.hint,
                      style: AppTypography.caption.copyWith(color: p.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          // Code Input Container — editor terang ala Stitch v2 (§2.3 ketik kata kunci)
          CodeWindowShell(
            fileName: widget.slide.file,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (parts.isNotEmpty && parts[0].isNotEmpty)
                    Text(
                      parts[0],
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        color: p.text,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  Container(
                    width: 140,
                    height: 38,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: p.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: p.primary, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controller,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        color: p.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: p.primary,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: InputBorder.none,
                        hintText: 'ketik di sini...',
                        hintStyle: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          color: p.textMuted.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  if (parts.length > 1 && parts[1].isNotEmpty)
                    Text(
                      parts[1],
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        color: p.text,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
