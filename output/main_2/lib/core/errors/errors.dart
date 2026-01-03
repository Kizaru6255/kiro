/// Core error handling types.
/// 
/// Provides Result<T> and Failure types for error handling.
library;

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
  
  /// Get data if success, null otherwise.
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    FailureResult<T>() => null,
  };
  
  /// Get failure if failure, null otherwise.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    FailureResult<T>(:final failure) => failure,
  };
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

/// Failure type representing different error scenarios.
sealed class Failure {
  final String message;
  final Object? error;
  
  const Failure({
    required this.message,
    this.error,
  });
  
  /// Network failure.
  const factory Failure.network({
    required String message,
    int? statusCode,
    Object? error,
  }) = NetworkFailure;
  
  /// Validation failure.
  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
    Object? error,
  }) = ValidationFailure;
  
  /// Server failure.
  const factory Failure.server({
    required String message,
    int? statusCode,
    Object? error,
  }) = ServerFailure;
  
  /// Authentication failure.
  const factory Failure.authentication({
    required String message,
    Object? error,
  }) = AuthenticationFailure;
  
  /// Authorization failure.
  const factory Failure.authorization({
    required String message,
    Object? error,
  }) = AuthorizationFailure;
  
  /// Not found failure.
  const factory Failure.notFound({
    required String message,
    Object? error,
  }) = NotFoundFailure;
  
  /// Unknown failure.
  const factory Failure.unknown({
    required String message,
    Object? error,
  }) = UnknownFailure;
}

/// Network failure.
class NetworkFailure extends Failure {
  final int? statusCode;
  
  const NetworkFailure({
    required super.message,
    this.statusCode,
    super.error,
  });
}

/// Validation failure.
class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  
  const ValidationFailure({
    required super.message,
    this.errors,
    super.error,
  });
}

/// Server failure.
class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required super.message,
    this.statusCode,
    super.error,
  });
}

/// Authentication failure.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.error,
  });
}

/// Authorization failure.
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.error,
  });
}

/// Not found failure.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.error,
  });
}

/// Unknown failure.
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.error,
  });
}
