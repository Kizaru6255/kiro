/// Notification local data source.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for notifications (caching).
abstract class NotificationLocalDataSource {
  /// Cache notifications.
  Future<void> cacheNotifications(List<Map<String, dynamic>> notifications);

  /// Get cached notifications.
  Future<List<Map<String, dynamic>>?> getCachedNotifications();

  /// Clear cache.
  Future<void> clearCache();
}

/// Implementation of notification local data source.
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences _prefs;
  static const String _cacheKey = 'notifications_cache';

  NotificationLocalDataSourceImpl({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  @override
  Future<void> cacheNotifications(List<Map<String, dynamic>> notifications) async {
    final jsonList = notifications.map((n) => jsonEncode(n)).toList();
    await _prefs.setStringList(_cacheKey, jsonList);
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedNotifications() async {
    final cached = _prefs.getStringList(_cacheKey);
    if (cached == null) return null;

    return cached
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
