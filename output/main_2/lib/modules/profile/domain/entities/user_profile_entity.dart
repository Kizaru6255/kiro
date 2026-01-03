/// User profile entity (domain layer).
library;

/// User profile entity.
class UserProfileEntity {
  final String id;
  final String email;
  final String? phoneNumber;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const UserProfileEntity({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  /// Get full name.
  String get fullName {
    if (displayName != null) return displayName!;
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) return firstName!;
    if (lastName != null) return lastName!;
    return email;
  }

  /// Get initials for avatar.
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    return email[0].toUpperCase();
  }

  /// Check if profile is complete.
  bool get isComplete =>
      displayName != null &&
      phoneNumber != null &&
      dateOfBirth != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


