/// Get profile use case (domain layer).
library;

import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for getting user profile.
class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  /// Execute get profile.
  Future<Result<UserProfileEntity>> call() async {
    return await _repository.getProfile();
  }
}


