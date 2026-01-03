/// Core error types for modules.
/// 
/// Note: These types should be imported from the app's core/errors/errors.dart
/// This file is a placeholder that will be replaced during app generation.
library;

// This will be replaced with import from app's core during generation
// For now, we define a basic Result and Failure type

/// Result type for handling success/failure scenarios.
sealed class Result<T> {
  const Result();
  
  /// Create a success result.
  const factory Result.success(T data) = Success<T>;
  
  /// Create a failure result.
  const factory Result.failure(Failure failure) = FailureResult<T>;
  
  /// Fold the result into a value.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      FailureResult<T>(:final failure) => onFailure(failure),
    };
  }
  
  /// Check if result is success.
  bool get isSuccess => this is Success<T>;
  
  /// Check if result is failure.
  bool get isFailure => this is FailureResult<T>;
}

/// Success result.
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Failure result.
class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}

/// Base class for all failures.
sealed class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  /// Network failure.
  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  /// Validation failure.
  const factory Failure.validation({
    required String message,
    Map<String, dynamic>? errors,
  }) = ValidationFailure;

  /// Authentication failure.
  const factory Failure.auth({
    required String message,
    String? code,
  }) = AuthFailure;

  /// Server failure.
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  /// Unknown failure.
  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;

  @override
  String toString() => 'Failure: $message';
}

/// Network failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
  });
}

/// Validation failure.
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure({
    required super.message,
    this.errors,
  });
}

/// Authentication failure.
class AuthFailure extends Failure {
  final String? code;
  const AuthFailure({
    required super.message,
    this.code,
  });
}

/// Server failure.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

/// Unknown failure.
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
  });
}
