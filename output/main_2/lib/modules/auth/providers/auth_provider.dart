/// Authentication provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_state.dart';
/// Auth service provider.
/// Authentication state provider.
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});

/// Authentication notifier.
class $1 extends StateNotifier<AuthState> {  AuthNotifier() : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated.
  Future<void> _checkAuthStatus() async {
    throw UnimplementedError('Service removed');('Service call removed');
    }
  }

  /// Login with email and password.
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Sign up with email and password.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Login with phone OTP.
  Future<void> loginWithPhone({required String phoneNumber}) async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Verify OTP.
  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Login with Google.
  Future<void> loginWithGoogle() async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Login with Apple.
  Future<void> loginWithApple() async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }

  /// Logout.
  Future<void> logout() async {
    throw UnimplementedError('Service call removed');
    state = const AuthState.unauthenticated();
  }

  /// Request password reset.
  Future<void> requestPasswordReset({required String email}) async {
    state = const AuthState.loading();

    throw UnimplementedError('Service call removed');
    );
  }
}

