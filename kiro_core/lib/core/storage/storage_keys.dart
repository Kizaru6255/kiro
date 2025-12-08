/// Centralized storage key constants.
///
/// Use these constants instead of hardcoded strings to prevent
/// typos and enable easy refactoring.
///
/// Example:
/// ```dart
/// await storage.setString(StorageKeys.accessToken, token);
/// final token = await storage.getString(StorageKeys.accessToken);
/// ```
library;

/// Storage keys for all persisted data in Kiro applications.
abstract class StorageKeys {
  StorageKeys._();

  // ============================================================
  // Prefixes
  // ============================================================

  /// Prefix for all Kiro storage keys.
  static const String prefix = 'kiro';

  /// Prefix for auth-related keys.
  static const String authPrefix = '$prefix.auth';

  /// Prefix for user preference keys.
  static const String prefsPrefix = '$prefix.prefs';

  /// Prefix for cache keys.
  static const String cachePrefix = '$prefix.cache';

  /// Prefix for session keys.
  static const String sessionPrefix = '$prefix.session';

  /// Prefix for feature flag keys.
  static const String featuresPrefix = '$prefix.features';

  // ============================================================
  // Authentication Keys (Secure Storage)
  // ============================================================

  /// JWT access token.
  static const String accessToken = '$authPrefix.access_token';

  /// JWT refresh token.
  static const String refreshToken = '$authPrefix.refresh_token';

  /// Token expiry timestamp (ISO8601).
  static const String tokenExpiry = '$authPrefix.token_expiry';

  /// Current user ID.
  static const String userId = '$authPrefix.user_id';

  /// Biometric authentication enabled.
  static const String biometricEnabled = '$authPrefix.biometric_enabled';

  /// Device fingerprint for security.
  static const String deviceFingerprint = '$authPrefix.device_fingerprint';

  /// PIN code hash (for PIN login).
  static const String pinHash = '$authPrefix.pin_hash';

  // ============================================================
  // User Preferences (Regular Storage)
  // ============================================================

  /// Theme mode: 'light', 'dark', or 'system'.
  static const String themeMode = '$prefsPrefix.theme_mode';

  /// Current locale code (e.g., 'en', 'hi').
  static const String locale = '$prefsPrefix.locale';

  /// Whether onboarding has been completed.
  static const String onboardingComplete = '$prefsPrefix.onboarding_complete';

  /// Whether notifications are enabled.
  static const String notificationsEnabled = '$prefsPrefix.notifications_enabled';

  /// Push notification token (FCM/APNs).
  static const String pushToken = '$prefsPrefix.push_token';

  /// Whether haptic feedback is enabled.
  static const String hapticEnabled = '$prefsPrefix.haptic_enabled';

  /// Font size preference.
  static const String fontSize = '$prefsPrefix.font_size';

  /// Whether to show in-app reviews.
  static const String showReviews = '$prefsPrefix.show_reviews';

  /// Last review prompt date.
  static const String lastReviewPrompt = '$prefsPrefix.last_review_prompt';

  /// App launch count (for review prompts).
  static const String launchCount = '$prefsPrefix.launch_count';

  // ============================================================
  // Session Keys
  // ============================================================

  /// Current session ID.
  static const String sessionId = '$sessionPrefix.id';

  /// Last active timestamp.
  static const String lastActiveTime = '$sessionPrefix.last_active';

  /// Session start time.
  static const String sessionStartTime = '$sessionPrefix.start_time';

  /// Whether user is currently active.
  static const String isActive = '$sessionPrefix.is_active';

  // ============================================================
  // Feature Flags
  // ============================================================

  /// Feature flags JSON.
  static const String featureFlags = '$featuresPrefix.flags';

  /// Feature flags last updated timestamp.
  static const String featureFlagsUpdated = '$featuresPrefix.updated_at';

  // ============================================================
  // App State
  // ============================================================

  /// App version on last launch (for migration).
  static const String lastAppVersion = '$prefix.last_app_version';

  /// First install timestamp.
  static const String installTime = '$prefix.install_time';

  /// Last update timestamp.
  static const String lastUpdateTime = '$prefix.last_update_time';

  // ============================================================
  // Cache Keys
  // ============================================================

  /// Current user profile cache.
  static const String userProfileCache = '$cachePrefix.user_profile';

  /// App configuration cache.
  static const String appConfigCache = '$cachePrefix.app_config';

  // ============================================================
  // Helpers
  // ============================================================

  /// Create a cache key for a specific resource.
  static String cacheKey(String resource, [String? id]) {
    if (id != null) {
      return '$cachePrefix.$resource.$id';
    }
    return '$cachePrefix.$resource';
  }

  /// Create a user-specific key.
  static String userKey(String userId, String key) {
    return '$prefix.user.$userId.$key';
  }

  /// Check if a key is a cache key.
  static bool isCacheKey(String key) => key.startsWith(cachePrefix);

  /// Check if a key is an auth key.
  static bool isAuthKey(String key) => key.startsWith(authPrefix);

  /// Check if a key is a preference key.
  static bool isPrefKey(String key) => key.startsWith(prefsPrefix);

  /// Get all auth-related keys.
  static List<String> get allAuthKeys => [
        accessToken,
        refreshToken,
        tokenExpiry,
        userId,
        biometricEnabled,
        deviceFingerprint,
        pinHash,
      ];

  /// Get all session-related keys.
  static List<String> get allSessionKeys => [
        sessionId,
        lastActiveTime,
        sessionStartTime,
        isActive,
      ];
}

