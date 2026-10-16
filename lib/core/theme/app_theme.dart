import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Builds the custom Material 3 theme (identical look on iOS and Android).
abstract final class AppTheme {
  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
    ).copyWith(
      primary: p.primary,
      onPrimary: Colors.white,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.text,
      surface: p.surface,
      onSurface: p.text,
      outline: p.outline,
      error: p.error,
      surfaceContainerHighest: p.surfaceAlt,
    );

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      fontFamily: AppFonts.sans,
      extensions: [p],
      textTheme: TextTheme(
        displayLarge: AppTypography.display.copyWith(color: p.text),
        headlineMedium: AppTypography.titleL.copyWith(color: p.text),
        titleLarge: AppTypography.titleL.copyWith(color: p.text),
        titleMedium: AppTypography.titleM.copyWith(color: p.text),
        bodyLarge: AppTypography.bodyL.copyWith(color: p.text),
        bodyMedium: AppTypography.bodyM.copyWith(color: p.text),
        labelLarge: AppTypography.label.copyWith(color: p.text),
        bodySmall: AppTypography.caption.copyWith(color: p.textMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleM.copyWith(color: p.text),
      ),
      dividerTheme: DividerThemeData(color: p.outline, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppTypography.bodyL.copyWith(color: p.textMuted.withValues(alpha: 0.7)),
        enabledBorder: border(p.outline),
        border: border(p.outline),
        focusedBorder: border(p.primary, 2),
        errorBorder: border(p.error, 2),
        focusedErrorBorder: border(p.error, 2),
        errorStyle: AppTypography.caption.copyWith(color: p.error),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.primaryContainer,
        surfaceTintColor: Colors.transparent,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? p.primary : p.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? p.primary : p.textMuted, size: 24);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.text,
        contentTextStyle: AppTypography.bodyM.copyWith(color: p.bg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.bg,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
