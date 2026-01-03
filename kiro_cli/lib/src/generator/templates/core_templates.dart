/// Core folder templates.
library;

/// Generate core.dart barrel file.
/// Note: Core infrastructure (network, storage, etc.) comes from kiro_core package.
String generateCoreBarrel() => '''
/// Core module - app-specific infrastructure.
/// 
/// Note: Core infrastructure services (network, storage, permissions, theme, etc.)
/// are provided by the kiro_core package. Import them directly:
/// 
/// ```dart
/// import 'package:kiro_core/kiro_core.dart';
/// ```
library;

export 'constants/constants.dart';
export 'extensions/extensions.dart';
// Services and utils are app-specific if needed
// Core utilities come from kiro_core package
''';

/// Generate constants.dart.
String generateConstants({required String appName}) => '''
/// App-specific constants.
/// 
/// Note: Core storage keys are provided by kiro_core's StorageKeys class.
/// Import them: import 'package:kiro_core/kiro_core.dart';
library;

/// API configuration for this app.
class ApiConfig {
  ApiConfig._();
  
  /// TODO: Update this with your actual API base URL.
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
}

/// App-specific storage keys.
/// 
/// Note: Common storage keys (accessToken, refreshToken, etc.) are available
/// in kiro_core's StorageKeys class. Use this for app-specific keys only.
class AppStorageKeys {
  AppStorageKeys._();
  
  // Add app-specific storage keys here
  // Example: static const String userPreferences = 'app.user_preferences';
}

/// App info.
class AppInfo {
  AppInfo._();
  
  static const String name = '$appName';
  static const String version = '1.0.0';
}
''';

/// Generate extensions.dart.
String generateExtensions() => '''
/// Useful extensions.
library;

import 'package:flutter/material.dart';

/// String extensions.
extension StringX on String {
  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '\${this[0].toUpperCase()}\${substring(1)}';
  }
  
  /// Check if string is valid email.
  bool get isEmail {
    return RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(this);
  }
  
  /// Check if string is valid phone.
  bool get isPhone {
    return RegExp(r'^\\+?[0-9]{10,15}\$').hasMatch(replaceAll(RegExp(r'[\\s-]'), ''));
  }
}

/// Context extensions.
extension ContextX on BuildContext {
  /// Get theme.
  ThemeData get theme => Theme.of(this);
  
  /// Get text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Get color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Get screen size.
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Get screen width.
  double get screenWidth => screenSize.width;
  
  /// Get screen height.
  double get screenHeight => screenSize.height;
  
  /// Show snackbar.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}
''';

/// Generate services.dart.
/// Note: Core services (network, storage, etc.) are provided by kiro_core package.
/// This file is kept for app-specific service exports if needed.
String generateServices() => '''
/// App-specific services.
/// 
/// Note: Core infrastructure services (network, storage, permissions, etc.)
/// are provided by the kiro_core package. Import them directly:
/// 
/// ```dart
/// import 'package:kiro_core/kiro_core.dart';
/// 
/// // Use DioClient for network requests
/// final response = await DioClient.instance.get('/api/users');
/// 
/// // Use PrefStorage for local storage
/// final storage = PrefStorage();
/// await storage.init();
/// await storage.setString('key', 'value');
/// ```
library;

// Export app-specific services here if needed
// Example: export 'custom_api_service.dart';
''';

/// Generate utils.dart.
/// Note: Core utilities (validators, formatters, etc.) are provided by kiro_core.
String generateUtils() => '''
/// App-specific utility functions.
/// 
/// Note: Core utilities (validators, formatters, extensions, etc.)
/// are provided by the kiro_core package. Import them directly:
/// 
/// ```dart
/// import 'package:kiro_core/kiro_core.dart';
/// 
/// // Use validators from kiro_core
/// final isValid = Validators.email('test@example.com');
/// ```
library;

// Export app-specific utilities here if needed
''';

