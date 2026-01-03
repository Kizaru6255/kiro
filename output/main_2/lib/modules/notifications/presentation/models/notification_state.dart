/// Notification state model (presentation layer).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_state.freezed.dart';

/// Notification state.
@freezed
class NotificationState with _$NotificationState {
  /// Initial state.
  const factory NotificationState.initial() = _Initial;

  /// Loading state.
  const factory NotificationState.loading() = _Loading;

  /// Loaded state with notifications.
  const factory NotificationState.loaded(
    List<NotificationEntity> notifications,
  ) = _Loaded;

  /// Error state.
  const factory NotificationState.error(String message) = _Error;
}

/// Notification state extensions.
extension NotificationStateExtension on NotificationState {
  /// Whether state is loading.
  bool get isLoading => this is _Loading;

  /// Get notifications if loaded.
  List<NotificationEntity>? get notifications => maybeWhen(
        loaded: (notifications) => notifications,
        orElse: () => null,
      );

  /// Get error message if error.
  String? get errorMessage=> maybeWhen(
        error: (message) => message,
        orElse: () => null,
      );
}


