/// Booking local data source.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for booking (caching).
abstract class BookingLocalDataSource {
  /// Cache bookings.
  Future<void> cacheBookings(List<Map<String, dynamic>> bookings);

  /// Get cached bookings.
  Future<List<Map<String, dynamic>>?> getCachedBookings();

  /// Clear cache.
  Future<void> clearCache();
}

/// Implementation of booking local data source.
class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  final SharedPreferences _prefs;
  static const String _cacheKey = 'bookings_cache';

  BookingLocalDataSourceImpl({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  @override
  Future<void> cacheBookings(List<Map<String, dynamic>> bookings) async {
    final jsonList = bookings.map((b) => jsonEncode(b)).toList();
    await _prefs.setStringList(_cacheKey, jsonList);
  }

  @override
  Future<List<Map<String, dynamic>>?> getCachedBookings() async {
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
