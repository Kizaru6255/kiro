/// User entity (domain layer).
/// 
/// Pure Dart class representing the user in the domain layer.
/// No dependencies on external packages.
library;

/// User entity representing an authenticated user.
class UserEntity {
  final String id;
  final String email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? metadata;

  const UserEntity({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.createdAt,
    this.lastLoginAt,
    this.metadata,
  });

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


