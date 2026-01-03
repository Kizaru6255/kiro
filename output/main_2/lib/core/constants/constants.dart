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
  
  static const String name = 'main_2';
  static const String version = '1.0.0';
}
