/// Core folder templates.
library;

/// Generate core.dart barrel file.
String generateCoreBarrel() => '''
/// Core module - shared infrastructure.
library;

export 'constants/constants.dart';
export 'extensions/extensions.dart';
export 'services/services.dart';
export 'utils/utils.dart';
''';

/// Generate constants.dart.
String generateConstants({required String appName}) => '''
/// App constants.
library;

/// API configuration.
class ApiConfig {
  ApiConfig._();
  
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);
}

/// Storage keys.
class StorageKeys {
  StorageKeys._();
  
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String theme = 'theme_mode';
  static const String locale = 'locale';
  static const String onboardingComplete = 'onboarding_complete';
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
String generateServices() => '''
/// App services.
library;

export 'api_service.dart';
export 'storage_service.dart';
''';

/// Generate api_service.dart.
String generateApiService() => '''
/// API service for network requests.
library;

import 'package:dio/dio.dart';

import '../constants/constants.dart';

/// Singleton API service.
class ApiService {
  static ApiService? _instance;
  late final Dio _dio;
  
  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
  
  /// Get singleton instance.
  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }
  
  /// Set auth token.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer \$token';
  }
  
  /// Clear auth token.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
  
  /// GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }
  
  /// POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }
  
  /// PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put<T>(path, data: data, queryParameters: queryParameters);
  }
  
  /// DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.delete<T>(path, queryParameters: queryParameters);
  }
}
''';

/// Generate storage_service.dart.
String generateStorageService() => '''
/// Local storage service.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage service for persisting data.
class StorageService {
  static StorageService? _instance;
  late final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  StorageService._();
  
  /// Initialize storage.
  static Future<StorageService> init() async {
    if (_instance != null) return _instance!;
    
    _instance = StorageService._();
    _instance!._prefs = await SharedPreferences.getInstance();
    return _instance!;
  }
  
  /// Get singleton instance.
  static StorageService get instance {
    if (_instance == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _instance!;
  }
  
  // ===== Regular Storage =====
  
  String? getString(String key) => _prefs.getString(key);
  
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  
  bool? getBool(String key) => _prefs.getBool(key);
  
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  
  int? getInt(String key) => _prefs.getInt(key);
  
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  
  Future<bool> remove(String key) => _prefs.remove(key);
  
  Future<bool> clear() => _prefs.clear();
  
  // ===== Secure Storage =====
  
  Future<String?> getSecure(String key) => _secureStorage.read(key: key);
  
  Future<void> setSecure(String key, String value) => 
      _secureStorage.write(key: key, value: value);
  
  Future<void> removeSecure(String key) => _secureStorage.delete(key: key);
  
  Future<void> clearSecure() => _secureStorage.deleteAll();
}
''';

/// Generate utils.dart.
String generateUtils() => '''
/// Utility functions.
library;

export 'validators.dart';
''';

/// Generate validators.dart.
String generateValidators() => '''
/// Input validators.
library;

/// Validation result.
class ValidationResult {
  final bool isValid;
  final String? error;
  
  const ValidationResult.valid() : isValid = true, error = null;
  const ValidationResult.invalid(this.error) : isValid = false;
}

/// Common validators.
class Validators {
  Validators._();
  
  /// Validate required field.
  static ValidationResult required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('\$fieldName is required');
    }
    return const ValidationResult.valid();
  }
  
  /// Validate email.
  static ValidationResult email(String? value) {
    final req = required(value, 'Email');
    if (!req.isValid) return req;
    
    final emailRegex = RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$');
    if (!emailRegex.hasMatch(value!)) {
      return const ValidationResult.invalid('Invalid email address');
    }
    return const ValidationResult.valid();
  }
  
  /// Validate password.
  static ValidationResult password(String? value, {int minLength = 8}) {
    final req = required(value, 'Password');
    if (!req.isValid) return req;
    
    if (value!.length < minLength) {
      return ValidationResult.invalid('Password must be at least \$minLength characters');
    }
    return const ValidationResult.valid();
  }
  
  /// Validate phone number.
  static ValidationResult phone(String? value) {
    final req = required(value, 'Phone number');
    if (!req.isValid) return req;
    
    final phoneRegex = RegExp(r'^\\+?[0-9]{10,15}\$');
    final sanitized = value!.replaceAll(RegExp(r'[\\s-]'), '');
    if (!phoneRegex.hasMatch(sanitized)) {
      return const ValidationResult.invalid('Invalid phone number');
    }
    return const ValidationResult.valid();
  }
  
  /// Validate minimum length.
  static ValidationResult minLength(String? value, int min, [String fieldName = 'Field']) {
    final req = required(value, fieldName);
    if (!req.isValid) return req;
    
    if (value!.length < min) {
      return ValidationResult.invalid('\$fieldName must be at least \$min characters');
    }
    return const ValidationResult.valid();
  }
}
''';

