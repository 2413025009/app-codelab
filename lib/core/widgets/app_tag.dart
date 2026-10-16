import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Pill tag / chip, 28pt high.
class AppTag extends StatelessWidget {
  const AppTag(
    this.label, {
    super.key,
    this.background,
    this.foreground,
    this.icon,
    this.mono = false,
  });

  final String label;
  final Color? background;
  final Color? foreground;
  final IconData? icon;
  final bool mono;

  factory AppTag.primary(BuildContext context, String label, {IconData? icon}) {
    final p = context.palette;
    return AppTag(label, background: p.primaryContainer, foreground: p.primary, icon: icon);
  }

  factory AppTag.success(BuildContext context, String label, {IconData? icon}) {
    final p = context.palette;
    return AppTag(label, background: p.successContainer, foreground: p.success, icon: icon);
  }

  factory AppTag.xp(BuildContext context, String label) {
    final p = context.palette;
    return AppTag(label, background: p.warningContainer, foreground: p.warningText, icon: Icons.bolt_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final fg = foreground ?? p.textMuted;
    return Container(
      height: AppSizes.tagHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: background ?? p.surfaceAlt, borderRadius: AppRadius.pillBorder),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontFamily: mono ? AppFonts.mono : null,
            ),
          ),
        ],
      ),
    );
  }
}
