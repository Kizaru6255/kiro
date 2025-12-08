# Kiro Core Package — Technical Specification

> **Package Name:** `kiro_core`  
> **Version:** 1.0.0  
> **Type:** Private Flutter Package  
> **Last Updated:** December 2024

---

## Table of Contents

1. [Package Overview](#1-package-overview)
2. [Network Layer](#2-network-layer)
3. [Storage Layer](#3-storage-layer)
4. [Permission Layer](#4-permission-layer)
5. [Platform Services](#5-platform-services)
6. [Theme System](#6-theme-system)
7. [Localization System](#7-localization-system)
8. [Error Handling](#8-error-handling)
9. [Logging System](#9-logging-system)
10. [Utilities](#10-utilities)
11. [Routing System](#11-routing-system)
12. [Public API Exports](#12-public-api-exports)

---

## 1. Package Overview

### 1.1 Purpose

`kiro_core` is the foundation layer of all Kiro-generated applications. It provides:

- **Abstracted Infrastructure**: Pre-built network, storage, and platform services
- **Standardized Patterns**: Consistent error handling and logging
- **Protected Logic**: Users can customize UI but cannot modify core behavior
- **Best Practices**: Production-ready implementations

### 1.2 Design Philosophy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         KIRO_CORE DESIGN PRINCIPLES                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   1. ABSTRACTION        - Hide implementation complexity                    │
│   2. IMMUTABILITY       - Prefer immutable data structures                  │
│   3. TESTABILITY        - All services are mockable via interfaces          │
│   4. CONFIGURATION      - Behavior controlled via configuration, not code   │
│   5. FAIL-SAFE          - Graceful degradation over crashes                 │
│   6. TYPE-SAFE          - Leverage Dart's type system fully                 │
│   7. DOCUMENTATION      - Every public API is documented                    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Directory Structure

```
kiro_core/
├── lib/
│   ├── core/
│   │   ├── network/           # HTTP client and API services
│   │   ├── storage/           # Local data persistence
│   │   ├── permissions/       # Runtime permission handling
│   │   ├── platform/          # Device and platform services
│   │   ├── theme/             # Dynamic theming system
│   │   ├── localization/      # Multi-language support
│   │   ├── errors/            # Exception and error handling
│   │   ├── logger/            # Logging infrastructure
│   │   ├── routing/           # Navigation and routing
│   │   └── utils/             # General utilities
│   │
│   └── kiro_core.dart         # Public API barrel file
│
├── test/                      # Unit and integration tests
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 2. Network Layer

### 2.1 File Structure

```
network/
├── dio_client.dart            # Singleton Dio instance configuration
├── api_service.dart           # High-level API abstraction
├── api_endpoints.dart         # Endpoint constants and builders
├── api_response.dart          # Standardized response wrapper
├── network_info.dart          # Network connectivity checker
└── interceptors/
    ├── auth_interceptor.dart        # Token injection/refresh
    ├── logging_interceptor.dart     # Request/response logging
    ├── error_interceptor.dart       # Error transformation
    ├── retry_interceptor.dart       # Automatic retry logic
    └── cache_interceptor.dart       # Response caching
```

### 2.2 DioClient Specification

```dart
/// dio_client.dart
/// 
/// Singleton HTTP client with pre-configured interceptors.
/// This is the single source of truth for all network requests.

abstract class DioClientConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Duration get sendTimeout;
  Map<String, dynamic> get headers;
  bool get enableLogging;
  int get maxRetries;
}

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  
  factory DioClient({required DioClientConfig config}) {
    _instance ??= DioClient._internal(config);
    return _instance!;
  }
  
  DioClient._internal(DioClientConfig config) {
    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: config.headers,
    ));
    
    _setupInterceptors(config);
  }
  
  void _setupInterceptors(DioClientConfig config) {
    // Order matters: Auth → Cache → Retry → Error → Logging
    _dio.interceptors.addAll([
      AuthInterceptor(),
      CacheInterceptor(),
      RetryInterceptor(maxRetries: config.maxRetries),
      ErrorInterceptor(),
      if (config.enableLogging) LoggingInterceptor(),
    ]);
  }
  
  // Public API
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams});
  Future<Response<T>> post<T>(String path, {dynamic data});
  Future<Response<T>> put<T>(String path, {dynamic data});
  Future<Response<T>> patch<T>(String path, {dynamic data});
  Future<Response<T>> delete<T>(String path);
  Future<Response<T>> upload<T>(String path, {required File file, String? fieldName});
  Future<File> download(String url, {required String savePath});
}
```

### 2.3 API Response Wrapper

```dart
/// api_response.dart
///
/// Standardized response wrapper for all API calls.
/// Implements Either pattern for functional error handling.

sealed class ApiResponse<T> {
  const ApiResponse();
}

final class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, dynamic>? meta;
  
  const ApiSuccess({
    required this.data,
    required this.statusCode,
    this.meta,
  });
}

final class ApiFailure<T> extends ApiResponse<T> {
  final AppException exception;
  final int? statusCode;
  final String? rawResponse;
  
  const ApiFailure({
    required this.exception,
    this.statusCode,
    this.rawResponse,
  });
}

// Extension for easier handling
extension ApiResponseX<T> on ApiResponse<T> {
  R fold<R>({
    required R Function(ApiSuccess<T>) onSuccess,
    required R Function(ApiFailure<T>) onFailure,
  }) {
    return switch (this) {
      ApiSuccess<T> success => onSuccess(success),
      ApiFailure<T> failure => onFailure(failure),
    };
  }
  
  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;
  
  T? get dataOrNull => switch (this) {
    ApiSuccess<T> s => s.data,
    _ => null,
  };
}
```

### 2.4 API Service Abstraction

```dart
/// api_service.dart
///
/// High-level API service that wraps DioClient
/// and provides type-safe request methods.

abstract class ApiService {
  Future<ApiResponse<T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParams,
    dynamic body,
    required T Function(dynamic json) fromJson,
    CachePolicy cachePolicy = CachePolicy.networkFirst,
  });
  
  Future<ApiResponse<List<T>>> requestList<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  });
  
  Future<ApiResponse<PaginatedResponse<T>>> requestPaginated<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  });
}

