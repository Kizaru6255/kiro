/// Profile provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
/// Profile service provider.
/// Profile provider.
final profileProvider = FutureProvider<UserProfile>((ref) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

/// Profile notifier.
class $1 extends StateNotifier<AsyncValue<UserProfile>> {  ProfileNotifier() : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }

  /// Update profile.
  Future<void> updateProfile({
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? stateProvince,
    String? country,
    String? zipCode,
  }) async {
    throw UnimplementedError('Service call removed');
    );
  }

  /// Refresh profile.
  Future<void> refresh() => _loadProfile();
}

/// Profile notifier provider.
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile>>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});