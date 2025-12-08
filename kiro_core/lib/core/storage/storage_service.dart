/// Abstract storage service interface.
///
/// This defines a common interface for all storage implementations,
/// enabling easy mocking for tests and swapping implementations.
library;

import 'dart:convert';

/// Abstract interface for key-value storage operations.
///
/// Implementations:
/// - [PrefStorage] - SharedPreferences for non-sensitive data
/// - [SecureStorage] - FlutterSecureStorage for sensitive data
///
/// Example:
/// ```dart
/// final storage = PrefStorage();
/// await storage.init();
///
/// await storage.setString('key', 'value');
/// final value = await storage.getString('key');
/// ```
abstract class StorageService {
  // ============================================================
  // Initialization
  // ============================================================

  /// Initialize the storage service.
  ///
  /// Must be called before any other operations.
  Future<void> init();

  /// Whether the storage has been initialized.
  bool get isInitialized;

  // ============================================================
  // String Operations
  // ============================================================

  /// Store a string value.
  Future<bool> setString(String key, String value);

  /// Retrieve a string value.
  Future<String?> getString(String key);

  // ============================================================
  // Integer Operations
  // ============================================================

  /// Store an integer value.
  Future<bool> setInt(String key, int value);

  /// Retrieve an integer value.
  Future<int?> getInt(String key);

  // ============================================================
  // Double Operations
  // ============================================================

  /// Store a double value.
  Future<bool> setDouble(String key, double value);

  /// Retrieve a double value.
  Future<double?> getDouble(String key);

  // ============================================================
  // Boolean Operations
  // ============================================================

  /// Store a boolean value.
  Future<bool> setBool(String key, bool value);

  /// Retrieve a boolean value.
  Future<bool?> getBool(String key);

  // ============================================================
  // List Operations
  // ============================================================

  /// Store a list of strings.
  Future<bool> setStringList(String key, List<String> value);

  /// Retrieve a list of strings.
  Future<List<String>?> getStringList(String key);

  // ============================================================
  // Object Operations (JSON Serialization)
  // ============================================================

  /// Store an object as JSON.
  ///
  /// The object must be serializable via [toJson].
  Future<bool> setObject<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T) toJson,
  );

  /// Retrieve an object from JSON.
  ///
  /// The object is deserialized via [fromJson].
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  );

  /// Store a list of objects as JSON.
  Future<bool> setObjectList<T>(
    String key,
    List<T> value,
    Map<String, dynamic> Function(T) toJson,
  );

  /// Retrieve a list of objects from JSON.
  Future<List<T>?> getObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  );

  // ============================================================
  // DateTime Operations
  // ============================================================

  /// Store a DateTime value (as ISO8601 string).
  Future<bool> setDateTime(String key, DateTime value) {
    return setString(key, value.toIso8601String());
  }

  /// Retrieve a DateTime value.
  Future<DateTime?> getDateTime(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  // ============================================================
  // Removal Operations
  // ============================================================

  /// Remove a value by key.
  Future<bool> remove(String key);

  /// Remove multiple values by keys.
  Future<void> removeAll(List<String> keys) async {
    for (final key in keys) {
      await remove(key);
    }
  }

  /// Clear all stored values.
  ///
  /// Use with caution!
  Future<bool> clear();

  // ============================================================
  // Utility Operations
  // ============================================================

  /// Check if a key exists.
  Future<bool> containsKey(String key);

  /// Get all stored keys.
  Future<Set<String>> getKeys();

  /// Get all keys matching a prefix.
  Future<Set<String>> getKeysWithPrefix(String prefix) async {
    final allKeys = await getKeys();
    return allKeys.where((key) => key.startsWith(prefix)).toSet();
  }

  /// Remove all keys matching a prefix.
  Future<void> removeWithPrefix(String prefix) async {
    final keys = await getKeysWithPrefix(prefix);
    await removeAll(keys.toList());
  }
}

/// Mixin providing JSON serialization helpers.
mixin StorageJsonMixin on StorageService {
  /// Encode an object to JSON string.
  String encodeObject<T>(T value, Map<String, dynamic> Function(T) toJson) {
    return jsonEncode(toJson(value));
  }

  /// Decode a JSON string to object.
  T? decodeObject<T>(
    String? jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Encode a list of objects to JSON string.
  String encodeObjectList<T>(
    List<T> value,
    Map<String, dynamic> Function(T) toJson,
  ) {
    return jsonEncode(value.map(toJson).toList());
  }

  /// Decode a JSON string to list of objects.
  List<T>? decodeObjectList<T>(
    String? jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (jsonString == null) return null;
    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }
}

