import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_snack.dart';

/// Light code card with window dots, filename and a copy button (lesson reader).
class CodeCard extends StatelessWidget {
  const CodeCard({super.key, required this.fileName, required this.code, this.spans});

  final String fileName;
  final String code;

  /// Optional pre-coloured spans; plain mono text when null.
  final List<InlineSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.codeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
            child: Row(
              children: [
                const _Dot(Color(0xFFFF5F57)),
                const _Dot(Color(0xFFFEBC2E)),
                const _Dot(Color(0xFF28C840)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(fileName, style: AppTypography.code.copyWith(color: p.textMuted, fontSize: 12)),
                ),
                CopyChip(textToCopy: code),
              ],
            ),
          ),
          Divider(color: p.outline),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text.rich(
                TextSpan(
                  style: AppTypography.code.copyWith(color: p.text),
                  children: spans ?? [TextSpan(text: code)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

/// Small "Salin" pill that copies [textToCopy] to the clipboard.
class CopyChip extends StatelessWidget {
  const CopyChip({super.key, required this.textToCopy, this.tinted = false});

  final String textToCopy;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: tinted ? p.primaryContainer : p.surface,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: textToCopy));
          if (context.mounted) showAppSnack(context, 'Kode disalin.');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 14, color: p.primary),
              const SizedBox(width: 6),
              Text('Salin', style: AppTypography.caption.copyWith(color: p.primary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal Python highlighter for the static snippets in the app.
List<InlineSpan> highlightPython(BuildContext context, String code) {
  final p = context.palette;
  final keyword = p.primary;
  final string = p.success;
  final number = const Color(0xFF9D4200);
  final comment = p.textMuted;
  final fn = const Color(0xFF9D4200);

  final re = RegExp(
    r'(#.*$)|("(?:[^"\\]|\\.)*"|' "'(?:[^'\\\\]|\\\\.)*')" r'|(\b\d+\b)|(\b(?:if|else|elif|def|return|for|while|in|print|import|and|or|not|True|False|None)\b)|(\b[a-zA-Z_]\w*(?=\())',
    multiLine: true,
  );

  final spans = <InlineSpan>[];
  var last = 0;
  for (final m in re.allMatches(code)) {
    if (m.start > last) spans.add(TextSpan(text: code.substring(last, m.start)));
    final text = m.group(0)!;
    Color c;
    FontStyle? style;
    if (m.group(1) != null) {
      c = comment;
      style = FontStyle.italic;
    } else if (m.group(2) != null) {
      c = string;
    } else if (m.group(3) != null) {
      c = number;
    } else if (m.group(4) != null) {
      c = keyword;
    } else {
      c = fn;
    }
    spans.add(TextSpan(text: text, style: TextStyle(color: c, fontStyle: style)));
    last = m.end;
  }
  if (last < code.length) spans.add(TextSpan(text: code.substring(last)));
  return spans;
}
