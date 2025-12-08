/// Authentication interceptor for Dio.
///
/// Handles token injection and automatic refresh.
library;

import 'dart:async';

import 'package:dio/dio.dart';

import '../../storage/storage.dart';

/// Callback for refreshing the access token.
typedef TokenRefreshCallback = Future<String?> Function(String? refreshToken);

/// Callback called when token refresh fails.
typedef OnRefreshFailedCallback = void Function();

/// Interceptor that handles authentication tokens.
///
/// Features:
/// - Injects access token into request headers
/// - Automatically refreshes expired tokens
/// - Handles concurrent requests during refresh
/// - Notifies when refresh fails (e.g., for logout)
///
/// Example:
/// ```dart
/// final authInterceptor = AuthInterceptor(
///   storage: secureStorage,
///   onRefreshToken: (refreshToken) async {
///     final response = await authApi.refresh(refreshToken);
///     return response.accessToken;
///   },
///   onRefreshFailed: () {
///     // Navigate to login
///     authBloc.add(LogoutEvent());
///   },
/// );
///
/// dio.interceptors.add(authInterceptor);
/// ```
class AuthInterceptor extends Interceptor {
  /// Secure storage for tokens.
  final SecureStorage _storage;

  /// Callback to refresh the access token.
  final TokenRefreshCallback? _onRefreshToken;

  /// Callback when refresh fails (e.g., for logout).
  final OnRefreshFailedCallback? _onRefreshFailed;

  /// Endpoints that don't require authentication.
  final List<String> _excludedPaths;

  /// Header name for the token.
  final String _headerName;

  /// Token prefix (e.g., 'Bearer').
  final String _tokenPrefix;

  /// Whether a refresh is in progress.
  bool _isRefreshing = false;

  /// Completer for pending requests during refresh.
  Completer<String?>? _refreshCompleter;

  /// Create an auth interceptor.
  ///
  /// [storage] - Secure storage for accessing tokens.
  /// [onRefreshToken] - Callback to refresh expired token.
  /// [onRefreshFailed] - Called when refresh fails.
  /// [excludedPaths] - Paths that don't need auth (e.g., login).
  /// [headerName] - Header name (default: 'Authorization').
  /// [tokenPrefix] - Prefix before token (default: 'Bearer').
  AuthInterceptor({
    required SecureStorage storage,
    TokenRefreshCallback? onRefreshToken,
    OnRefreshFailedCallback? onRefreshFailed,
    List<String> excludedPaths = const [],
    String headerName = 'Authorization',
    String tokenPrefix = 'Bearer',
  })  : _storage = storage,
        _onRefreshToken = onRefreshToken,
        _onRefreshFailed = onRefreshFailed,
        _excludedPaths = excludedPaths,
        _headerName = headerName,
        _tokenPrefix = tokenPrefix;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip excluded paths
    if (_shouldExclude(options.path)) {
      return handler.next(options);
    }

    // Get access token
    final token = await _storage.getString(StorageKeys.accessToken);

    if (token != null) {
      options.headers[_headerName] = '$_tokenPrefix $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only handle 401 errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip if this is already a retry or excluded path
    if (err.requestOptions.extra['isRetry'] == true ||
        _shouldExclude(err.requestOptions.path)) {
      return handler.next(err);
    }

    // Try to refresh token
    if (_onRefreshToken != null) {
      try {
        final newToken = await _refreshToken();

        if (newToken != null) {
          // Retry the original request
          final response = await _retryRequest(err.requestOptions, newToken);
          return handler.resolve(response);
        }
      } catch (_) {
        // Refresh failed
      }
    }

    // Refresh failed or not configured
    _onRefreshFailed?.call();
    handler.next(err);
  }

  /// Refresh the access token.
  ///
  /// Handles concurrent refresh requests by using a completer.
  Future<String?> _refreshToken() async {
    // If already refreshing, wait for the result
    if (_isRefreshing) {
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _storage.getString(StorageKeys.refreshToken);
      final newToken = await _onRefreshToken!(refreshToken);

      if (newToken != null) {
        // Store the new token
        await _storage.setString(StorageKeys.accessToken, newToken);
      }

      _refreshCompleter?.complete(newToken);
      return newToken;
    } catch (e) {
      _refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Retry a failed request with a new token.
  Future<Response<dynamic>> _retryRequest(
    RequestOptions options,
    String token,
  ) async {
    final dio = Dio();

    options.headers[_headerName] = '$_tokenPrefix $token';
    options.extra['isRetry'] = true;

    return dio.fetch(options);
  }

  /// Check if a path should be excluded from auth.
  bool _shouldExclude(String path) {
    return _excludedPaths.any((excluded) {
      if (excluded.endsWith('*')) {
        return path.startsWith(excluded.substring(0, excluded.length - 1));
      }
      return path == excluded || path.startsWith('$excluded/');
    });
  }

  /// Clear stored tokens.
  ///
  /// Call this on logout.
  Future<void> clearTokens() async {
    await _storage.remove(StorageKeys.accessToken);
    await _storage.remove(StorageKeys.refreshToken);
    await _storage.remove(StorageKeys.tokenExpiry);
  }

  /// Check if we have a valid token.
  Future<bool> hasValidToken() async {
    final token = await _storage.getString(StorageKeys.accessToken);
    if (token == null) return false;

    final expiryString = await _storage.getString(StorageKeys.tokenExpiry);
    if (expiryString != null) {
      final expiry = DateTime.tryParse(expiryString);
      if (expiry != null && expiry.isBefore(DateTime.now())) {
        return false;
      }
    }

    return true;
  }
}

