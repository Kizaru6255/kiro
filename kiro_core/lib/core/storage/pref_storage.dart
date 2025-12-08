/// SharedPreferences-based storage implementation.
///
/// Use for non-sensitive data like user preferences,
/// theme settings, and app state.
library;

import 'package:shared_preferences/shared_preferences.dart';

import '../errors/errors.dart';
import 'storage_service.dart';

/// Storage implementation using SharedPreferences.
///
/// Suitable for:
/// - User preferences (theme, locale)
/// - App state (onboarding completed)
/// - Non-sensitive cached data
///
/// NOT suitable for:
/// - Authentication tokens
/// - Passwords or PINs
/// - Any sensitive user data
///
/// Example:
/// ```dart
/// final storage = PrefStorage();
/// await storage.init();
///
/// await storage.setString('theme', 'dark');
/// final theme = await storage.getString('theme');
///
/// await storage.setObject('user', user, (u) => u.toJson());
/// final user = await storage.getObject('user', User.fromJson);
/// ```
class PrefStorage extends StorageService with StorageJsonMixin {
  SharedPreferences? _prefs;
  bool _initialized = false;

  /// Create a new PrefStorage instance.
  ///
  /// Call [init] before using any other methods.
  PrefStorage();

  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e, st) {
      throw StorageException(
        message: 'Failed to initialize SharedPreferences',
        code: 'STORAGE_INIT_FAILED',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Ensure storage is initialized before operations.
  void _ensureInitialized() {
    if (!_initialized || _prefs == null) {
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
      return await _prefs!.setString(key, value);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write string to storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<String?> getString(String key) async {
    _ensureInitialized();
    try {
      return _prefs!.getString(key);
    } catch (e, st) {
      throw StorageReadException(
        key: key,
        message: 'Failed to read string from storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // Integer Operations
  // ============================================================

  @override
  Future<bool> setInt(String key, int value) async {
    _ensureInitialized();
    try {
      return await _prefs!.setInt(key, value);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write int to storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<int?> getInt(String key) async {
    _ensureInitialized();
    try {
      return _prefs!.getInt(key);
    } catch (e, st) {
      throw StorageReadException(
        key: key,
        message: 'Failed to read int from storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // Double Operations
  // ============================================================

  @override
  Future<bool> setDouble(String key, double value) async {
    _ensureInitialized();
    try {
      return await _prefs!.setDouble(key, value);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write double to storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    _ensureInitialized();
    try {
      return _prefs!.getDouble(key);
    } catch (e, st) {
      throw StorageReadException(
        key: key,
        message: 'Failed to read double from storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // Boolean Operations
  // ============================================================

  @override
  Future<bool> setBool(String key, bool value) async {
    _ensureInitialized();
    try {
      return await _prefs!.setBool(key, value);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write bool to storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    _ensureInitialized();
    try {
      return _prefs!.getBool(key);
    } catch (e, st) {
      throw StorageReadException(
        key: key,
        message: 'Failed to read bool from storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  // ============================================================
  // List Operations
  // ============================================================

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    try {
      return await _prefs!.setStringList(key, value);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write string list to storage',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    _ensureInitialized();
    try {
      return _prefs!.getStringList(key);
    } catch (e, st) {
      throw StorageReadException(
        key: key,
        message: 'Failed to read string list from storage',
        originalError: e,
        stackTrace: st,
      );
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
    _ensureInitialized();
    try {
      final jsonString = encodeObject(value, toJson);
      return await _prefs!.setString(key, jsonString);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write object to storage',
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
    _ensureInitialized();
    try {
      final jsonString = _prefs!.getString(key);
      return decodeObject(jsonString, fromJson);
    } catch (e, st) {
      throw DeserializationException(
        key: key,
        expectedType: T,
        message: 'Failed to deserialize object from storage',
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
    _ensureInitialized();
    try {
      final jsonString = encodeObjectList(value, toJson);
      return await _prefs!.setString(key, jsonString);
    } catch (e, st) {
      throw StorageWriteException(
        key: key,
        message: 'Failed to write object list to storage',
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
    _ensureInitialized();
    try {
      final jsonString = _prefs!.getString(key);
      return decodeObjectList(jsonString, fromJson);
    } catch (e, st) {
      throw DeserializationException(
        key: key,
        expectedType: List<T>,
        message: 'Failed to deserialize object list from storage',
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
      return await _prefs!.remove(key);
    } catch (e, st) {
      throw StorageException(
        message: 'Failed to remove key from storage',
        code: 'STORAGE_REMOVE_FAILED',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> clear() async {
    _ensureInitialized();
    try {
      return await _prefs!.clear();
    } catch (e, st) {
      throw StorageException(
        message: 'Failed to clear storage',
        code: 'STORAGE_CLEAR_FAILED',
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
    return _prefs!.containsKey(key);
  }

  @override
  Future<Set<String>> getKeys() async {
    _ensureInitialized();
    return _prefs!.getKeys();
  }

  /// Reload storage from disk.
  ///
  /// Useful if storage might have been modified externally.
  Future<void> reload() async {
    _ensureInitialized();
    await _prefs!.reload();
  }
}