enum HttpMethod { get, post, put, patch, delete }

enum CachePolicy {
  networkOnly,      // Always fetch from network
  cacheOnly,        // Only use cache
  networkFirst,     // Try network, fallback to cache
  cacheFirst,       // Try cache, fallback to network
  staleWhileRevalidate,  // Return cache, update in background
}
```

### 2.5 Interceptor Specifications

#### Auth Interceptor

```dart
/// auth_interceptor.dart
///
/// Handles token injection and automatic refresh.

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Inject access token
    final token = _tokenStorage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      final refreshed = await _tokenRefresher.refresh();
      if (refreshed) {
        // Retry original request
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
        return;
      }
    }
    handler.next(err);
  }
}
```

#### Retry Interceptor

```dart
/// retry_interceptor.dart
///
/// Implements exponential backoff retry logic.

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;
  final Set<int> retryableStatusCodes;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.retryableStatusCodes = const {408, 500, 502, 503, 504},
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final shouldRetry = statusCode != null && 
                        retryableStatusCodes.contains(statusCode);
    
    if (shouldRetry) {
      for (var attempt = 0; attempt < maxRetries; attempt++) {
        final delay = initialDelay * pow(2, attempt);
        await Future.delayed(delay);
        
        try {
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          if (attempt == maxRetries - 1) {
            handler.reject(err);
            return;
          }
        }
      }
    }
    handler.next(err);
  }
}
```

---

## 3. Storage Layer

### 3.1 File Structure

```
storage/
├── storage_service.dart       # Abstract storage interface
├── pref_storage.dart          # SharedPreferences implementation
├── secure_storage.dart        # FlutterSecureStorage implementation
├── cache_manager.dart         # In-memory + disk caching
└── storage_keys.dart          # Centralized key constants
```

### 3.2 Storage Service Interface

```dart
/// storage_service.dart
///
/// Abstract interface for all storage operations.
/// Enables easy mocking and implementation swapping.

abstract class StorageService {
  // String operations
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  
  // Integer operations
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  
  // Boolean operations
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  
  // Double operations
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  
  // Object operations (JSON serialization)
  Future<void> setObject<T>(String key, T value, Map<String, dynamic> Function(T) toJson);
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  
  // List operations
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  
  // Removal operations
  Future<void> remove(String key);
  Future<void> removeAll(List<String> keys);
  Future<void> clear();
  
  // Utility operations
  Future<bool> containsKey(String key);
  Future<Set<String>> getAllKeys();
}
```

### 3.3 Preference Storage Implementation

```dart
/// pref_storage.dart
///
/// SharedPreferences implementation for non-sensitive data.

