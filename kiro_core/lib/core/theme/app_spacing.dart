/// Spacing and dimension constants for consistent layouts.
library;

import 'package:flutter/material.dart';

/// Spacing constants following 4px base grid.
class AppSpacing {
  AppSpacing._();

  // ===== Base Unit =====

  /// Base spacing unit (4px).
  static const double unit = 4.0;

  // ===== Size Scale =====

  /// 0px - None.
  static const double none = 0;

  /// 2px - Extra extra small.
  static const double xxs = 2;

  /// 4px - Extra small.
  static const double xs = 4;

  /// 8px - Small.
  static const double sm = 8;

  /// 12px - Medium small.
  static const double md = 12;

  /// 16px - Medium.
  static const double lg = 16;

  /// 20px - Medium large.
  static const double xl = 20;

  /// 24px - Large.
  static const double xxl = 24;

  /// 32px - Extra large.
  static const double xxxl = 32;

  /// 40px - Extra extra large.
  static const double huge = 40;

  /// 48px - Massive.
  static const double massive = 48;

  /// 64px - Giant.
  static const double giant = 64;

  // ===== Padding Presets =====

  /// No padding.
  static const EdgeInsets paddingNone = EdgeInsets.zero;

  /// Extra small padding (4px).
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);

  /// Small padding (8px).
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// Medium padding (12px).
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// Large padding (16px).
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// Extra large padding (24px).
  static const EdgeInsets paddingXl = EdgeInsets.all(xxl);

  /// Screen padding (horizontal 16, vertical 24).
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xxl,
  );

  /// Card padding (16px).
  static const EdgeInsets paddingCard = EdgeInsets.all(lg);

  /// List item padding.
  static const EdgeInsets paddingListItem = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // ===== Horizontal Padding =====

  /// Small horizontal padding.
  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);

  /// Medium horizontal padding.
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);

  /// Large horizontal padding.
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  // ===== Vertical Padding =====

  /// Small vertical padding.
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);

  /// Medium vertical padding.
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);

  /// Large vertical padding.
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  // ===== Gap Widgets =====

  /// Horizontal gap (4px).
  static const SizedBox gapXs = SizedBox(width: xs);

  /// Horizontal gap (8px).
  static const SizedBox gapSm = SizedBox(width: sm);

  /// Horizontal gap (16px).
  static const SizedBox gapMd = SizedBox(width: lg);

  /// Horizontal gap (24px).
  static const SizedBox gapLg = SizedBox(width: xxl);

  /// Vertical gap (4px).
  static const SizedBox gapVerticalXs = SizedBox(height: xs);

  /// Vertical gap (8px).
  static const SizedBox gapVerticalSm = SizedBox(height: sm);

  /// Vertical gap (16px).
  static const SizedBox gapVerticalMd = SizedBox(height: lg);

  /// Vertical gap (24px).
  static const SizedBox gapVerticalLg = SizedBox(height: xxl);

  /// Vertical gap (32px).
  static const SizedBox gapVerticalXl = SizedBox(height: xxxl);

  // ===== Border Radius =====

  /// No radius.
  static const double radiusNone = 0;

  /// Extra small radius (4px).
  static const double radiusXs = 4;

  /// Small radius (8px).
  static const double radiusSm = 8;

  /// Medium radius (12px).
  static const double radiusMd = 12;

  /// Large radius (16px).
  static const double radiusLg = 16;

  /// Extra large radius (24px).
  static const double radiusXl = 24;

  /// Full radius (circular).
  static const double radiusFull = 9999;

  /// Border radius presets.
  static const BorderRadius borderRadiusXs =
      BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));

  // ===== Icon Sizes =====

  /// Small icon (16px).
  static const double iconSm = 16;

  /// Medium icon (24px).
  static const double iconMd = 24;

  /// Large icon (32px).
  static const double iconLg = 32;

  /// Extra large icon (48px).
  static const double iconXl = 48;

  // ===== Avatar Sizes =====

  /// Extra small avatar (24px).
  static const double avatarXs = 24;

  /// Small avatar (32px).
  static const double avatarSm = 32;

  /// Medium avatar (40px).
  static const double avatarMd = 40;

  /// Large avatar (56px).
  static const double avatarLg = 56;

  /// Extra large avatar (80px).
  static const double avatarXl = 80;

  // ===== Button Heights =====

  /// Small button height (32px).
  static const double buttonHeightSm = 32;

  /// Medium button height (44px).
  static const double buttonHeightMd = 44;

  /// Large button height (52px).
  static const double buttonHeightLg = 52;

  // ===== Input Heights =====

  /// Small input height (36px).
  static const double inputHeightSm = 36;

  /// Medium input height (48px).
  static const double inputHeightMd = 48;

  /// Large input height (56px).
  static const double inputHeightLg = 56;
}

/// Extension for easier gap creation.
extension SpacingExtension on num {
  /// Create a horizontal gap.
  SizedBox get horizontalGap => SizedBox(width: toDouble());

  /// Create a vertical gap.
  SizedBox get verticalGap => SizedBox(height: toDouble());

  /// Create symmetric EdgeInsets.
  EdgeInsets get padding => EdgeInsets.all(toDouble());

  /// Create horizontal EdgeInsets.
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Create vertical EdgeInsets.
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Create border radius.
  BorderRadius get borderRadius =>
      BorderRadius.all(Radius.circular(toDouble()));
}

