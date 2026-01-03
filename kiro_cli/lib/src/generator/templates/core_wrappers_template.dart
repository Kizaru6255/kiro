/// Core wrapper classes to replace kiro_core functionality.
library;

/// Generate core wrappers for network and storage.
String generateCoreWrappers() => '''
/// Core wrapper classes replacing kiro_core functionality.
/// 
/// These classes provide the same interface as kiro_core but use standard packages.
library;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import 'errors/errors.dart';

/// Storage keys constants.
class StorageKeys {
  StorageKeys._();
  
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
}

/// Secure storage wrapper (replaces kiro_core SecureStorage).
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage() : _storage = const FlutterSecureStorage();

  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}

/// Helper function to create secure storage instance.
SecureStorage _createSecureStorage() => SecureStorage();
''';