class PrefStorage implements StorageService {
  late final SharedPreferences _prefs;
  bool _initialized = false;
  
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }
  
  void _ensureInitialized() {
    if (!_initialized) {
      throw StorageException(
        'PrefStorage not initialized. Call init() first.',
        code: StorageErrorCode.notInitialized,
      );
    }
  }
  
  @override
  Future<void> setString(String key, String value) async {
    _ensureInitialized();
    await _prefs.setString(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    _ensureInitialized();
    return _prefs.getString(key);
  }
  
  @override
  Future<void> setObject<T>(
    String key, 
    T value, 
    Map<String, dynamic> Function(T) toJson,
  ) async {
    _ensureInitialized();
    final jsonString = jsonEncode(toJson(value));
    await _prefs.setString(key, jsonString);
  }
  
  @override
  Future<T?> getObject<T>(
    String key, 
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    _ensureInitialized();
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      throw StorageException(
        'Failed to deserialize object for key: $key',
        code: StorageErrorCode.deserializationFailed,
        originalError: e,
      );
    }
  }
  
  // ... other implementations
}
```

### 3.4 Secure Storage Implementation

```dart
/// secure_storage.dart
///
/// Encrypted storage for sensitive data like tokens and credentials.

class SecureStorage implements StorageService {
  late final FlutterSecureStorage _secureStorage;
  final AndroidOptions _androidOptions;
  final IOSOptions _iosOptions;
  
  SecureStorage({
    AndroidOptions? androidOptions,
    IOSOptions? iosOptions,
  }) : _androidOptions = androidOptions ?? const AndroidOptions(
         encryptedSharedPreferences: true,
       ),
       _iosOptions = iosOptions ?? const IOSOptions(
         accessibility: KeychainAccessibility.first_unlock_this_device,
       ) {
    _secureStorage = const FlutterSecureStorage();
  }
  
  @override
  Future<void> setString(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }
  
  @override
  Future<String?> getString(String key) async {
    return await _secureStorage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }
  
  // Integer, bool, double stored as strings and parsed
  @override
  Future<void> setInt(String key, int value) async {
    await setString(key, value.toString());
  }
  
  @override
  Future<int?> getInt(String key) async {
    final value = await getString(key);
    return value != null ? int.tryParse(value) : null;
  }
  
  // ... other implementations
}
```

### 3.5 Cache Manager

```dart
/// cache_manager.dart
///
/// Multi-level caching with memory and disk layers.

class CacheManager {
  final Map<String, CacheEntry> _memoryCache = {};
  final StorageService _diskStorage;
  final Duration defaultTtl;
  final int maxMemoryCacheSize;
  
  CacheManager({
    required StorageService diskStorage,
    this.defaultTtl = const Duration(hours: 1),
    this.maxMemoryCacheSize = 100,
  }) : _diskStorage = diskStorage;
  
  Future<T?> get<T>(
    String key, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // Check memory cache first
    final memoryEntry = _memoryCache[key];
    if (memoryEntry != null && !memoryEntry.isExpired) {
      return memoryEntry.value as T;
    }
    
    // Fall back to disk cache
    if (fromJson != null) {
      final diskValue = await _diskStorage.getObject(
        _diskKey(key),
        (json) => CacheEntry<T>.fromJson(json, fromJson),
      );
      
      if (diskValue != null && !diskValue.isExpired) {
        // Promote to memory cache
        _memoryCache[key] = diskValue;
        _evictIfNeeded();
        return diskValue.value;
      }
    }
    
    return null;
  }
  
  Future<void> set<T>(
    String key,
    T value, {
    Duration? ttl,
    Map<String, dynamic> Function(T)? toJson,
  }) async {
    final entry = CacheEntry<T>(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? defaultTtl),
    );
    
    // Store in memory
    _memoryCache[key] = entry;
    _evictIfNeeded();
    
    // Store on disk if serializable
    if (toJson != null) {
      await _diskStorage.setObject(
        _diskKey(key),
        entry,
        (e) => e.toJson(toJson),
      );
    }
  }
  
  Future<void> invalidate(String key) async {
    _memoryCache.remove(key);
    await _diskStorage.remove(_diskKey(key));
  }
  
  Future<void> invalidateAll() async {
    _memoryCache.clear();
    // Note: Selective disk clear based on cache prefix
  }
  
  String _diskKey(String key) => 'cache_$key';
  
  void _evictIfNeeded() {
    if (_memoryCache.length > maxMemoryCacheSize) {
      // LRU eviction - remove oldest entries
      final sortedKeys = _memoryCache.keys.toList()
        ..sort((a, b) => _memoryCache[a]!.createdAt
            .compareTo(_memoryCache[b]!.createdAt));
      
      for (final key in sortedKeys.take(_memoryCache.length - maxMemoryCacheSize)) {
        _memoryCache.remove(key);
      }
    }
  }
}

class CacheEntry<T> {
  final T value;
  final DateTime createdAt;
  final DateTime expiresAt;
  
