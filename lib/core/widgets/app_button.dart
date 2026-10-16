import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonKind { primary, secondary, text }

/// Pill button (DESIGN.md §3.2). Loading state keeps its width and blocks taps.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.loading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final bool loading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = widget.onPressed != null && !widget.loading;
    final disabledByState = widget.onPressed == null && !widget.loading;

    Color bg;
    Color fg;
    switch (widget.kind) {
      case AppButtonKind.primary:
        bg = p.primary;
        fg = Colors.white;
      case AppButtonKind.secondary:
        bg = p.surfaceAlt;
        fg = p.text;
      case AppButtonKind.text:
        bg = Colors.transparent;
        fg = p.primary;
    }
    if (disabledByState && widget.kind != AppButtonKind.text) {
      bg = p.surfaceAlt;
      fg = p.textMuted;
    }

    final content = widget.loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: 20, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(color: fg, fontSize: 15),
                ),
              ),
              if (widget.trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.trailingIcon, size: 20, color: fg),
              ],
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: AnimatedScale(
        scale: _pressed && enabled ? 0.98 : 1,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: widget.expand ? double.infinity : null,
          height: AppSizes.buttonHeight,
          child: Material(
            color: bg,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? widget.onPressed : null,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
