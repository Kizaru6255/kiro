/// Typography definitions for Kiro apps.
library;

import 'package:flutter/material.dart';

/// Typography styles for consistent text appearance.
class AppTypography {
  AppTypography._();

  /// Default font family.
  static String fontFamily = 'Inter';

  /// Secondary font family (for headings, etc.).
  static String fontFamilySecondary = 'Inter';

  /// Configure font families.
  static void configure({
    String? primaryFont,
    String? secondaryFont,
  }) {
    if (primaryFont != null) fontFamily = primaryFont;
    if (secondaryFont != null) fontFamilySecondary = secondaryFont;
  }

  // ===== Display Styles =====

  /// Display large (57px).
  static TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Display medium (45px).
  static TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  /// Display small (36px).
  static TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  // ===== Headline Styles =====

  /// Headline large (32px).
  static TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );

  /// Headline medium (28px).
  static TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  /// Headline small (24px).
  static TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  // ===== Title Styles =====

  /// Title large (22px).
  static TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  /// Title medium (16px).
  static TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Title small (14px).
  static TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ===== Body Styles =====

  /// Body large (16px).
  static TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  /// Body medium (14px).
  static TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Body small (12px).
  static TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // ===== Label Styles =====

  /// Label large (14px).
  static TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Label medium (12px).
  static TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Label small (11px).
  static TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  /// Create a complete TextTheme.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}

