/// Authentication state model (presentation layer).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Authentication state.
@freezed
class AuthState with _$AuthState {
  /// Initial/unauthenticated state.
  const factory AuthState.initial() = _Initial;

  /// Loading state (during auth operations).
  const factory AuthState.loading() = _Loading;

  /// Authenticated state with user.
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;

  /// Unauthenticated state.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Error state with message.
  const factory AuthState.error(String message) = _Error;
}

/// Auth state extensions.
extension AuthStateExtension on AuthState {
  /// Whether user is authenticated.
  bool get isAuthenticated => this is _Authenticated;

  /// Whether state is loading.
  bool get isLoading => this is _Loading;

  /// Get user if authenticated.
  UserEntity? get user => maybeWhen(
        authenticated: (user) => user,
        orElse: () => null,
      );

  /// Get error message if error state.
  String get errorMessage => maybeWhen(
        error: (message) => message,
        orElse: () => '',
      );
}

