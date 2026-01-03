/// Notification repository interface (domain layer).
library;

import '../entities/notification_entity.dart';
import '../../../../core/errors/errors.dart';

/// Notification repository interface.
abstract class NotificationRepository {
  /// Get all notifications.
  Future<Result<List<NotificationEntity>>> getNotifications();

  /// Mark notification as read.
  Future<Result<void>> markAsRead(String notificationId);

  /// Mark all notifications as read.
  Future<Result<void>> markAllAsRead();
}