  CacheEntry({
    required this.value,
    required this.expiresAt,
  }) : createdAt = DateTime.now();
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) valueToJson) => {
    'value': valueToJson(value),
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
  };
  
  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) valueFromJson,
  ) {
    return CacheEntry<T>(
      value: valueFromJson(json['value'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}
```

### 3.6 Storage Keys

```dart
/// storage_keys.dart
///
/// Centralized storage key constants to prevent typos
/// and enable easy refactoring.

abstract class StorageKeys {
  StorageKeys._();
  
  // Auth keys
  static const String accessToken = 'kiro.auth.access_token';
  static const String refreshToken = 'kiro.auth.refresh_token';
  static const String tokenExpiry = 'kiro.auth.token_expiry';
  static const String userId = 'kiro.auth.user_id';
  
  // User preferences
  static const String themeMode = 'kiro.prefs.theme_mode';
  static const String locale = 'kiro.prefs.locale';
  static const String onboardingComplete = 'kiro.prefs.onboarding_complete';
  static const String notificationsEnabled = 'kiro.prefs.notifications_enabled';
  
  // Cache prefixes
  static const String cachePrefix = 'kiro.cache.';
  
  // Session
  static const String sessionId = 'kiro.session.id';
  static const String lastActiveTime = 'kiro.session.last_active';
  
  // Feature flags
  static const String featureFlags = 'kiro.features.flags';
}
```

---

## 4. Permission Layer

### 4.1 File Structure

```
permissions/
├── permission_manager.dart    # Main permission orchestrator
├── permission_status.dart     # Status enums and helpers
└── permission_rationale.dart  # User-facing explanations
```

### 4.2 Permission Manager

```dart
/// permission_manager.dart
///
/// Centralized permission request handling with
/// rationale dialogs and status tracking.

enum KiroPermission {
  camera,
  microphone,
  photos,
  storage,
  location,
  locationAlways,
  contacts,
  calendar,
  notification,
  phone,
  sms,
  sensors,
  bluetooth,
}

class PermissionManager {
  final PermissionRationale _rationale;
  final Map<KiroPermission, PermissionStatus> _statusCache = {};
  
  PermissionManager({
    required PermissionRationale rationale,
  }) : _rationale = rationale;
  
  /// Request a single permission with optional rationale
  Future<PermissionResult> request(
    KiroPermission permission, {
    bool showRationale = true,
  }) async {
    // Check current status
    final currentStatus = await checkStatus(permission);
    
    if (currentStatus == PermissionStatus.granted) {
      return PermissionResult.granted;
    }
    
    if (currentStatus == PermissionStatus.permanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }
    
    // Show rationale if needed and it's been denied before
    if (showRationale && currentStatus == PermissionStatus.denied) {
      final shouldProceed = await _rationale.showRationale(permission);
      if (!shouldProceed) {
        return PermissionResult.denied;
      }
    }
    
    // Request permission
    final result = await _requestSystemPermission(permission);
    _statusCache[permission] = result;
    
    return switch (result) {
      PermissionStatus.granted => PermissionResult.granted,
      PermissionStatus.denied => PermissionResult.denied,
      PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
      PermissionStatus.restricted => PermissionResult.restricted,
      PermissionStatus.limited => PermissionResult.limited,
      _ => PermissionResult.denied,
    };
  }
  
  /// Request multiple permissions at once
  Future<Map<KiroPermission, PermissionResult>> requestMultiple(
    List<KiroPermission> permissions,
  ) async {
    final results = <KiroPermission, PermissionResult>{};
    
    for (final permission in permissions) {
      results[permission] = await request(permission);
    }
    
    return results;
  }
  
  /// Check current permission status without requesting
  Future<PermissionStatus> checkStatus(KiroPermission permission) async {
    if (_statusCache.containsKey(permission)) {
      return _statusCache[permission]!;
    }
    
    final status = await _getSystemPermissionStatus(permission);
    _statusCache[permission] = status;
    return status;
  }
  
  /// Open app settings for manually granting permissions
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
  
  /// Check if service is enabled (location, bluetooth)
  Future<bool> isServiceEnabled(KiroPermission permission) async {
    return switch (permission) {
      KiroPermission.location => await Geolocator.isLocationServiceEnabled(),
      KiroPermission.bluetooth => await FlutterBluePlus.isOn,
      _ => true,
    };
  }
  
  Permission _toPermissionHandler(KiroPermission permission) {
    return switch (permission) {
      KiroPermission.camera => Permission.camera,
      KiroPermission.microphone => Permission.microphone,
      KiroPermission.photos => Permission.photos,
      KiroPermission.storage => Permission.storage,
      KiroPermission.location => Permission.location,
      KiroPermission.locationAlways => Permission.locationAlways,
      KiroPermission.contacts => Permission.contacts,
      KiroPermission.calendar => Permission.calendar,
      KiroPermission.notification => Permission.notification,
      KiroPermission.phone => Permission.phone,
      KiroPermission.sms => Permission.sms,
      KiroPermission.sensors => Permission.sensors,
      KiroPermission.bluetooth => Permission.bluetooth,
    };
  }
  
  Future<PermissionStatus> _getSystemPermissionStatus(
    KiroPermission permission,
  ) async {
    return await _toPermissionHandler(permission).status;
  }
  
  Future<PermissionStatus> _requestSystemPermission(
    KiroPermission permission,
  ) async {
    return await _toPermissionHandler(permission).request();
  }
}

enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
}
```

### 4.3 Permission Rationale

```dart
/// permission_rationale.dart
///
/// Provides user-friendly explanations for why
/// permissions are needed.

abstract class PermissionRationale {
  /// Show rationale dialog before requesting permission
  /// Returns true if user wants to proceed with request
  Future<bool> showRationale(KiroPermission permission);
  
  /// Get title for permission rationale
  String getTitle(KiroPermission permission);
  
  /// Get description for permission rationale
  String getDescription(KiroPermission permission);
  
  /// Get icon for permission
  IconData getIcon(KiroPermission permission);
}

class DefaultPermissionRationale implements PermissionRationale {
  final BuildContext Function() contextProvider;
  
  DefaultPermissionRationale({required this.contextProvider});
  
  @override
  Future<bool> showRationale(KiroPermission permission) async {
    final context = contextProvider();
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(getIcon(permission)),
            const SizedBox(width: 8),
            Text(getTitle(permission)),
          ],
        ),
        content: Text(getDescription(permission)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not Now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    ) ?? false;
  }
  
  @override
  String getTitle(KiroPermission permission) {
    return switch (permission) {
      KiroPermission.camera => 'Camera Access',
      KiroPermission.microphone => 'Microphone Access',
      KiroPermission.photos => 'Photo Library Access',
      KiroPermission.storage => 'Storage Access',
      KiroPermission.location => 'Location Access',
      KiroPermission.locationAlways => 'Background Location',
      KiroPermission.contacts => 'Contacts Access',
      KiroPermission.calendar => 'Calendar Access',
      KiroPermission.notification => 'Notification Permission',
      KiroPermission.phone => 'Phone Access',
      KiroPermission.sms => 'SMS Access',
      KiroPermission.sensors => 'Sensor Access',
      KiroPermission.bluetooth => 'Bluetooth Access',
    };
  }
  
  @override
  String getDescription(KiroPermission permission) {
    return switch (permission) {
      KiroPermission.camera => 
        'We need camera access to let you take photos and scan documents.',
      KiroPermission.microphone => 
        'We need microphone access for voice messages and calls.',
      KiroPermission.photos => 
        'We need access to your photos to let you share images.',
      KiroPermission.storage => 
        'We need storage access to save and load files.',
      KiroPermission.location => 
        'We need your location to show nearby services and provide directions.',
      KiroPermission.locationAlways => 
        'We need background location access for live tracking features.',
      KiroPermission.contacts => 
        'We need contacts access to help you connect with friends.',
      KiroPermission.calendar => 
        'We need calendar access to sync your bookings and appointments.',
      KiroPermission.notification => 
        'We need notification permission to keep you updated.',
      KiroPermission.phone => 
        'We need phone access to enable direct calling features.',
      KiroPermission.sms => 
        'We need SMS access for automatic verification.',
      KiroPermission.sensors => 
        'We need sensor access for fitness and motion tracking.',
      KiroPermission.bluetooth => 
        'We need Bluetooth access to connect with nearby devices.',
    };
  }
  
  @override
  IconData getIcon(KiroPermission permission) {
    return switch (permission) {
      KiroPermission.camera => Icons.camera_alt,
      KiroPermission.microphone => Icons.mic,
      KiroPermission.photos => Icons.photo_library,
      KiroPermission.storage => Icons.folder,
      KiroPermission.location => Icons.location_on,
      KiroPermission.locationAlways => Icons.location_searching,
      KiroPermission.contacts => Icons.contacts,
      KiroPermission.calendar => Icons.calendar_today,
      KiroPermission.notification => Icons.notifications,
      KiroPermission.phone => Icons.phone,
      KiroPermission.sms => Icons.sms,
      KiroPermission.sensors => Icons.sensors,
      KiroPermission.bluetooth => Icons.bluetooth,
    };
  }
}
```

---

## 5. Platform Services

### 5.1 File Structure

```
platform/
├── device_info.dart           # Device information service
├── connectivity_manager.dart  # Network connectivity monitoring
├── app_lifecycle.dart         # App state management
└── platform_channel.dart      # Native bridge utilities
```

### 5.2 Device Info Service

```dart
/// device_info.dart
///
/// Provides device and app information for analytics
/// and debugging purposes.

