/// Encrypted storage implementation using FlutterSecureStorage.
///
/// Use for sensitive data like authentication tokens,
/// passwords, and personal information.
library;

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/errors.dart';
import 'storage_service.dart';

/// Storage implementation using FlutterSecureStorage.
///
/// Data is encrypted using:
/// - Android: AES encryption with KeyStore
/// - iOS: Keychain
///
/// Suitable for:
/// - Authentication tokens
/// - Passwords and PINs
/// - API keys
/// - Personal sensitive data
///
/// Example:
/// ```dart
/// final storage = SecureStorage();
/// await storage.init();
///
/// await storage.setString('access_token', token);
/// final token = await storage.getString('access_token');
/// ```
class SecureStorage extends StorageService with StorageJsonMixin {
  late final FlutterSecureStorage _storage;
  bool _initialized = false;

  final AndroidOptions _androidOptions;
  final IOSOptions _iosOptions;
  final LinuxOptions _linuxOptions;
  final WindowsOptions _windowsOptions;
  final MacOsOptions _macOsOptions;

  /// Create a new SecureStorage instance.
  ///
  /// Options can be customized per platform for specific security requirements.
  SecureStorage({
    AndroidOptions? androidOptions,
    IOSOptions? iosOptions,
    LinuxOptions? linuxOptions,
    WindowsOptions? windowsOptions,
    MacOsOptions? macOsOptions,
  })  : _androidOptions = androidOptions ??
            const AndroidOptions(
              encryptedSharedPreferences: true,
              sharedPreferencesName: 'kiro_secure_prefs',
              preferencesKeyPrefix: 'kiro_',
            ),
        _iosOptions = iosOptions ??
            const IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
              accountName: 'kiro_secure_storage',
            ),
        _linuxOptions = linuxOptions ?? const LinuxOptions(),
        _windowsOptions = windowsOptions ?? const WindowsOptions(),
        _macOsOptions = macOsOptions ??
            const MacOsOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
              accountName: 'kiro_secure_storage',
            );

  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> init() async {
    if (_initialized) return;

    _storage = const FlutterSecureStorage();
    _initialized = true;
  }

  /// Ensure storage is initialized before operations.
  void _ensureInitialized() {
    if (!_initialized) {
      throw const StorageNotInitializedException();
    }
  }

  // ============================================================
  // String Operations
  // ============================================================

  @override
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    try {
      await _storage.write(
        key: key,
        value: value,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        mOptions: _macOsOptions,
      );
      return true;
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write to secure storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<String?> getString(String key) async {
    _ensureInitialized();
    try {
      return await _storage.read(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        mOptions: _macOsOptions,
      );
    } catch (e, st) {
      throw StorageReadException(
        key: key,
        message: 'Failed to read from secure storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // Integer Operations (stored as strings)
  // ============================================================

  @override
  Future<bool> setInt(String key, int value) async {
    return setString(key, value.toString());
  }

  @override
  Future<int?> getInt(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  // ============================================================
  // Double Operations (stored as strings)
  // ============================================================

  @override
  Future<bool> setDouble(String key, double value) async {
    return setString(key, value.toString());
  }

  @override
  Future<double?> getDouble(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  // ============================================================
  // Boolean Operations (stored as strings)
  // ============================================================

  @override
  Future<bool> setBool(String key, bool value) async {
    return setString(key, value.toString());
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  // ============================================================
  // List Operations (stored as JSON strings)
  // ============================================================

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    return setString(key, jsonEncode(value));
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    try {
      final list = jsonDecode(value) as List;
      return list.cast<String>();
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // Object Operations
  // ============================================================

  @override
  Future<bool> setObject<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final jsonString = encodeObject(value, toJson);
      return await setString(key, jsonString);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write object to secure storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonString = await getString(key);
      return decodeObject(jsonString, fromJson);
    } catch (e, st) {
      throw DeserializationException(
        key: key,
        expectedType: T,
        message: 'Failed to deserialize object from secure storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> setObjectList<T>(
    String key,
    List<T> value,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final jsonString = encodeObjectList(value, toJson);
      return await setString(key, jsonString);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write object list to secure storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<T>?> getObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonString = await getString(key);
      return decodeObjectList(jsonString, fromJson);
    } catch (e, st) {
      throw DeserializationException(
        key: key,
        expectedType: List<T>,
        message: 'Failed to deserialize object list from secure storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // Removal Operations
  // ============================================================

  @override
  Future<bool> remove(String key) async {
    _ensureInitialized();
    try {
      await _storage.delete(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        mOptions: _macOsOptions,
      );
      return true;
    } catch (e, st) {
      throw StorageException(
        message: 'Failed to delete from secure storage',
        code: 'SECURE_STORAGE_DELETE_FAILED',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> clear() async {
    _ensureInitialized();
    try {
      await _storage.deleteAll(
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        mOptions: _macOsOptions,
      );
      return true;
    } catch (e, st) {
      throw StorageException(
        message: 'Failed to clear secure storage',
        code: 'SECURE_STORAGE_CLEAR_FAILED',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // Utility Operations
  // ============================================================

  @override
  Future<bool> containsKey(String key) async {
    _ensureInitialized();
    try {
      return await _storage.containsKey(
        key: key,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        mOptions: _macOsOptions,
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Set<String>> getKeys() async {
    _ensureInitialized();
    try {
      final all = await _storage.readAll(
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        mOptions: _macOsOptions,
      );
      return all.keys.toSet();
    } catch (_) {
      return {};
    }
  }

  /// Read all key-value pairs.
  ///
  /// Use with caution - may expose sensitive data.
  Future<Map<String, String>> readAll() async {
    _ensureInitialized();
    return await _storage.readAll(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      lOptions: _linuxOptions,
      wOptions: _windowsOptions,
      mOptions: _macOsOptions,
    );
  }
}

