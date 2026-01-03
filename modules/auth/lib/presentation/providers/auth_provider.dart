/// Authentication provider (presentation layer).
/// 
/// Uses Riverpod to manage authentication state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../models/auth_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// Remote data source provider.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

/// Local data source provider.
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// Authentication repository provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// ============================================================================
// Use Cases (Riverpod Providers)
// ============================================================================

/// Login use case provider.
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

/// Sign up use case provider.
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// Authentication state notifier.
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final AuthRepository _repository;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required AuthRepository repository,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _repository = repository,
        super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated.
  Future<void> _checkAuthStatus() async {
    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      final result = await _repository.getCurrentUser();
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

    final result = await _loginUseCase(
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

    final result = await _signUpUseCase(
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
    final result = await _repository.sendOtp(phoneNumber: phoneNumber);
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
    final result = await _repository.verifyOtp(
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
    final result = await _repository.loginWithGoogle();
    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Login with Apple.
  Future<void> loginWithApple() async {
    state = const AuthState.loading();
    final result = await _repository.loginWithApple();
    result.fold(
      onSuccess: (user) => state = AuthState.authenticated(user),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Request password reset.
  Future<void> requestPasswordReset({required String email}) async {
    state = const AuthState.loading();
    final result = await _repository.requestPasswordReset(email: email);
    result.fold(
      onSuccess: (_) => state = const AuthState.unauthenticated(),
      onFailure: (failure) => state = AuthState.error(failure.message),
    );
  }

  /// Logout.
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }
}

/// Authentication state provider.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    signUpUseCase: ref.watch(signUpUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
  );
});

// ============================================================================
// Derived Providers
// ============================================================================

/// Whether user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Current user entity.
final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});