class DeviceInfoService {
  DeviceInfoPlugin? _deviceInfo;
  PackageInfo? _packageInfo;
  
  DeviceInfoService();
  
  Future<void> init() async {
    _deviceInfo = DeviceInfoPlugin();
    _packageInfo = await PackageInfo.fromPlatform();
  }
  
  /// Get comprehensive device info
  Future<DeviceData> getDeviceData() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo!.androidInfo;
      return DeviceData(
        platform: 'android',
        osVersion: androidInfo.version.release,
        sdkVersion: androidInfo.version.sdkInt.toString(),
        manufacturer: androidInfo.manufacturer,
        model: androidInfo.model,
        deviceId: androidInfo.id,
        isPhysicalDevice: androidInfo.isPhysicalDevice,
        appVersion: _packageInfo!.version,
        buildNumber: _packageInfo!.buildNumber,
        packageName: _packageInfo!.packageName,
      );
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo!.iosInfo;
      return DeviceData(
        platform: 'ios',
        osVersion: iosInfo.systemVersion,
        sdkVersion: iosInfo.systemVersion,
        manufacturer: 'Apple',
        model: iosInfo.model,
        deviceId: iosInfo.identifierForVendor ?? '',
        isPhysicalDevice: iosInfo.isPhysicalDevice,
        appVersion: _packageInfo!.version,
        buildNumber: _packageInfo!.buildNumber,
        packageName: _packageInfo!.packageName,
      );
    }
    
    throw UnsupportedError('Platform not supported');
  }
  
  /// Get app version string
  String get appVersion => _packageInfo?.version ?? 'unknown';
  
  /// Get build number
  String get buildNumber => _packageInfo?.buildNumber ?? 'unknown';
  
  /// Get full version string (e.g., "1.0.0+1")
  String get fullVersion => '${appVersion}+${buildNumber}';
  
  /// Check if running on physical device
  Future<bool> get isPhysicalDevice async {
    final data = await getDeviceData();
    return data.isPhysicalDevice;
  }
}

