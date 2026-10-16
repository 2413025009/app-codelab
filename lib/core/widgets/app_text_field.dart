import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Text field with the label fixed above the box (DESIGN.md §3.1).
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.hintAside,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.prefixIcon,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUnfocus,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  /// Small right-aligned text next to the label (e.g. "Sesuai absen kelas").
  final String? hintAside;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    Widget? suffix;
    if (widget.obscure) {
      suffix = IconButton(
        tooltip: _hidden ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
        constraints: const BoxConstraints(minWidth: AppSizes.minTouch, minHeight: AppSizes.minTouch),
        icon: Icon(_hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: p.textMuted),
        onPressed: () => setState(() => _hidden = !_hidden),
      );
    } else if (widget.prefixIcon != null) {
      suffix = Icon(widget.prefixIcon, color: p.textMuted);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.label, style: AppTypography.label.copyWith(color: p.textMuted))),
            if (widget.hintAside != null)
              Text(widget.hintAside!, style: AppTypography.caption.copyWith(color: p.textMuted)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: widget.controller,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTypography.bodyL.copyWith(color: p.text),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: suffix,
            constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
          ),
        ),
      ],
    );
  }
}
