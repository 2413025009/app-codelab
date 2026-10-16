import 'package:flutter/material.dart';

/// Spacing scale (4 · 8 · 12 · 16 · 24 · 32 · 48), screen margin and radii
/// from docs/DESIGN.md §2.3.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;

  /// Horizontal screen margin.
  static const double screen = 20;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: screen);
}

abstract final class AppRadius {
  static const double card = 20;
  static const double input = 14;
  static const double sheetTop = 28;
  static const double pill = 999;

  static BorderRadius get cardBorder => BorderRadius.circular(card);
  static BorderRadius get inputBorder => BorderRadius.circular(input);
  static BorderRadius get pillBorder => BorderRadius.circular(pill);
}

abstract final class AppSizes {
  static const double inputHeight = 56;
  static const double buttonHeight = 52;
  static const double tagHeight = 28;
  static const double minTouch = 48;
}
