import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Opens a rounded bottom sheet with a drag handle, title and close button.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  IconData? leadingIcon,
  required WidgetBuilder builder,
  bool fullHeight = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * (fullHeight ? 0.95 : 0.88)),
    builder: (ctx) => _SheetFrame(title: title, subtitle: subtitle, leadingIcon: leadingIcon, child: builder(ctx)),
  );
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, this.subtitle, this.leadingIcon, required this.child});

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 44,
          height: 5,
          decoration: BoxDecoration(color: p.outline, borderRadius: AppRadius.pillBorder),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 16, 12, 12),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: p.primaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: Icon(leadingIcon, color: p.primary),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleM.copyWith(color: p.text)),
                    if (subtitle != null)
                      Text(subtitle!, style: AppTypography.caption.copyWith(color: p.textMuted)),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Tutup',
                style: IconButton.styleFrom(
                  backgroundColor: p.surfaceAlt,
                  foregroundColor: p.textMuted,
                  minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch),
                ),
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Divider(color: p.outline),
        // Sistemis anti-overflow: konten sheet TIDAK WAJIB scrollable sendiri
        // (beberapa caller memakai Column min). Dibungkus bilden scroll di
        // sini supaya konten melebihi sisa tinggi -> bisa digulir, bukan
        // "bottom overflowed" persis di baris tombol.
        Flexible(
          child: SingleChildScrollView(child: child),
        ),
      ],
    );
  }
}
