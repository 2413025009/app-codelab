import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// 8pt pill progress bar. [value] is 0..1.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value, this.color, this.trackColor, this.height = 8});

  final double value;
  final Color? color;
  final Color? trackColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ClipRRect(
      borderRadius: AppRadius.pillBorder,
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        color: color ?? p.primary,
        backgroundColor: trackColor ?? p.surface,
      ),
    );
  }
}
