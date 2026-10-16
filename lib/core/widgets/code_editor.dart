import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

/// Minimal mobile code editor: monospaced, line-number gutter, horizontal scroll
/// (no wrapping so the gutter always stays aligned).
class CodeEditor extends StatelessWidget {
  const CodeEditor({super.key, required this.controller, this.focusNode, this.minLines = 8, this.readOnly = false});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final int minLines;
  final bool readOnly;

  static const _charWidth = 7.9; // 13px JetBrains Mono advance ≈ 0.6em

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final style = AppTypography.code.copyWith(color: p.text, height: 1.7);
    final gutterStyle = style.copyWith(color: p.textMuted.withValues(alpha: 0.7));

    return LayoutBuilder(
      builder: (context, constraints) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final lines = controller.text.split('\n');
          final lineCount = math.max(lines.length, minLines);
          final longest = lines.fold<int>(0, (m, l) => math.max(m, l.length));
          final textWidth = math.max(constraints.maxWidth - 56, longest * _charWidth + 48);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                padding: const EdgeInsets.fromLTRB(0, 14, 8, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [for (var i = 1; i <= lineCount; i++) Text('$i', style: gutterStyle)],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: textWidth,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      readOnly: readOnly,
                      maxLines: null,
                      minLines: minLines,
                      keyboardType: TextInputType.multiline,
                      autocorrect: false,
                      enableSuggestions: false,
                      smartDashesType: SmartDashesType.disabled,
                      smartQuotesType: SmartQuotesType.disabled,
                      style: style,
                      cursorColor: p.primary,
                      decoration: const InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(4, 14, 8, 14),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
