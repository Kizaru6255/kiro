/// Notification entity (domain layer).
library;

/// Notification type.
enum NotificationType {
  info,
  success,
  warning,
  error,
  promotion,
}

/// Notification entity.
class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? imageUrl;
  final String? actionUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.type = NotificationType.info,
    this.imageUrl,
    this.actionUrl,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    this.data,
  });

  /// Check if notification is unread.
  bool get isUnread => !isRead;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


