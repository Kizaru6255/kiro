/// Theme module for Kiro Core.
///
/// Provides:
/// - [ThemeManager] - Create and manage app themes
/// - [ThemeConfig] - Theme configuration options
/// - [AppColors] - Color palette and utilities
/// - [AppTypography] - Typography styles
/// - [AppSpacing] - Spacing and dimension constants
/// - [AppShadows] - Shadow presets
///
/// ## Quick Start
///
/// ```dart
/// // Create theme manager
/// final themeManager = ThemeManager(
///   config: ThemeConfig(
///     primaryColor: Colors.indigo,
///     fontFamily: 'Poppins',
///   ),
/// );
///
/// // Use in MaterialApp
/// MaterialApp(
///   theme: themeManager.lightTheme,
///   darkTheme: themeManager.darkTheme,
///   themeMode: themeManager.themeMode,
/// );
///
/// // Toggle theme
/// themeManager.toggleMode();
///
/// // Use spacing constants
/// Container(
///   padding: AppSpacing.paddingLg,
///   margin: AppSpacing.paddingMd,
///   decoration: BoxDecoration(
///     color: AppColors.surfaceLight,
///     borderRadius: AppSpacing.borderRadiusMd,
///     boxShadow: AppShadows.card,
///   ),
///   child: Text(
///     'Hello',
///     style: AppTypography.headlineMedium,
///   ),
/// );
/// ```
library;

export 'app_colors.dart';
export 'app_shadows.dart';
export 'app_spacing.dart';
export 'app_typography.dart';
export 'theme_manager.dart';

