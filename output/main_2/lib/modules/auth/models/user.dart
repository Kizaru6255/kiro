/// User model for authentication.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model representing an authenticated user.
@freezed
class User with _$User {
  const factory User({
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
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// User profile extension.
extension UserExtension on User {
  /// Get full name or email as fallback.
  String get displayNameOrEmail => displayName ?? email;

  /// Get initials for avatar.
  String get initials {
    if (displayName != null) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  /// Check if user has complete profile.
  bool get hasCompleteProfile =>
      displayName != null && (emailVerified || phoneVerified);
}

