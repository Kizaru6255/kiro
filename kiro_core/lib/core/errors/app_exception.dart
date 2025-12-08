/// Core exception classes for Kiro applications.
///
/// All exceptions in Kiro extend [KiroException] which provides
/// a consistent interface for error handling across the application.
library;

/// Base exception class for all Kiro errors.
///
/// This provides a consistent interface for error handling with:
/// - [message]: Human-readable error description
/// - [code]: Optional error code for programmatic handling
/// - [originalError]: The underlying error that caused this exception
/// - [stackTrace]: Stack trace for debugging
///
/// Example:
/// ```dart
/// try {
///   await someOperation();
/// } on KiroException catch (e) {
///   logger.error('Operation failed: ${e.message}', code: e.code);
/// }
/// ```
abstract class KiroException implements Exception {
  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  /// The original error that caused this exception
  final Object? originalError;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  const KiroException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('KiroException');
    if (code != null) {
      buffer.write(' [$code]');
    }
    buffer.write(': $message');
    return buffer.toString();
  }
}

/// Network-related exceptions.
///
/// Thrown when network operations fail due to connectivity issues,
/// server errors, or API problems.
class NetworkException extends KiroException {
  /// HTTP status code if available
  final int? statusCode;

  /// Response body if available
  final dynamic responseData;

  const NetworkException({
    required super.message,
    super.code,
    this.statusCode,
    this.responseData,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('NetworkException');
    if (statusCode != null) {
      buffer.write(' ($statusCode)');
    }
    if (code != null) {
      buffer.write(' [$code]');
    }
    buffer.write(': $message');
    return buffer.toString();
  }
}

/// Thrown when there is no internet connection.
class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'No internet connection available',
    super.code = 'NO_INTERNET',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a network request times out.
class TimeoutException extends NetworkException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.code = 'TIMEOUT',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when the server returns an error response (5xx).
class ServerException extends NetworkException {
  const ServerException({
    required super.message,
    super.code = 'SERVER_ERROR',
    super.statusCode,
    super.responseData,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when authentication fails or token is invalid.
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    super.message = 'Authentication required',
    super.code = 'UNAUTHORIZED',
    super.statusCode = 401,
    super.responseData,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when the user doesn't have permission for an operation.
class ForbiddenException extends NetworkException {
  const ForbiddenException({
    super.message = 'Access denied',
    super.code = 'FORBIDDEN',
    super.statusCode = 403,
    super.responseData,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a requested resource is not found.
class NotFoundException extends NetworkException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code = 'NOT_FOUND',
    super.statusCode = 404,
    super.responseData,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when rate limit is exceeded.
class RateLimitException extends NetworkException {
  /// Time until rate limit resets (in seconds)
  final int? retryAfter;

  const RateLimitException({
    super.message = 'Rate limit exceeded',
    super.code = 'RATE_LIMITED',
    super.statusCode = 429,
    this.retryAfter,
    super.responseData,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when request validation fails (400).
class BadRequestException extends NetworkException {
  /// Validation errors if available
  final Map<String, List<String>>? validationErrors;

  const BadRequestException({
    required super.message,
    super.code = 'BAD_REQUEST',
    super.statusCode = 400,
    this.validationErrors,
    super.responseData,
    super.originalError,
    super.stackTrace,
  });
}

/// Storage-related exceptions.
///
/// Thrown when local storage operations fail.
class StorageException extends KiroException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when storage is not initialized.
class StorageNotInitializedException extends StorageException {
  const StorageNotInitializedException({
    super.message = 'Storage not initialized. Call init() first.',
    super.code = 'STORAGE_NOT_INITIALIZED',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when reading from storage fails.
class StorageReadException extends StorageException {
  final String key;

  const StorageReadException({
    required this.key,
    super.message = 'Failed to read from storage',
    super.code = 'STORAGE_READ_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when writing to storage fails.
class StorageWriteException extends StorageException {
  final String key;

  const StorageWriteException({
    required this.key,
    super.message = 'Failed to write to storage',
    super.code = 'STORAGE_WRITE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when data deserialization fails.
class DeserializationException extends StorageException {
  final String key;
  final Type expectedType;

  const DeserializationException({
    required this.key,
    required this.expectedType,
    super.message = 'Failed to deserialize data',
    super.code = 'DESERIALIZATION_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Permission-related exceptions.
class PermissionException extends KiroException {
  const PermissionException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a permission is denied.
class PermissionDeniedException extends PermissionException {
  final String permission;

  const PermissionDeniedException({
    required this.permission,
    super.message = 'Permission denied',
    super.code = 'PERMISSION_DENIED',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a permission is permanently denied.
class PermissionPermanentlyDeniedException extends PermissionException {
  final String permission;

  const PermissionPermanentlyDeniedException({
    required this.permission,
    super.message = 'Permission permanently denied. Please enable in settings.',
    super.code = 'PERMISSION_PERMANENTLY_DENIED',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a required service is disabled.
class ServiceDisabledException extends PermissionException {
  final String service;

  const ServiceDisabledException({
    required this.service,
    super.message = 'Required service is disabled',
    super.code = 'SERVICE_DISABLED',
    super.originalError,
    super.stackTrace,
  });
}

/// Validation-related exceptions.
class ValidationException extends KiroException {
  /// Field-specific validation errors
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });
}

/// Cache-related exceptions.
class CacheException extends KiroException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when cache entry is expired.
class CacheExpiredException extends CacheException {
  final String key;

  const CacheExpiredException({
    required this.key,
    super.message = 'Cache entry has expired',
    super.code = 'CACHE_EXPIRED',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when cache entry is not found.
class CacheNotFoundException extends CacheException {
  final String key;

  const CacheNotFoundException({
    required this.key,
    super.message = 'Cache entry not found',
    super.code = 'CACHE_NOT_FOUND',
    super.originalError,
    super.stackTrace,
  });
}

/// Platform-related exceptions.
class PlatformException extends KiroException {
  const PlatformException({
    required super.message,
    super.code = 'PLATFORM_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when platform is not supported.
class UnsupportedPlatformException extends PlatformException {
  final String platform;
  final String feature;

  const UnsupportedPlatformException({
    required this.platform,
    required this.feature,
    super.message = 'Feature not supported on this platform',
    super.code = 'UNSUPPORTED_PLATFORM',
    super.originalError,
    super.stackTrace,
  });
}

/// Configuration-related exceptions.
class ConfigurationException extends KiroException {
  const ConfigurationException({
    required super.message,
    super.code = 'CONFIGURATION_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a feature is not configured.
class FeatureNotConfiguredException extends ConfigurationException {
  final String feature;

  const FeatureNotConfiguredException({
    required this.feature,
    super.message = 'Feature is not configured',
    super.code = 'FEATURE_NOT_CONFIGURED',
    super.originalError,
    super.stackTrace,
  });
}

