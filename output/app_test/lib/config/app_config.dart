/// Application configuration.
library;

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide configuration and initialization.
class AppConfig {
  AppConfig._();
  
  static bool _initialized = false;
  static Dio? _dio;
  static SharedPreferences? _prefs;
  
  /// Whether the app is initialized.
  static bool get isInitialized => _initialized;
  
  /// Dio instance for network requests.
  static Dio get dio {
    if (_dio == null) {
      throw StateError('AppConfig not initialized. Call AppConfig.initialize() first.');
    }
    return _dio!;
  }
  
  /// SharedPreferences instance.
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('AppConfig not initialized. Call AppConfig.initialize() first.');
    }
    return _prefs!;
  }
  
  /// API base URL.
  /// TODO: Update this with your actual API base URL.
  static const String apiBaseUrl = 'https://api.example.com';
  
  /// Initialize app services.
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize Dio for network requests
    _dio = Dio(BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add logging interceptor in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio!.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
    
    _initialized = true;
  }
  
  /// App name.
  static const String appName = 'app_test';
  
  /// Primary color.
  static const int primaryColorValue = 0xFF03bafc;
}
