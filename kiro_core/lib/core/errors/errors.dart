/// Error handling module for Kiro Core.
///
/// This module provides:
/// - [KiroException] hierarchy for all errors
/// - [Failure] for functional error handling
/// - [Result] type for operations that can fail
///
/// Example:
/// ```dart
/// // Using exceptions
/// try {
///   await api.fetchUser(id);
/// } on NetworkException catch (e) {
///   handleError(e);
/// }
///
/// // Using Result type
/// final result = await userRepository.getUser(id);
/// result.fold(
///   onSuccess: (user) => showUser(user),
///   onFailure: (failure) => showError(failure.message),
/// );
/// ```
library;

export 'app_exception.dart';
export 'failure.dart';
export 'result.dart';

