import 'package:flutter/material.dart';

/// Typography scale (docs/DESIGN.md §2.2). Colours are applied by the theme /
/// call sites, not baked in here.
abstract final class AppFonts {
  static const String sans = 'PlusJakartaSans';
  static const String mono = 'JetBrainsMono';
}

abstract final class AppTypography {
  static const TextStyle display = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );
  static const TextStyle titleL = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 24,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );
  static const TextStyle titleM = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 20,
    height: 1.35,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );
  static const TextStyle bodyL = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyM = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 14,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelL = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelM = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle labelSm = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle bodySm = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle code = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 13,
    height: 1.6,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle codeSm = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    height: 1.5,
    fontWeight: FontWeight.w500,
  );
}
