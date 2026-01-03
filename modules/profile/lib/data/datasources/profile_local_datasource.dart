/// Profile local data source.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for profile (caching).
abstract class ProfileLocalDataSource {
  /// Cache profile.
  Future<void> cacheProfile(Map<String, dynamic> profile);

  /// Get cached profile.
  Future<Map<String, dynamic>?> getCachedProfile();

  /// Clear cache.
  Future<void> clearCache();
}

/// Implementation of profile local data source.
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences _prefs;
  static const String _cacheKey = 'profile_cache';

  ProfileLocalDataSourceImpl({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  @override
  Future<void> cacheProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(_cacheKey, jsonEncode(profile));
  }

  @override
  Future<Map<String, dynamic>?> getCachedProfile() async {
    final cached = _prefs.getString(_cacheKey);
    if (cached == null) return null;

    return jsonDecode(cached) as Map<String, dynamic>;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
