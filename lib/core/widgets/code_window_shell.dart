import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

/// Kerangka jendela editor kode versi terang (Stitch v2 §3.4):
/// kartu putih + toolbar surface-alt berisi tiga titik jendela, nama file,
/// dan status environment `Python 3.11`.
class CodeWindowShell extends StatelessWidget {
  const CodeWindowShell({super.key, required this.fileName, required this.child});

  final String fileName;

  /// Konten canvas editor (baris kode / slot input).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.outline),
        boxShadow: const [BoxShadow(color: Color(0x0F1F2430), blurRadius: 6, offset: Offset(0, 3))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: p.surfaceAlt,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const _Dot(Color(0xFFD93F45)),
                const _Dot(Color(0xFFFFC145)),
                const _Dot(Color(0xFF2FA36B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName,
                    style: AppTypography.code.copyWith(color: p.textMuted, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(999)),
                  child: Text(
                    'Python 3.11',
                    style: AppTypography.code.copyWith(color: p.textMuted, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
          child,
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
