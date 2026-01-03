/// Notification provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';
/// Notification service provider.
/// Notifications list provider.
final notificationsProvider =
    FutureProvider<List<AppNotification>>((ref) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

/// Notification notifier.
class $1 extends StateNotifier<AsyncValue<List<AppNotification>>> {  NotificationNotifier()
      : super(const AsyncValue.loading()) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }

  /// Mark notification as read.
  Future<void> markAsRead(String notificationId) async {
    throw UnimplementedError('Service call removed');
    _loadNotifications();
  }

  /// Mark all as read.
  Future<void> markAllAsRead() async {
    throw UnimplementedError('Service call removed');
    _loadNotifications();
  }

  /// Refresh notifications.
  Future<void> refresh() => _loadNotifications();
}

/// Notification notifier provider.
final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<List<AppNotification>>>(
  (ref) {
    throw UnimplementedError('Service removed - implement repository provider');