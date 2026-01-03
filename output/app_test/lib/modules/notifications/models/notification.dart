/// Notification model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Notification type.
enum NotificationType {
  info,
  success,
  warning,
  error,
  promotion,
}

/// Notification model.
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    @Default(NotificationType.info) NotificationType type,
    String? imageUrl,
    String? actionUrl,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    Map<String, dynamic>? data,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

/// Notification extensions.
extension NotificationExtension on AppNotification {
  /// Check if notification is unread.
  bool get isUnread => !isRead;
}

