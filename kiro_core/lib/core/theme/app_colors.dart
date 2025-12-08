/// App color definitions and utilities.
library;

import 'package:flutter/material.dart';

/// Color palette for Kiro apps.
///
/// Provides semantic color definitions that can be customized
/// for each generated app.
class AppColors {
  AppColors._();

  // ===== Brand Colors =====

  /// Primary brand color.
  static Color primary = const Color(0xFF6366F1);

  /// Secondary accent color.
  static Color secondary = const Color(0xFF8B5CF6);

  /// Tertiary accent color.
  static Color tertiary = const Color(0xFF06B6D4);

  // ===== Semantic Colors =====

  /// Success color (green).
  static const Color success = Color(0xFF22C55E);

  /// Warning color (yellow/orange).
  static const Color warning = Color(0xFFF59E0B);

  /// Error color (red).
  static const Color error = Color(0xFFEF4444);

  /// Info color (blue).
  static const Color info = Color(0xFF3B82F6);

  // ===== Surface Colors (Light) =====

  /// Light mode background.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Light mode surface.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Light mode surface variant.
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);

  // ===== Surface Colors (Dark) =====

  /// Dark mode background.
  static const Color backgroundDark = Color(0xFF0F172A);

  /// Dark mode surface.
  static const Color surfaceDark = Color(0xFF1E293B);

  /// Dark mode surface variant.
  static const Color surfaceVariantDark = Color(0xFF334155);

  // ===== Text Colors =====

  /// Primary text color (light mode).
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Secondary text color (light mode).
  static const Color textSecondaryLight = Color(0xFF64748B);

  /// Primary text color (dark mode).
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// Secondary text color (dark mode).
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ===== Border Colors =====

  /// Border color (light mode).
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Border color (dark mode).
  static const Color borderDark = Color(0xFF475569);

  // ===== Overlay Colors =====

  /// Light overlay (for dark backgrounds).
  static const Color overlayLight = Color(0x1AFFFFFF);

  /// Dark overlay (for light backgrounds).
  static const Color overlayDark = Color(0x1A000000);

  /// Modal overlay.
  static const Color modalOverlay = Color(0x80000000);

  // ===== Social Brand Colors =====

  /// Google brand color.
  static const Color google = Color(0xFF4285F4);

  /// Apple brand color.
  static const Color apple = Color(0xFF000000);

  /// Facebook brand color.
  static const Color facebook = Color(0xFF1877F2);

  /// Twitter/X brand color.
  static const Color twitter = Color(0xFF1DA1F2);

  /// WhatsApp brand color.
  static const Color whatsapp = Color(0xFF25D366);

  // ===== Gradients =====

  /// Primary gradient.
  static LinearGradient get primaryGradient => LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Sunset gradient.
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFA726)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ocean gradient.
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Mint gradient.
  static const LinearGradient mintGradient = LinearGradient(
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Configure app colors.
  static void configure({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
  }) {
    if (primaryColor != null) primary = primaryColor;
    if (secondaryColor != null) secondary = secondaryColor;
    if (tertiaryColor != null) tertiary = tertiaryColor;
  }
}

/// Extension for color utilities.
extension ColorUtils on Color {
  /// Lighten the color by [percent] (0-100).
  Color lighten([int percent = 10]) {
    assert(percent >= 0 && percent <= 100);
    final factor = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * factor)).round(),
      (green + ((255 - green) * factor)).round(),
      (blue + ((255 - blue) * factor)).round(),
    );
  }

  /// Darken the color by [percent] (0-100).
  Color darken([int percent = 10]) {
    assert(percent >= 0 && percent <= 100);
    final factor = 1 - (percent / 100);
    return Color.fromARGB(
      alpha,
      (red * factor).round(),
      (green * factor).round(),
      (blue * factor).round(),
    );
  }

  /// Get a color with different opacity.
  Color withOpacityValue(double opacity) {
    return withValues(alpha: (opacity * 255).round().toDouble());
  }

  /// Check if color is dark.
  bool get isDark => computeLuminance() < 0.5;

  /// Check if color is light.
  bool get isLight => !isDark;

  /// Get contrasting text color (black or white).
  Color get contrastingColor => isDark ? Colors.white : Colors.black;

  /// Convert to hex string.
  String toHex({bool includeHash = true, bool includeAlpha = false}) {
    final buffer = StringBuffer();
    if (includeHash) buffer.write('#');
    if (includeAlpha) {
      buffer.write(alpha.toRadixString(16).padLeft(2, '0'));
    }
    buffer.write(red.toRadixString(16).padLeft(2, '0'));
    buffer.write(green.toRadixString(16).padLeft(2, '0'));
    buffer.write(blue.toRadixString(16).padLeft(2, '0'));
    return buffer.toString().toUpperCase();
  }

  /// Create a MaterialColor swatch from this color.
  MaterialColor toMaterialColor() {
    return MaterialColor(value, <int, Color>{
      50: lighten(45),
      100: lighten(35),
      200: lighten(25),
      300: lighten(15),
      400: lighten(5),
      500: this,
      600: darken(5),
      700: darken(10),
      800: darken(15),
      900: darken(20),
    });
  }
}

/// Parse color from hex string.
Color? colorFromHex(String hex) {
  try {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add full opacity
    }
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return null;
  }
}

