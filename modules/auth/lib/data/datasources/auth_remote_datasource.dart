/// Authentication remote data source.
/// 
/// Handles API calls for authentication.
library;

import 'package:dio/dio.dart';

/// Remote data source for authentication.
abstract class AuthRemoteDataSource {
  /// Login with email and password.
  Future<Response<Map<String, dynamic>>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password.
  Future<Response<Map<String, dynamic>>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Send OTP to phone number.
  Future<Response<void>> sendOtp({
    required String phoneNumber,
  });

  /// Verify OTP.
  Future<Response<Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  /// Login with Google.
  Future<Response<Map<String, dynamic>>> loginWithGoogle();

  /// Login with Apple.
  Future<Response<Map<String, dynamic>>> loginWithApple();

  /// Get current user.
  Future<Response<Map<String, dynamic>>> getCurrentUser();

  /// Request password reset.
  Future<Response<void>> requestPasswordReset({
    required String email,
  });
}

/// Implementation of auth remote data source.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<Response<Map<String, dynamic>>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
        if (displayName != null) 'display_name': displayName,
      },
    );
  }

  @override
  Future<Response<void>> sendOtp({
    required String phoneNumber,
  }) async {
    return await _dio.post<void>(
      '/auth/phone/send-otp',
      data: {'phone_number': phoneNumber},
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    return await _dio.post<Map<String, dynamic>>(
      '/auth/phone/verify-otp',
      data: {
        'phone_number': phoneNumber,
        'otp': otp,
      },
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> loginWithGoogle() async {
    // TODO: Implement Google Sign-In
    throw UnimplementedError('Google Sign-In not yet implemented');
  }

  @override
  Future<Response<Map<String, dynamic>>> loginWithApple() async {
    // TODO: Implement Apple Sign-In
    throw UnimplementedError('Apple Sign-In not yet implemented');
  }

  @override
  Future<Response<Map<String, dynamic>>> getCurrentUser() async {
    return await _dio.get<Map<String, dynamic>>(
      '/auth/me',
    );
  }

  @override
  Future<Response<void>> requestPasswordReset({
    required String email,
  }) async {
    return await _dio.post<void>(
      '/auth/password/reset',
      data: {'email': email},
    );
  }
}
