/// Profile repository interface (domain layer).
library;

import '../entities/user_profile_entity.dart';
import '../../../../core/errors/errors.dart';

/// Profile repository interface.
abstract class ProfileRepository {
  /// Get current user profile.
  Future<Result<UserProfileEntity>> getProfile();

  /// Update profile.
  Future<Result<UserProfileEntity>> updateProfile({
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
  });

  /// Upload profile picture.
  Future<Result<String>> uploadProfilePicture(String imagePath);
}


