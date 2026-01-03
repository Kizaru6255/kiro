/// Profile provider (presentation layer).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../models/profile_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// SharedPreferences provider.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Remote data source provider.
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl();
});

/// Local data source provider.
final profileLocalDataSourceProvider =
    FutureProvider<ProfileLocalDataSource>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ProfileLocalDataSourceImpl(prefs: prefs);
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// Profile repository provider.
final profileRepositoryProvider = FutureProvider<ProfileRepository>((ref) async {
  final localDataSource = await ref.watch(profileLocalDataSourceProvider.future);
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: localDataSource,
  );
});

// ============================================================================
// Use Cases (Riverpod Providers)
// ============================================================================

/// Get profile use case provider.
final getProfileUseCaseProvider = FutureProvider<GetProfileUseCase>((ref) async {
  final repository = await ref.watch(profileRepositoryProvider.future);
  return GetProfileUseCase(repository);
});

/// Update profile use case provider.
final updateProfileUseCaseProvider = FutureProvider<UpdateProfileUseCase>((ref) async {
  final repository = await ref.watch(profileRepositoryProvider.future);
  return UpdateProfileUseCase(repository);
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// Profile notifier.
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileNotifier({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        super(const ProfileState.initial()) {
    loadProfile();
  }

  /// Load profile.
  Future<void> loadProfile() async {
    state = const ProfileState.loading();

    final result = await _getProfileUseCase();

    result.fold(
      onSuccess: (profile) => state = ProfileState.loaded(profile),
      onFailure: (failure) => state = ProfileState.error(failure.message),
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
    state = const ProfileState.loading();

    final result = await _updateProfileUseCase(
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
      onSuccess: (profile) => state = ProfileState.loaded(profile),
      onFailure: (failure) => state = ProfileState.error(failure.message),
    );
  }

  /// Refresh profile.
  Future<void> refresh() => loadProfile();
}

/// Profile state provider.
final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final getProfileUseCaseAsync = ref.watch(getProfileUseCaseProvider);
  final updateProfileUseCaseAsync = ref.watch(updateProfileUseCaseProvider);

  return getProfileUseCaseAsync.when(
    data: (getProfileUseCase) => updateProfileUseCaseAsync.when(
      data: (updateProfileUseCase) => ProfileNotifier(
        getProfileUseCase: getProfileUseCase,
        updateProfileUseCase: updateProfileUseCase,
      ),
      loading: () => throw UnimplementedError('UpdateProfileUseCase loading'),
      error: (_, __) => throw UnimplementedError('UpdateProfileUseCase error'),
    ),
    loading: () => throw UnimplementedError('GetProfileUseCase loading'),
    error: (_, __) => throw UnimplementedError('GetProfileUseCase error'),
  );
});

