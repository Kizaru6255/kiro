/// Shadow definitions for elevation effects.
library;

import 'package:flutter/material.dart';

/// Shadow presets for consistent elevation.
class AppShadows {
  AppShadows._();

  // ===== Shadow Colors =====

  /// Light shadow color.
  static const Color _shadowLight = Color(0x1A000000);

  /// Medium shadow color.
  static const Color _shadowMedium = Color(0x26000000);

  // ===== Shadow Presets =====

  /// No shadow.
  static const List<BoxShadow> none = [];

  /// Extra small shadow (subtle).
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: _shadowLight,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Small shadow.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: _shadowLight,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: _shadowLight,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Large shadow.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: _shadowMedium,
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: _shadowLight,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// Extra large shadow.
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: _shadowMedium,
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: _shadowLight,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  /// 2XL shadow (floating elements).
  static const List<BoxShadow> xxl = [
    BoxShadow(
      color: _shadowMedium,
      blurRadius: 48,
      offset: Offset(0, 24),
    ),
    BoxShadow(
      color: _shadowLight,
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  /// Inner shadow (inset effect).
  static const List<BoxShadow> inner = [
    BoxShadow(
      color: _shadowLight,
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -1,
    ),
  ];

  // ===== Colored Shadows =====

  /// Create a colored shadow.
  static List<BoxShadow> colored({
    required Color color,
    double blur = 16,
    double opacity = 0.3,
    Offset offset = const Offset(0, 8),
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        offset: offset,
      ),
    ];
  }

  /// Primary color shadow.
  static List<BoxShadow> primary(Color primaryColor) => colored(
        color: primaryColor,
        blur: 20,
        opacity: 0.25,
        offset: const Offset(0, 10),
      );

  /// Success color shadow.
  static List<BoxShadow> success = colored(
    color: const Color(0xFF22C55E),
    blur: 16,
    opacity: 0.25,
  );

  /// Error color shadow.
  static List<BoxShadow> error = colored(
    color: const Color(0xFFEF4444),
    blur: 16,
    opacity: 0.25,
  );

  // ===== Component Shadows =====

  /// Card shadow.
  static const List<BoxShadow> card = sm;

  /// Elevated card shadow.
  static const List<BoxShadow> cardElevated = md;

  /// Button shadow.
  static const List<BoxShadow> button = xs;

  /// Button hover shadow.
  static const List<BoxShadow> buttonHover = sm;

  /// Modal/dialog shadow.
  static const List<BoxShadow> modal = xl;

  /// Bottom navigation shadow.
  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: _shadowLight,
      blurRadius: 8,
      offset: Offset(0, -4),
    ),
  ];

  /// App bar shadow.
  static const List<BoxShadow> appBar = [
    BoxShadow(
      color: _shadowLight,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Dropdown shadow.
  static const List<BoxShadow> dropdown = lg;

  /// Tooltip shadow.
  static const List<BoxShadow> tooltip = sm;

  /// FAB shadow.
  static const List<BoxShadow> fab = lg;
}

