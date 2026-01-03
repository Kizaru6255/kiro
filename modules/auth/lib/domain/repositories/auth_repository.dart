/// Authentication repository interface (domain layer).
/// 
/// Defines the contract for authentication operations.
/// Implementations are in the data layer.
library;

import '../entities/user_entity.dart';
import '../../core/errors/errors.dart';

/// Authentication repository interface.
abstract class AuthRepository {
  /// Login with email and password.
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password.
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Send OTP to phone number.
  Future<Result<void>> sendOtp({
    required String phoneNumber,
  });

  /// Verify OTP and login.
  Future<Result<UserEntity>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  /// Login with Google.
  Future<Result<UserEntity>> loginWithGoogle();

  /// Login with Apple.
  Future<Result<UserEntity>> loginWithApple();

  /// Logout current user.
  Future<void> logout();

  /// Get current authenticated user.
  Future<Result<UserEntity>> getCurrentUser();

  /// Request password reset.
  Future<Result<void>> requestPasswordReset({
    required String email,
  });

  /// Check if user is authenticated.
  Future<bool> isAuthenticated();
}


