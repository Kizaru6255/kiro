/// Login use case (domain layer).
/// 
/// Business logic for user login.
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for logging in with email and password.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Execute login.
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Domain validation
    if (email.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'Email cannot be empty'),
      );
    }

    if (password.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'Password cannot be empty'),
      );
    }

    // Email format validation
    if (!_isValidEmail(email)) {
      return Result.failure(
        Failure.validation(message: 'Invalid email format'),
      );
    }

    // Delegate to repository
    return await _repository.loginWithEmail(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}


