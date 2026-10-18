import 'package:flutter/material.dart';

/// Design tokens (docs/DESIGN.md §2.1). Exposed as a [ThemeExtension] so every
/// widget reads colours through `context.palette` and dark mode works from day one.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.outline,
    required this.text,
    required this.textMuted,
    required this.primary,
    required this.primaryContainer,
    required this.accent,
    required this.success,
    required this.successContainer,
    required this.error,
    required this.errorContainer,
    required this.warningContainer,
    required this.warningText,
    required this.codeBg,
  });

  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color outline;
  final Color text;
  final Color textMuted;
  final Color primary;
  final Color primaryContainer;
  final Color accent;
  final Color success;
  final Color successContainer;
  final Color error;
  final Color errorContainer;
  final Color warningContainer;
  final Color warningText;
  final Color codeBg;

  /// Text colour that sits on top of [accent] (always dark, per DESIGN.md).
  static const Color onAccent = Color(0xFF1F2430);

  static const light = AppPalette(
    bg: Color(0xFFFAF9FF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1EFE9),
    outline: Color(0xFFE4E1D9),
    text: Color(0xFF1F2430),
    textMuted: Color(0xFF5B6475),
    primary: Color(0xFF2F6FED),
    primaryContainer: Color(0xFFE4EDFF),
    accent: Color(0xFFFFC145),
    success: Color(0xFF2FA36B),
    successContainer: Color(0xFFE3F5EC),
    error: Color(0xFFD93F45),
    errorContainer: Color(0xFFFFDAD6),
    warningContainer: Color(0xFFFFF4DC),
    warningText: Color(0xFF9D4200),
    codeBg: Color(0xFFF1EFE9),
  );

  static const dark = AppPalette(
    bg: Color(0xFF14161B),
    surface: Color(0xFF1D2027),
    surfaceAlt: Color(0xFF262A33),
    outline: Color(0xFF343945),
    text: Color(0xFFF2F3F5),
    textMuted: Color(0xFFA3AAB8),
    primary: Color(0xFF6C9BFF),
    primaryContainer: Color(0xFF1F2F57),
    accent: Color(0xFFFFC145),
    success: Color(0xFF4CC38A),
    successContainer: Color(0xFF173A2B),
    error: Color(0xFFFF7A7F),
    errorContainer: Color(0xFF4A2326),
    warningContainer: Color(0xFF3D3015),
    warningText: Color(0xFFFFC145),
    codeBg: Color(0xFF262A33),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) =>
      t < 0.5 ? this : (other as AppPalette? ?? this);
}

extension PaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
