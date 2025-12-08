/// Result type for functional error handling.
///
/// Use [Result] to represent operations that can either succeed
/// with a value or fail with a [Failure].
library;

import 'failure.dart';

/// Represents the result of an operation that can either
/// succeed with a value of type [T] or fail with a [Failure].
///
/// This is an alternative to throwing exceptions, providing:
/// - Explicit error handling
/// - Type-safe error values
/// - Cleaner control flow
///
/// Example:
/// ```dart
/// Future<Result<User>> getUser(String id) async {
///   try {
///     final user = await api.fetchUser(id);
///     return Result.success(user);
///   } on NetworkException catch (e) {
///     return Result.failure(Failure.fromException(e));
///   }
/// }
///
/// // Usage
/// final result = await getUser('123');
/// result.fold(
///   onSuccess: (user) => print('Hello, ${user.name}!'),
///   onFailure: (failure) => print('Error: ${failure.message}'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Create a successful result.
  const factory Result.success(T value) = Success<T>;

  /// Create a failed result.
  const factory Result.failure(Failure failure) = Fail<T>;

  /// Whether this result is a success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure.
  bool get isFailure => this is Fail<T>;

  /// Get the value if success, null otherwise.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Fail<T>() => null,
      };

  /// Get the failure if failed, null otherwise.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Fail<T>(:final failure) => failure,
      };

  /// Get the value or throw if failure.
  T get valueOrThrow => switch (this) {
        Success<T>(:final value) => value,
        Fail<T>(:final failure) =>
          throw failure.exception ?? Exception(failure.message),
      };

  /// Handle both success and failure cases.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Fail<T>(:final failure) => onFailure(failure),
    };
  }

  /// Transform the success value.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Result.success(transform(value)),
      Fail<T>(:final failure) => Result.failure(failure),
    };
  }

  /// Transform the success value with a function that returns a Result.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => transform(value),
      Fail<T>(:final failure) => Result.failure(failure),
    };
  }

  /// Transform the failure.
  Result<T> mapFailure(Failure Function(Failure failure) transform) {
    return switch (this) {
      Success<T>() => this,
      Fail<T>(:final failure) => Result.failure(transform(failure)),
    };
  }

  /// Get the value or a default.
  T getOrElse(T Function() orElse) {
    return switch (this) {
      Success<T>(:final value) => value,
      Fail<T>() => orElse(),
    };
  }

  /// Get the value or a default value.
  T getOrDefault(T defaultValue) {
    return switch (this) {
      Success<T>(:final value) => value,
      Fail<T>() => defaultValue,
    };
  }

  /// Execute a side effect on success.
  Result<T> onSuccess(void Function(T value) action) {
    if (this case Success<T>(:final value)) {
      action(value);
    }
    return this;
  }

  /// Execute a side effect on failure.
  Result<T> onFailure(void Function(Failure failure) action) {
    if (this case Fail<T>(:final failure)) {
      action(failure);
    }
    return this;
  }

  /// Recover from a failure with a new value.
  Result<T> recover(T Function(Failure failure) recovery) {
    return switch (this) {
      Success<T>() => this,
      Fail<T>(:final failure) => Result.success(recovery(failure)),
    };
  }

  /// Recover from a failure with a new Result.
  Result<T> recoverWith(Result<T> Function(Failure failure) recovery) {
    return switch (this) {
      Success<T>() => this,
      Fail<T>(:final failure) => recovery(failure),
    };
  }
}

/// Represents a successful result.
final class Success<T> extends Result<T> {
  /// The success value.
  final T value;

  const Success(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed result.
final class Fail<T> extends Result<T> {
  /// The failure details.
  final Failure failure;

  const Fail(this.failure);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Fail<T> && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Fail($failure)';
}

/// Extension for Future<Result>.
extension FutureResultExtension<T> on Future<Result<T>> {
  /// Handle both success and failure cases asynchronously.
  Future<R> fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) async {
    final result = await this;
    return result.fold(onSuccess: onSuccess, onFailure: onFailure);
  }

  /// Transform the success value asynchronously.
  Future<Result<R>> map<R>(R Function(T value) transform) async {
    final result = await this;
    return result.map(transform);
  }

  /// Transform with a function that returns a Future<Result>.
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Success<T>(:final value) => await transform(value),
      Fail<T>(:final failure) => Result<R>.failure(failure),
    };
  }

  /// Get the value or a default asynchronously.
  Future<T> getOrElse(T Function() orElse) async {
    final result = await this;
    return result.getOrElse(orElse);
  }
}

/// Helper function to wrap an async operation in a Result.
Future<Result<T>> runCatching<T>(Future<T> Function() operation) async {
  try {
    final value = await operation();
    return Result.success(value);
  } catch (e) {
    return Result.failure(Failure.unknown(error: e));
  }
}

/// Helper function to wrap a sync operation in a Result.
Result<T> tryCatch<T>(T Function() operation) {
  try {
    final value = operation();
    return Result.success(value);
  } catch (e) {
    return Result.failure(Failure.unknown(error: e));
  }
}

