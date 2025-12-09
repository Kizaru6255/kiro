/// Notification provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';
import '../services/notification_service.dart';

/// Notification service provider.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Notifications list provider.
final notificationsProvider =
    FutureProvider<List<AppNotification>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  final result = await service.getNotifications();
  return result.fold(
    onSuccess: (notifications) => notifications,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Notification notifier.
class NotificationNotifier
    extends StateNotifier<AsyncValue<List<AppNotification>>> {
  final NotificationService _notificationService;

  NotificationNotifier(this._notificationService)
      : super(const AsyncValue.loading()) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    state = const AsyncValue.loading();
    final result = await _notificationService.getNotifications();
    result.fold(
      onSuccess: (notifications) => state = AsyncValue.data(notifications),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Mark notification as read.
  Future<void> markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
    _loadNotifications();
  }

  /// Mark all as read.
  Future<void> markAllAsRead() async {
    await _notificationService.markAllAsRead();
    _loadNotifications();
  }

  /// Refresh notifications.
  Future<void> refresh() => _loadNotifications();
}

/// Notification notifier provider.
final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<List<AppNotification>>>(
  (ref) {
    final service = ref.watch(notificationServiceProvider);
    return NotificationNotifier(service);
  },
);

