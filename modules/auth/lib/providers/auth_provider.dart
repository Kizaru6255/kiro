/// Authentication provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_state.dart';
import '../services/auth_service.dart';

/// Auth service provider.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Authentication state provider.
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Authentication notifier.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated.
  Future<void> _checkAuthStatus() async {
    final isAuth = await _authService.isAuthenticated();
    if (isAuth) {
      final result = await _authService.getCurrentUser();
      result.fold(
        onSuccess: (user) => state = AuthState.authenticated(user),
        onFailure: (_) => state = const AuthState.unauthenticated(),
      );
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  /// Login with email and password.
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final result = await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Sign up with email and password.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState.loading();

    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Login with phone OTP.
  Future<void> loginWithPhone({required String phoneNumber}) async {
    state = const AuthState.loading();

    final result = await _authService.loginWithPhone(phoneNumber: phoneNumber);

    result.fold(
      onSuccess: (_) => state = const AuthState.loading(), // Wait for OTP
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Verify OTP.
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AuthState.loading();

    final result = await _authService.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
    );

    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Login with Google.
  Future<void> loginWithGoogle() async {
    state = const AuthState.loading();

    final result = await _authService.loginWithGoogle();

    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Login with Apple.
  Future<void> loginWithApple() async {
    state = const AuthState.loading();

    final result = await _authService.loginWithApple();

    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Logout.
  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState.unauthenticated();
  }

  /// Request password reset.
  Future<void> requestPasswordReset({required String email}) async {
    state = const AuthState.loading();

    final result = await _authService.requestPasswordReset(email: email);

    result.fold(
      onSuccess: (_) => state = const AuthState.unauthenticated(),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }
}

