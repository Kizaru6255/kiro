/// Theme manager for Kiro apps.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Theme mode options.
enum KiroThemeMode {
  /// Use system setting.
  system,

  /// Force light mode.
  light,

  /// Force dark mode.
  dark,
}

/// Theme configuration for generated apps.
class ThemeConfig {
  /// Primary brand color.
  final Color primaryColor;

  /// Secondary accent color.
  final Color? secondaryColor;

  /// Tertiary color.
  final Color? tertiaryColor;

  /// Primary font family.
  final String? fontFamily;

  /// Secondary font family (headings).
  final String? fontFamilySecondary;

  /// Whether to use Material 3.
  final bool useMaterial3;

  /// Default theme mode.
  final KiroThemeMode defaultMode;

  const ThemeConfig({
    required this.primaryColor,
    this.secondaryColor,
    this.tertiaryColor,
    this.fontFamily,
    this.fontFamilySecondary,
    this.useMaterial3 = true,
    this.defaultMode = KiroThemeMode.system,
  });

  /// Default theme configuration.
  static const ThemeConfig defaultConfig = ThemeConfig(
    primaryColor: Color(0xFF6366F1),
  );
}

/// Theme manager for creating and managing app themes.
///
/// Example:
/// ```dart
/// final themeManager = ThemeManager(
///   config: ThemeConfig(
///     primaryColor: Colors.blue,
///     fontFamily: 'Poppins',
///   ),
/// );
///
/// MaterialApp(
///   theme: themeManager.lightTheme,
///   darkTheme: themeManager.darkTheme,
///   themeMode: themeManager.themeMode,
/// );
/// ```
class ThemeManager extends ChangeNotifier {
  ThemeConfig _config;
  KiroThemeMode _mode;

  ThemeData? _lightTheme;
  ThemeData? _darkTheme;

  /// Create a theme manager.
  ThemeManager({
    ThemeConfig config = ThemeConfig.defaultConfig,
  })  : _config = config,
        _mode = config.defaultMode {
    _initializeColors();
    _buildThemes();
  }

  /// Current theme configuration.
  ThemeConfig get config => _config;

  /// Current theme mode.
  KiroThemeMode get mode => _mode;

  /// Get Flutter ThemeMode.
  ThemeMode get themeMode => switch (_mode) {
        KiroThemeMode.light => ThemeMode.light,
        KiroThemeMode.dark => ThemeMode.dark,
        KiroThemeMode.system => ThemeMode.system,
      };

  /// Light theme.
  ThemeData get lightTheme => _lightTheme!;

  /// Dark theme.
  ThemeData get darkTheme => _darkTheme!;

  /// Update theme configuration.
  void updateConfig(ThemeConfig config) {
    _config = config;
    _initializeColors();
    _buildThemes();
    notifyListeners();
  }

  /// Set theme mode.
  void setMode(KiroThemeMode mode) {
    if (_mode != mode) {
      _mode = mode;
      _updateSystemUI();
      notifyListeners();
    }
  }

  /// Toggle between light and dark.
  void toggleMode() {
    setMode(_mode == KiroThemeMode.light
        ? KiroThemeMode.dark
        : KiroThemeMode.light);
  }

  /// Check if currently in dark mode.
  bool isDarkMode(BuildContext context) {
    if (_mode == KiroThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _mode == KiroThemeMode.dark;
  }

  void _initializeColors() {
    AppColors.configure(
      primaryColor: _config.primaryColor,
      secondaryColor: _config.secondaryColor,
      tertiaryColor: _config.tertiaryColor,
    );

    if (_config.fontFamily != null || _config.fontFamilySecondary != null) {
      AppTypography.configure(
        primaryFont: _config.fontFamily,
        secondaryFont: _config.fontFamilySecondary ?? _config.fontFamily,
      );
    }
  }

  void _buildThemes() {
    _lightTheme = _buildLightTheme();
    _darkTheme = _buildDarkTheme();
  }

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _config.primaryColor,
      brightness: Brightness.light,
      primary: _config.primaryColor,
      secondary: _config.secondaryColor,
      tertiary: _config.tertiaryColor,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: _config.useMaterial3,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTypography.textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: BorderSide(color: AppColors.borderLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          side: BorderSide(color: AppColors.borderLight),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: _config.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: _config.primaryColor,
        unselectedItemColor: AppColors.textSecondaryLight,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _config.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _config.primaryColor,
      brightness: Brightness.dark,
      primary: _config.primaryColor,
      secondary: _config.secondaryColor,
      tertiary: _config.tertiaryColor,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: _config.useMaterial3,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: BorderSide(color: AppColors.borderDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          side: BorderSide(color: AppColors.borderDark),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: _config.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: _config.primaryColor,
        unselectedItemColor: AppColors.textSecondaryDark,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _config.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),
    );
  }

  void _updateSystemUI() {
    final isDark = _mode == KiroThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