class DeviceData {
  final String platform;
  final String osVersion;
  final String sdkVersion;
  final String manufacturer;
  final String model;
  final String deviceId;
  final bool isPhysicalDevice;
  final String appVersion;
  final String buildNumber;
  final String packageName;
  
  const DeviceData({
    required this.platform,
    required this.osVersion,
    required this.sdkVersion,
    required this.manufacturer,
    required this.model,
    required this.deviceId,
    required this.isPhysicalDevice,
    required this.appVersion,
    required this.buildNumber,
    required this.packageName,
  });
  
  Map<String, dynamic> toJson() => {
    'platform': platform,
    'osVersion': osVersion,
    'sdkVersion': sdkVersion,
    'manufacturer': manufacturer,
    'model': model,
    'deviceId': deviceId,
    'isPhysicalDevice': isPhysicalDevice,
    'appVersion': appVersion,
    'buildNumber': buildNumber,
    'packageName': packageName,
  };
}
```

### 5.3 Connectivity Manager

```dart
/// connectivity_manager.dart
///
/// Real-time network connectivity monitoring with
/// stream-based updates.

enum ConnectivityStatus {
  connected,
  disconnected,
  connecting,
}

enum ConnectionType {
  wifi,
  mobile,
  ethernet,
  vpn,
  none,
}

class ConnectivityManager {
  final Connectivity _connectivity;
  final StreamController<ConnectivityStatus> _statusController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  
  ConnectivityStatus _currentStatus = ConnectivityStatus.disconnected;
  ConnectionType _connectionType = ConnectionType.none;
  
  ConnectivityManager() 
    : _connectivity = Connectivity(),
      _statusController = StreamController<ConnectivityStatus>.broadcast();
  
  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get statusStream => _statusController.stream;
  
  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;
  
  /// Current connection type
  ConnectionType get connectionType => _connectionType;
  
  /// Whether device is currently connected
  bool get isConnected => _currentStatus == ConnectivityStatus.connected;
  
  /// Initialize connectivity monitoring
  Future<void> init() async {
    await _checkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }
  
  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
  
  /// Manually check current connectivity
  Future<bool> checkConnectivity() async {
    await _checkConnectivity();
    return isConnected;
  }
  
