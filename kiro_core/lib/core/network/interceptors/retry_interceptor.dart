/// Retry interceptor for Dio.
///
/// Implements automatic retry with exponential backoff.
library;

import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

/// Interceptor that automatically retries failed requests.
///
/// Features:
/// - Configurable retry count
/// - Exponential backoff delay
/// - Configurable retryable status codes
/// - Skip retry for specific paths
///
/// Example:
/// ```dart
/// final retryInterceptor = RetryInterceptor(
///   maxRetries: 3,
///   retryDelays: [1.seconds, 2.seconds, 4.seconds],
///   retryableStatuses: {408, 500, 502, 503, 504},
/// );
///
/// dio.interceptors.add(retryInterceptor);
/// ```
class RetryInterceptor extends Interceptor {
  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Delays between retries.
  ///
  /// If fewer delays than retries, the last delay is used.
  final List<Duration> retryDelays;

  /// HTTP status codes that should trigger a retry.
  final Set<int> retryableStatuses;

  /// Paths that should not be retried.
  final List<String> excludedPaths;

  /// Whether to retry on timeout errors.
  final bool retryOnTimeout;

  /// Whether to retry on connection errors.
  final bool retryOnConnectionError;

  /// Dio instance for retries.
  final Dio? _dio;

  /// Create a retry interceptor.
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
    this.retryableStatuses = const {408, 500, 502, 503, 504},
    this.excludedPaths = const [],
    this.retryOnTimeout = true,
    this.retryOnConnectionError = true,
    Dio? dio,
  }) : _dio = dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    
    // Get current retry count
    final retryCount = options.extra['retryCount'] as int? ?? 0;

    // Check if we should retry
    if (!_shouldRetry(err, retryCount)) {
      return handler.next(err);
    }

    // Calculate delay
    final delay = _getDelay(retryCount);

    // Wait before retrying
    await Future.delayed(delay);

    // Update retry count
    options.extra['retryCount'] = retryCount + 1;

    try {
      // Retry the request
      final dio = _dio ?? Dio();
      final response = await dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      // If retry also failed, continue with the new error
      handler.next(e);
    }
  }

  /// Check if the request should be retried.
  bool _shouldRetry(DioException err, int currentRetry) {
    // Max retries exceeded
    if (currentRetry >= maxRetries) {
      return false;
    }

    // Check if path is excluded
    if (_isExcluded(err.requestOptions.path)) {
      return false;
    }

    // Check error type
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return retryOnTimeout;

      case DioExceptionType.connectionError:
        return retryOnConnectionError;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        return statusCode != null && retryableStatuses.contains(statusCode);

      default:
        return false;
    }
  }

  /// Get the delay for a retry attempt.
  Duration _getDelay(int retryCount) {
    if (retryDelays.isEmpty) {
      // Default exponential backoff
      return Duration(seconds: pow(2, retryCount).toInt());
    }

    if (retryCount < retryDelays.length) {
      return retryDelays[retryCount];
    }

    // Use last delay for additional retries
    return retryDelays.last;
  }

  /// Check if a path is excluded from retry.
  bool _isExcluded(String path) {
    return excludedPaths.any((excluded) {
      if (excluded.endsWith('*')) {
        return path.startsWith(excluded.substring(0, excluded.length - 1));
      }
      return path == excluded;
    });
  }
}

/// Extension for easy duration creation.
extension IntDurationExtension on int {
  Duration get seconds => Duration(seconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
}

