/// Storage module for Kiro Core.
///
/// Provides local data persistence with:
/// - [PrefStorage] - SharedPreferences for non-sensitive data
/// - [SecureStorage] - Encrypted storage for sensitive data
/// - [CacheManager] - Multi-level caching with expiration
/// - [StorageKeys] - Centralized key constants
///
/// ## Quick Start
///
/// ```dart
/// // Initialize storage
/// final prefStorage = PrefStorage();
/// final secureStorage = SecureStorage();
/// await prefStorage.init();
/// await secureStorage.init();
///
/// // Store preferences
/// await prefStorage.setString(StorageKeys.themeMode, 'dark');
/// await prefStorage.setBool(StorageKeys.onboardingComplete, true);
///
/// // Store sensitive data
/// await secureStorage.setString(StorageKeys.accessToken, token);
///
/// // Use cache
/// final cache = CacheManager(diskStorage: prefStorage);
/// await cache.set('user', user, toJson: (u) => u.toJson());
/// ```
///
/// ## Choosing Storage Type
///
/// | Data Type | Storage | Example |
/// |-----------|---------|---------|
/// | Preferences | PrefStorage | Theme, locale |
/// | App state | PrefStorage | Onboarding status |
/// | Auth tokens | SecureStorage | JWT tokens |
/// | Passwords | SecureStorage | PIN codes |
/// | API cache | CacheManager | User profile |
library;

export 'cache_manager.dart';
export 'pref_storage.dart';
export 'secure_storage.dart';
export 'storage_keys.dart';
export 'storage_service.dart';

