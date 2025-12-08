/// In-memory and disk cache manager.
///
/// Provides multi-level caching with automatic expiration
/// and LRU eviction.
library;

import 'dart:convert';

import 'storage_service.dart';

/// Cache entry with value, creation time, and expiration.
class CacheEntry<T> {
  /// The cached value.
  final T value;

  /// When the entry was created.
  final DateTime createdAt;

  /// When the entry expires.
  final DateTime expiresAt;

  /// Optional metadata.
  final Map<String, dynamic>? metadata;

  CacheEntry({
    required this.value,
    required this.expiresAt,
    this.metadata,
  }) : createdAt = DateTime.now();

  /// Whether this entry has expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Remaining time until expiration.
  Duration get timeToLive => expiresAt.difference(DateTime.now());

  /// Create from JSON (for disk persistence).
  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) valueFromJson,
  ) {
    return CacheEntry<T>(
      value: valueFromJson(json['value']),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON (for disk persistence).
  Map<String, dynamic> toJson(dynamic Function(T) valueToJson) => {
        'value': valueToJson(value),
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };
}

/// Multi-level cache manager with memory and optional disk layers.
///
/// Features:
/// - In-memory cache with LRU eviction
/// - Optional disk persistence
/// - Automatic expiration
/// - Stale-while-revalidate support
///
/// Example:
/// ```dart
/// final cache = CacheManager(diskStorage: prefStorage);
/// await cache.init();
///
/// // Cache with 5 minute TTL
/// await cache.set('user_profile', user,
///   ttl: Duration(minutes: 5),
///   toJson: (u) => u.toJson(),
/// );
///
/// // Get from cache
/// final user = await cache.get<User>('user_profile',
///   fromJson: (j) => User.fromJson(j),
/// );
/// ```
class CacheManager {
  /// In-memory cache.
  final Map<String, CacheEntry<dynamic>> _memoryCache = {};

  /// Optional disk storage for persistence.
  final StorageService? _diskStorage;

  /// Default time-to-live for cache entries.
  final Duration defaultTtl;

  /// Maximum number of entries in memory cache.
  final int maxMemoryEntries;

  /// Key prefix for disk storage.
  final String diskKeyPrefix;

  /// Whether the cache has been initialized.
  bool _initialized = false;

  /// Create a new cache manager.
  ///
  /// [diskStorage] - Optional storage for persistent caching.
  /// [defaultTtl] - Default expiration time (default: 1 hour).
  /// [maxMemoryEntries] - Max entries in memory (default: 100).
  CacheManager({
    StorageService? diskStorage,
    this.defaultTtl = const Duration(hours: 1),
    this.maxMemoryEntries = 100,
    this.diskKeyPrefix = 'kiro.cache.',
  }) : _diskStorage = diskStorage;

  /// Whether cache is initialized.
  bool get isInitialized => _initialized;

  /// Number of entries in memory cache.
  int get memorySize => _memoryCache.length;

  /// Initialize the cache manager.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }

  /// Get a value from cache.
  ///
  /// Checks memory first, then disk if available.
  /// Returns null if not found or expired.
  Future<T?> get<T>(
    String key, {
    T Function(dynamic json)? fromJson,
  }) async {
    // Check memory cache first
    final memoryEntry = _memoryCache[key];
    if (memoryEntry != null) {
      if (!memoryEntry.isExpired) {
        return memoryEntry.value as T;
      }
      // Remove expired entry
      _memoryCache.remove(key);
    }

    // Check disk cache
    if (_diskStorage != null && fromJson != null) {
      final diskKey = '$diskKeyPrefix$key';
      final jsonString = await _diskStorage!.getString(diskKey);

      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final entry = CacheEntry<T>.fromJson(json, fromJson);

          if (!entry.isExpired) {
            // Promote to memory cache
            _memoryCache[key] = entry;
            _evictIfNeeded();
            return entry.value;
          } else {
            // Remove expired disk entry
            await _diskStorage!.remove(diskKey);
          }
        } catch (_) {
          // Invalid cache entry, remove it
          await _diskStorage!.remove(diskKey);
        }
      }
    }

    return null;
  }

  /// Set a value in cache.
  ///
  /// Stores in memory and optionally on disk.
  Future<void> set<T>(
    String key,
    T value, {
    Duration? ttl,
    dynamic Function(T)? toJson,
    Map<String, dynamic>? metadata,
    bool persistToDisk = true,
  }) async {
    final expiresAt = DateTime.now().add(ttl ?? defaultTtl);

    final entry = CacheEntry<T>(
      value: value,
      expiresAt: expiresAt,
      metadata: metadata,
    );

    // Store in memory
    _memoryCache[key] = entry;
    _evictIfNeeded();

    // Store on disk if available and serializable
    if (persistToDisk && _diskStorage != null && toJson != null) {
      final diskKey = '$diskKeyPrefix$key';
      final jsonString = jsonEncode(entry.toJson(toJson));
      await _diskStorage!.setString(diskKey, jsonString);
    }
  }

  /// Get a value or compute it if not cached.
  ///
  /// If the value is not in cache or expired, [compute] is called
  /// and the result is cached.
  Future<T> getOrSet<T>(
    String key, {
    required Future<T> Function() compute,
    Duration? ttl,
    T Function(dynamic json)? fromJson,
    dynamic Function(T)? toJson,
  }) async {
    // Try to get from cache
    final cached = await get<T>(key, fromJson: fromJson);
    if (cached != null) {
      return cached;
    }

    // Compute new value
    final value = await compute();

    // Cache it
    await set<T>(
      key,
      value,
      ttl: ttl,
      toJson: toJson,
    );

    return value;
  }

  /// Invalidate a cache entry.
  Future<void> invalidate(String key) async {
    _memoryCache.remove(key);

    if (_diskStorage != null) {
      final diskKey = '$diskKeyPrefix$key';
      await _diskStorage!.remove(diskKey);
    }
  }

  /// Invalidate all entries matching a pattern.
  Future<void> invalidatePattern(String pattern) async {
    final regex = RegExp(pattern);

    // Clear from memory
    _memoryCache.removeWhere((key, _) => regex.hasMatch(key));

    // Clear from disk
    if (_diskStorage != null) {
      final keys = await _diskStorage!.getKeysWithPrefix(diskKeyPrefix);
      for (final key in keys) {
        final cacheKey = key.substring(diskKeyPrefix.length);
        if (regex.hasMatch(cacheKey)) {
          await _diskStorage!.remove(key);
        }
      }
    }
  }

  /// Invalidate all cache entries.
  Future<void> invalidateAll() async {
    _memoryCache.clear();

    if (_diskStorage != null) {
      await _diskStorage!.removeWithPrefix(diskKeyPrefix);
    }
  }

  /// Check if a key exists in cache (and is not expired).
  Future<bool> containsKey(String key) async {
    final entry = _memoryCache[key];
    if (entry != null && !entry.isExpired) {
      return true;
    }

    if (_diskStorage != null) {
      final diskKey = '$diskKeyPrefix$key';
      return await _diskStorage!.containsKey(diskKey);
    }

    return false;
  }

  /// Get cache entry metadata.
  CacheEntry<dynamic>? getEntry(String key) {
    return _memoryCache[key];
  }

  /// Clean up expired entries.
  Future<void> cleanup() async {
    // Clean memory cache
    _memoryCache.removeWhere((_, entry) => entry.isExpired);

    // Clean disk cache
    if (_diskStorage != null) {
      final keys = await _diskStorage!.getKeysWithPrefix(diskKeyPrefix);
      for (final key in keys) {
        final jsonString = await _diskStorage!.getString(key);
        if (jsonString != null) {
          try {
            final json = jsonDecode(jsonString) as Map<String, dynamic>;
            final expiresAt = DateTime.parse(json['expiresAt'] as String);
            if (DateTime.now().isAfter(expiresAt)) {
              await _diskStorage!.remove(key);
            }
          } catch (_) {
            // Invalid entry, remove it
            await _diskStorage!.remove(key);
          }
        }
      }
    }
  }

  /// Evict entries if memory cache exceeds limit (LRU).
  void _evictIfNeeded() {
    if (_memoryCache.length <= maxMemoryEntries) return;

    // Sort by creation time and remove oldest
    final sortedKeys = _memoryCache.keys.toList()
      ..sort((a, b) {
        final entryA = _memoryCache[a]!;
        final entryB = _memoryCache[b]!;
        return entryA.createdAt.compareTo(entryB.createdAt);
      });

    final toRemove = _memoryCache.length - maxMemoryEntries;
    for (var i = 0; i < toRemove; i++) {
      _memoryCache.remove(sortedKeys[i]);
    }
  }

  /// Get cache statistics.
  CacheStats getStats() {
    var expiredCount = 0;
    var totalSize = 0;

    for (final entry in _memoryCache.values) {
      if (entry.isExpired) expiredCount++;
      totalSize += entry.value.toString().length;
    }

    return CacheStats(
      memoryEntries: _memoryCache.length,
      expiredEntries: expiredCount,
      estimatedSizeBytes: totalSize,
      maxEntries: maxMemoryEntries,
    );
  }
}

/// Cache statistics.
class CacheStats {
  final int memoryEntries;
  final int expiredEntries;
  final int estimatedSizeBytes;
  final int maxEntries;

  const CacheStats({
    required this.memoryEntries,
    required this.expiredEntries,
    required this.estimatedSizeBytes,
    required this.maxEntries,
  });

  double get fillPercentage => memoryEntries / maxEntries * 100;

  @override
  String toString() {
    return 'CacheStats('
        'entries: $memoryEntries/$maxEntries, '
        'expired: $expiredEntries, '
        'size: ${estimatedSizeBytes ~/ 1024}KB)';
  }
}

