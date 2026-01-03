/// Authentication repository implementation (data layer).
/// 
/// Implements the domain repository interface.
library;

import 'package:dio/dio.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/errors.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_dto.dart';

/// Implementation of authentication repository.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userDto = UserDto.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        // Store token
        await _localDataSource.saveAccessToken(token);

        return Result.success(userDto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Login failed: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Login failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Login failed: $e'),
      );
    }
  }

  @override
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userDto = UserDto.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        await _localDataSource.saveAccessToken(token);

        return Result.success(userDto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Sign up failed: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Sign up failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Sign up failed: $e'),
      );
    }
  }

  @override
  Future<Result<void>> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _remoteDataSource.sendOtp(
        phoneNumber: phoneNumber,
      );

      if (response.statusCode == 200) {
        return const Result.success(null);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to send OTP: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to send OTP',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to send OTP: $e'),
      );
    }
  }

  @override
  Future<Result<UserEntity>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _remoteDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userDto = UserDto.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        await _localDataSource.saveAccessToken(token);

        return Result.success(userDto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'OTP verification failed: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'OTP verification failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'OTP verification failed: $e'),
      );
    }
  }

  @override
  Future<Result<UserEntity>> loginWithGoogle() async {
    try {
      final response = await _remoteDataSource.loginWithGoogle();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userDto = UserDto.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        await _localDataSource.saveAccessToken(token);

        return Result.success(userDto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Google Sign-In failed: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Google Sign-In failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Google Sign-In failed: $e'),
      );
    }
  }

  @override
  Future<Result<UserEntity>> loginWithApple() async {
    try {
      final response = await _remoteDataSource.loginWithApple();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userDto = UserDto.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        await _localDataSource.saveAccessToken(token);

        return Result.success(userDto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Apple Sign-In failed: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Apple Sign-In failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Apple Sign-In failed: $e'),
      );
    }
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearTokens();
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final token = await _localDataSource.getAccessToken();
      if (token == null) {
        return Result.failure(
          Failure.network(message: 'No authentication token found'),
        );
      }

      final response = await _remoteDataSource.getCurrentUser();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userDto = UserDto.fromJson(data['user'] as Map<String, dynamic>);
        return Result.success(userDto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get current user: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get current user',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get current user: $e'),
      );
    }
  }

  @override
  Future<Result<void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await _remoteDataSource.requestPasswordReset(
        email: email,
      );

      if (response.statusCode == 200) {
        return const Result.success(null);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to request password reset: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to request password reset',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to request password reset: $e'),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getAccessToken();
    return token != null;
  }
}
