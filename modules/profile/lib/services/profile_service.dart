/// Profile service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/user_profile.dart';

/// Service for profile operations.
class ProfileService {
  final DioClient _dioClient;

  ProfileService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get current user profile.
  Future<Result<UserProfile>> getProfile() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/profile',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final profile = UserProfile.fromJson(
            data['profile'] as Map<String, dynamic>,
          );
          return Result.success(profile);
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
        Failure.network(message: 'Failed to get profile: $e'),
      );
    }
  }

  /// Update profile.
  Future<Result<UserProfile>> updateProfile({
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
    try {
      final data = <String, dynamic>{};
      if (displayName != null) data['display_name'] = displayName;
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (bio != null) data['bio'] = bio;
      if (dateOfBirth != null) {
        data['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      if (gender != null) data['gender'] = gender;
      if (address != null) data['address'] = address;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (country != null) data['country'] = country;
      if (zipCode != null) data['zip_code'] = zipCode;

      final response = await _dioClient.put<Map<String, dynamic>>(
        '/profile',
        data: data,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final profile = UserProfile.fromJson(
            data['profile'] as Map<String, dynamic>,
          );
          return Result.success(profile);
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
        Failure.network(message: 'Failed to update profile: $e'),
      );
    }
  }

  /// Upload profile picture.
  Future<Result<String>> uploadProfilePicture(String imagePath) async {
    try {
      // TODO: Implement file upload
      return Result.failure(
        Failure.network(message: 'Profile picture upload not yet implemented'),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to upload profile picture: $e'),
      );
    }
  }
}

