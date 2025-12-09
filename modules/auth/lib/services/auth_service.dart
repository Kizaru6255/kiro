/// Authentication service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/user.dart';

/// Service for handling authentication operations.
class AuthService {
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  AuthService({
    DioClient? dioClient,
    SecureStorage? secureStorage,
  })  : _dioClient = dioClient ?? DioClient.instance,
        _secureStorage = secureStorage ?? SecureStorage();

  /// Login with email and password.
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) async {
          final user = User.fromJson(data['user'] as Map<String, dynamic>);
          final token = data['token'] as String;

          // Store token securely
          await _secureStorage.setString(StorageKeys.accessToken, token);

          return Result.success(user);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Login failed: $e'),
      );
    }
  }

  /// Sign up with email and password.
  Future<Result<User>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          if (displayName != null) 'display_name': displayName,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) async {
          final user = User.fromJson(data['user'] as Map<String, dynamic>);
          final token = data['token'] as String;

          await _secureStorage.setString(StorageKeys.accessToken, token);

          return Result.success(user);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Sign up failed: $e'),
      );
    }
  }

  /// Login with phone OTP.
  Future<Result<void>> loginWithPhone({
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/phone/send-otp',
        data: {'phone_number': phoneNumber},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (_, __) => const Result.success(null),
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to send OTP: $e'),
      );
    }
  }

  /// Verify OTP and login.
  Future<Result<User>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/phone/verify-otp',
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) async {
          final user = User.fromJson(data['user'] as Map<String, dynamic>);
          final token = data['token'] as String;

          await _secureStorage.setString(StorageKeys.accessToken, token);

          return Result.success(user);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'OTP verification failed: $e'),
      );
    }
  }

  /// Login with Google.
  Future<Result<User>> loginWithGoogle() async {
    // TODO: Implement Google Sign-In
    return Result.failure(
      Failure.network(message: 'Google Sign-In not yet implemented'),
    );
  }

  /// Login with Apple.
  Future<Result<User>> loginWithApple() async {
    // TODO: Implement Apple Sign-In
    return Result.failure(
      Failure.network(message: 'Apple Sign-In not yet implemented'),
    );
  }

  /// Logout current user.
  Future<void> logout() async {
    await _secureStorage.remove(StorageKeys.accessToken);
    await _secureStorage.remove(StorageKeys.refreshToken);
  }

  /// Get current user from token.
  Future<Result<User>> getCurrentUser() async {
    try {
      final token = await _secureStorage.getString(StorageKeys.accessToken);
      if (token == null) {
        return Result.failure(
          Failure.network(message: 'No authentication token found'),
        );
      }

      final response = await _dioClient.get<Map<String, dynamic>>(
        '/auth/me',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final user = User.fromJson(data['user'] as Map<String, dynamic>);
          return Result.success(user);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get current user: $e'),
      );
    }
  }

  /// Request password reset.
  Future<Result<void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/password/reset',
        data: {'email': email},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (_, __) => const Result.success(null),
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to request password reset: $e'),
      );
    }
  }

  /// Check if user is authenticated.
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getString(StorageKeys.accessToken);
    return token != null;
  }
}

