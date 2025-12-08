/// Failure class for functional error handling.
///
/// Use [Failure] when you want to represent errors as values
/// rather than throwing exceptions. This is useful for:
/// - Cleaner error handling with Result types
/// - Avoiding try-catch boilerplate
/// - Type-safe error handling
library;

import 'package:equatable/equatable.dart';

import 'app_exception.dart';

/// Represents a failure in an operation.
///
/// This is an alternative to throwing exceptions, allowing errors
/// to be treated as values that can be passed around and handled
/// explicitly.
///
/// Example:
/// ```dart
/// Future<Result<User, Failure>> getUser(String id) async {
///   try {
///     final user = await api.fetchUser(id);
///     return Success(user);
///   } on NetworkException catch (e) {
///     return Failure.fromException(e);
///   }
/// }
/// ```
class Failure extends Equatable {
  /// Error message
  final String message;

  /// Error code for programmatic handling
  final String? code;

  /// The type of failure
  final FailureType type;

  /// Additional details about the failure
  final Map<String, dynamic>? details;

  /// The original exception if available
  final KiroException? exception;

  const Failure({
    required this.message,
    this.code,
    this.type = FailureType.unknown,
    this.details,
    this.exception,
  });

  /// Create a Failure from a KiroException.
  factory Failure.fromException(KiroException exception) {
    return Failure(
      message: exception.message,
      code: exception.code,
      type: _typeFromException(exception),
      exception: exception,
    );
  }

  /// Create a network failure.
  factory Failure.network({
    required String message,
    String? code,
    int? statusCode,
    Map<String, dynamic>? details,
  }) {
    return Failure(
      message: message,
      code: code,
      type: FailureType.network,
      details: {
        if (statusCode != null) 'statusCode': statusCode,
        ...?details,
      },
    );
  }

  /// Create a storage failure.
  factory Failure.storage({
    required String message,
    String? code,
    String? key,
    Map<String, dynamic>? details,
  }) {
    return Failure(
      message: message,
      code: code,
      type: FailureType.storage,
      details: {
        if (key != null) 'key': key,
        ...?details,
      },
    );
  }

  /// Create a validation failure.
  factory Failure.validation({
    required String message,
    Map<String, List<String>>? fieldErrors,
  }) {
    return Failure(
      message: message,
      code: 'VALIDATION_ERROR',
      type: FailureType.validation,
      details: {
        if (fieldErrors != null) 'fieldErrors': fieldErrors,
      },
    );
  }

  /// Create a permission failure.
  factory Failure.permission({
    required String message,
    required String permission,
    bool isPermanent = false,
  }) {
    return Failure(
      message: message,
      code: isPermanent ? 'PERMISSION_PERMANENTLY_DENIED' : 'PERMISSION_DENIED',
      type: FailureType.permission,
      details: {
        'permission': permission,
        'isPermanent': isPermanent,
      },
    );
  }

  /// Create a cache failure.
  factory Failure.cache({
    required String message,
    String? key,
  }) {
    return Failure(
      message: message,
      code: 'CACHE_ERROR',
      type: FailureType.cache,
      details: {
        if (key != null) 'key': key,
      },
    );
  }

  /// Create an unknown failure.
  factory Failure.unknown({
    String message = 'An unexpected error occurred',
    Object? error,
  }) {
    return Failure(
      message: message,
      code: 'UNKNOWN_ERROR',
      type: FailureType.unknown,
      details: {
        if (error != null) 'error': error.toString(),
      },
    );
  }

  static FailureType _typeFromException(KiroException exception) {
    return switch (exception) {
      NetworkException() => FailureType.network,
      StorageException() => FailureType.storage,
      PermissionException() => FailureType.permission,
      ValidationException() => FailureType.validation,
      CacheException() => FailureType.cache,
      PlatformException() => FailureType.platform,
      ConfigurationException() => FailureType.configuration,
      _ => FailureType.unknown,
    };
  }

  /// Whether this is a network-related failure.
  bool get isNetwork => type == FailureType.network;

  /// Whether this is a storage-related failure.
  bool get isStorage => type == FailureType.storage;

  /// Whether this is a permission-related failure.
  bool get isPermission => type == FailureType.permission;

  /// Whether this is a validation failure.
  bool get isValidation => type == FailureType.validation;

  /// Get validation field errors if this is a validation failure.
  Map<String, List<String>>? get fieldErrors {
    if (type != FailureType.validation) return null;
    final errors = details?['fieldErrors'];
    if (errors is Map<String, List<String>>) return errors;
    return null;
  }

  @override
  List<Object?> get props => [message, code, type, details];

  @override
  String toString() {
    return 'Failure(type: ${type.name}, code: $code, message: $message)';
  }
}

/// Types of failures that can occur.
enum FailureType {
  /// Network-related failures (API, connectivity)
  network,

  /// Local storage failures
  storage,

  /// Permission-related failures
  permission,

  /// Input validation failures
  validation,

  /// Cache-related failures
  cache,

  /// Platform-specific failures
  platform,

  /// Configuration failures
  configuration,

  /// Unknown/unexpected failures
  unknown,
}

/// Extension to convert exceptions to failures.
extension ExceptionToFailure on KiroException {
  /// Convert this exception to a Failure.
  Failure toFailure() => Failure.fromException(this);
}

