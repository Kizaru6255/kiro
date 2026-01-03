/// Sign up use case (domain layer).
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/errors.dart';

/// Use case for user registration.
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  /// Execute sign up.
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    String? displayName,
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

    if (password.length < 8) {
      return Result.failure(
        Failure.validation(message: 'Password must be at least 8 characters'),
      );
    }

    // Email format validation
    if (!_isValidEmail(email)) {
      return Result.failure(
        Failure.validation(message: 'Invalid email format'),
      );
    }

    // Delegate to repository
    return await _repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}


