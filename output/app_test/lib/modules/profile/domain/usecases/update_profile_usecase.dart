/// Update profile use case (domain layer).
library;

import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';
import '../../../../core/errors/errors.dart';

/// Use case for updating user profile.
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  /// Execute update profile.
  Future<Result<UserProfileEntity>> call({
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) async {
    // Domain validation
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      if (!_isValidPhoneNumber(phoneNumber)) {
        return Result.failure(
          Failure.validation(message: 'Invalid phone number format'),
        );
      }
    }

    return await _repository.updateProfile(
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      bio: bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
    );
  }

  bool _isValidPhoneNumber(String phone) {
    // Basic validation - can be enhanced
    return phone.length >= 10 && phone.length <= 15;
  }
}


