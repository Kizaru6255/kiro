/// Profile provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';

/// Profile service provider.
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

/// Profile provider.
final profileProvider = FutureProvider<UserProfile>((ref) async {
  final service = ref.watch(profileServiceProvider);
  final result = await service.getProfile();
  return result.fold(
    onSuccess: (profile) => profile,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Profile notifier.
class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  final ProfileService _profileService;

  ProfileNotifier(this._profileService) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    state = const AsyncValue.loading();
    final result = await _profileService.getProfile();
    result.fold(
      onSuccess: (profile) {
        state = AsyncValue.data(profile);
      },
      onFailure: (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
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
    final result = await _profileService.updateProfile(
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      bio: bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      city: city,
      state: stateProvince,
      country: country,
      zipCode: zipCode,
    );

    result.fold(
      onSuccess: (profile) {
        state = AsyncValue.data(profile);
      },
      onFailure: (failure) {
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
    );
  }

  /// Refresh profile.
  Future<void> refresh() => _loadProfile();
}

/// Profile notifier provider.
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile>>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileNotifier(service);
});

