/// User DTO (data transfer object).
/// 
/// Data layer model for API responses.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// User data transfer object.
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    @Default(false) bool emailVerified,
    @Default(false) bool phoneVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension UserDtoExtension on UserDto {
  /// Convert DTO to domain entity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      displayName: displayName,
      photoUrl: photoUrl,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      metadata: metadata,
    );
  }
}