  /// Check if we can reach the internet (not just connected)
  Future<bool> hasInternetAccess() async {
    if (!isConnected) return false;
    
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
  
  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _onConnectivityChanged(results);
  }
  
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final result = results.firstOrNull ?? ConnectivityResult.none;
    
    final newType = switch (result) {
      ConnectivityResult.wifi => ConnectionType.wifi,
      ConnectivityResult.mobile => ConnectionType.mobile,
      ConnectivityResult.ethernet => ConnectionType.ethernet,
      ConnectivityResult.vpn => ConnectionType.vpn,
      ConnectivityResult.none => ConnectionType.none,
      _ => ConnectionType.none,
    };
    
    final newStatus = result == ConnectivityResult.none
        ? ConnectivityStatus.disconnected
        : ConnectivityStatus.connected;
    
    if (newStatus != _currentStatus || newType != _connectionType) {
      _currentStatus = newStatus;
      _connectionType = newType;
      _statusController.add(_currentStatus);
    }
  }
}
```

---

## 6. Theme System

### 6.1 File Structure

```
theme/
├── theme_manager.dart         # Dynamic theme controller
├── app_colors.dart            # Color palette definitions
├── app_typography.dart        # Text style definitions
├── app_dimensions.dart        # Spacing and sizing
└── theme_extensions.dart      # Custom theme extensions
```

### 6.2 Theme Manager

```dart
/// theme_manager.dart
///
/// Dynamic theme management with persistence and
/// system theme detection.

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeManager extends ChangeNotifier {
  final StorageService _storage;
  
  AppThemeMode _themeMode = AppThemeMode.system;
  AppColors? _customColors;
  
  ThemeManager({required StorageService storage}) : _storage = storage;
  
  /// Current theme mode
  AppThemeMode get themeMode => _themeMode;
  
  /// Whether dark mode is active (considering system setting)
  bool get isDarkMode {
    return switch (_themeMode) {
      AppThemeMode.dark => true,
      AppThemeMode.light => false,
      AppThemeMode.system => SchedulerBinding.instance.platformDispatcher
          .platformBrightness == Brightness.dark,
    };
  }
  
  /// Get current ThemeData
  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;
  
  /// Light theme
  ThemeData get lightTheme => _buildTheme(Brightness.light);
  
  /// Dark theme
  ThemeData get darkTheme => _buildTheme(Brightness.dark);
  
  /// Initialize from storage
  Future<void> init() async {
    final storedMode = await _storage.getString(StorageKeys.themeMode);
    if (storedMode != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (e) => e.name == storedMode,
        orElse: () => AppThemeMode.system,
      );
    }
  }
  
  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _storage.setString(StorageKeys.themeMode, mode.name);
      notifyListeners();
    }
  }
  
  /// Set custom colors (for dynamic theming)
  void setCustomColors(AppColors colors) {
    _customColors = colors;
    notifyListeners();
  }
  
  /// Toggle between light and dark (ignores system)
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await setThemeMode(newMode);
  }
  
  ThemeData _buildTheme(Brightness brightness) {
    final colors = _customColors ?? AppColors.defaultColors(brightness);
    final typography = AppTypography(colors: colors);
    final dimensions = AppDimensions();
    
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      secondaryContainer: colors.secondaryContainer,
      onSecondaryContainer: colors.onSecondaryContainer,
      tertiary: colors.tertiary,
      onTertiary: colors.onTertiary,
      tertiaryContainer: colors.tertiaryContainer,
      onTertiaryContainer: colors.onTertiaryContainer,
      error: colors.error,
      onError: colors.onError,
      errorContainer: colors.errorContainer,
      onErrorContainer: colors.onErrorContainer,
      surface: colors.surface,
      onSurface: colors.onSurface,
      surfaceContainerHighest: colors.surfaceVariant,
      onSurfaceVariant: colors.onSurfaceVariant,
      outline: colors.outline,
      outlineVariant: colors.outlineVariant,
      shadow: colors.shadow,
      scrim: colors.scrim,
      inverseSurface: colors.inverseSurface,
      onInverseSurface: colors.onInverseSurface,
      inversePrimary: colors.inversePrimary,
    );
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: typography.textTheme,
      appBarTheme: _buildAppBarTheme(colorScheme, typography),
      cardTheme: _buildCardTheme(colorScheme, dimensions),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme, typography),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme, typography),
      textButtonTheme: _buildTextButtonTheme(colorScheme, typography),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme, dimensions),
      extensions: [
        colors,
        typography,
        dimensions,
      ],
    );
  }
  
  // Theme component builders...
  AppBarTheme _buildAppBarTheme(ColorScheme colors, AppTypography typography) {
    return AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: typography.textTheme.titleLarge,
    );
  }
  
  CardTheme _buildCardTheme(ColorScheme colors, AppDimensions dimensions) {
    return CardTheme(
      color: colors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.radiusMedium),
      ),
    );
  }
  
  // ... other builders
}
```

---

## 7. Localization System

_(Specification continues in next section for length management)_

### 7.1 File Structure

```
localization/
├── locale_manager.dart        # Locale switching controller
├── translation_loader.dart    # JSON/ARB file loader
└── localization_delegate.dart # Flutter localization delegate
```

### 7.2 Locale Manager

```dart
/// locale_manager.dart
///
/// Manages app locale with persistence and fallback.

