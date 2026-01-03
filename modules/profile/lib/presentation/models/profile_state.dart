/// Profile state model (presentation layer).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile_entity.dart';

part 'profile_state.freezed.dart';

/// Profile state.
@freezed
class ProfileState with _$ProfileState {
  /// Initial state.
  const factory ProfileState.initial() = _Initial;

  /// Loading state.
  const factory ProfileState.loading() = _Loading;

  /// Loaded state with profile.
  const factory ProfileState.loaded(UserProfileEntity profile) = _Loaded;

  /// Error state.
  const factory ProfileState.error(String message) = _Error;
}

/// Profile state extensions.
extension ProfileStateExtension on ProfileState {
  /// Whether state is loading.
  bool get isLoading => this is _Loading;

  /// Get profile if loaded.
  UserProfileEntity? get profile => maybeWhen(
        loaded: (profile) => profile,
        orElse: () => null,
      );

  /// Get error message if error.
  String? get errorMessage=> maybeWhen(
        error: (message) => message,
        orElse: () => null,
      );
}


