/// Authentication local data source.
/// 
/// Handles local storage for authentication tokens.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Storage keys for authentication.
class AuthStorageKeys {
  AuthStorageKeys._();
  
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}

/// Local data source for authentication tokens.
abstract class AuthLocalDataSource {
  /// Save access token.
  Future<void> saveAccessToken(String token);

  /// Get access token.
  Future<String?> getAccessToken();

  /// Save refresh token.
  Future<void> saveRefreshToken(String token);

  /// Get refresh token.
  Future<String?> getRefreshToken();

  /// Clear all tokens.
  Future<void> clearTokens();
}

/// Implementation of auth local data source.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AuthStorageKeys.accessToken, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: AuthStorageKeys.accessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AuthStorageKeys.refreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AuthStorageKeys.refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: AuthStorageKeys.accessToken);
    await _storage.delete(key: AuthStorageKeys.refreshToken);
  }
}
