/// Notification service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/notification.dart';

/// Service for notification operations.
class NotificationService {
  final DioClient _dioClient;

  NotificationService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get all notifications.
  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/notifications',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final notifications = (data['notifications'] as List)
              .map((json) =>
                  AppNotification.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.success(notifications);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get notifications: $e'),
      );
    }
  }

  /// Mark notification as read.
  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/notifications/$notificationId/read',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (_, __) => const Result.success(null),
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to mark notification as read: $e'),
      );
    }
  }

  /// Mark all as read.
  Future<Result<void>> markAllAsRead() async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/notifications/read-all',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (_, __) => const Result.success(null),
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to mark all as read: $e'),
      );
    }
  }
}

