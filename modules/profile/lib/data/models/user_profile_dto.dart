/// User profile DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile_entity.dart';

part 'user_profile_dto.freezed.dart';
part 'user_profile_dto.g.dart';

/// User profile data transfer object.
@freezed
class UserProfileDto with _$UserProfileDto {
  const factory UserProfileDto({
    required String id,
    required String email,
    String? phoneNumber,
    String? displayName,
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension UserProfileDtoExtension on UserProfileDto {
  /// Convert DTO to domain entity.
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
      bio: bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}