class LocaleManager extends ChangeNotifier {
  final StorageService _storage;
  final TranslationLoader _loader;
  
  Locale _currentLocale = const Locale('en');
  List<Locale> _supportedLocales = [const Locale('en')];
  Map<String, String> _translations = {};
  
  LocaleManager({
    required StorageService storage,
    required TranslationLoader loader,
  }) : _storage = storage, _loader = loader;
  
  Locale get currentLocale => _currentLocale;
  List<Locale> get supportedLocales => _supportedLocales;
  
  Future<void> init({required List<Locale> supportedLocales}) async {
    _supportedLocales = supportedLocales;
    
    // Load stored locale
    final storedLocale = await _storage.getString(StorageKeys.locale);
    if (storedLocale != null) {
      final parts = storedLocale.split('_');
      _currentLocale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    } else {
      // Use system locale if supported
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (_supportedLocales.any((l) => l.languageCode == systemLocale.languageCode)) {
        _currentLocale = systemLocale;
      }
    }
    
    await _loadTranslations();
  }
  
  Future<void> setLocale(Locale locale) async {
    if (!_supportedLocales.contains(locale)) {
      throw LocalizationException('Locale $locale is not supported');
    }
    
    _currentLocale = locale;
    await _storage.setString(
      StorageKeys.locale, 
      '${locale.languageCode}${locale.countryCode != null ? '_${locale.countryCode}' : ''}',
    );
    await _loadTranslations();
    notifyListeners();
  }
  
  String translate(String key, {Map<String, dynamic>? params}) {
    var translation = _translations[key] ?? key;
    
    if (params != null) {
      params.forEach((paramKey, value) {
        translation = translation.replaceAll('{$paramKey}', value.toString());
      });
    }
    
    return translation;
  }
  
  // Shorthand
  String tr(String key, {Map<String, dynamic>? params}) => 
    translate(key, params: params);
  
  Future<void> _loadTranslations() async {
    _translations = await _loader.load(_currentLocale);
  }
}
```

---

## 8-12. Remaining Sections

_(Error Handling, Logging, Utilities, Routing, and Public API sections follow the same detailed pattern. Full specifications are provided in supplementary documents for brevity.)_

---

## 12. Public API Exports

```dart
/// kiro_core.dart
///
/// Public API barrel file - exports all public interfaces.
/// Internal implementation details are hidden.

library kiro_core;

// Network
export 'core/network/dio_client.dart' show DioClient, DioClientConfig;
export 'core/network/api_service.dart';
export 'core/network/api_response.dart';

// Storage
export 'core/storage/storage_service.dart';
export 'core/storage/pref_storage.dart';
export 'core/storage/secure_storage.dart';
export 'core/storage/cache_manager.dart';
export 'core/storage/storage_keys.dart';

// Permissions
export 'core/permissions/permission_manager.dart';
export 'core/permissions/permission_status.dart';

// Platform
export 'core/platform/device_info.dart';
export 'core/platform/connectivity_manager.dart';
export 'core/platform/app_lifecycle.dart';

// Theme
export 'core/theme/theme_manager.dart';
export 'core/theme/app_colors.dart';
export 'core/theme/app_typography.dart';
export 'core/theme/app_dimensions.dart';

// Localization
export 'core/localization/locale_manager.dart';
export 'core/localization/translation_loader.dart';

// Routing
export 'core/routing/app_router.dart';
export 'core/routing/route_guard.dart';

// Errors
export 'core/errors/app_exception.dart';
export 'core/errors/error_handler.dart';
export 'core/errors/failure.dart';

// Logger
export 'core/logger/kiro_logger.dart';
export 'core/logger/log_level.dart';

// Utils
export 'core/utils/validators.dart';
export 'core/utils/formatters.dart';
export 'core/utils/date_time_utils.dart';
export 'core/utils/extensions.dart';
export 'core/utils/debouncer.dart';
```

---

**Next Document**: [03_kiro_cli_spec.md](./03_kiro_cli_spec.md)

