/// Notification item widget.
library;

import 'package:flutter/material.dart';

import '../../domain/entities/notification_entity.dart';

/// List item widget for displaying a notification.
class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(notification.type);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(
          _getTypeIcon(notification.type),
          color: color,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        notification.body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(notification.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (notification.isUnread) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    return switch (type) {
      NotificationType.info => Icons.info,
      NotificationType.success => Icons.check_circle,
      NotificationType.warning => Icons.warning,
      NotificationType.error => Icons.error,
      NotificationType.promotion => Icons.local_offer,
    };
  }

  Color _getTypeColor(NotificationType type) {
    return switch (type) {
      NotificationType.info => Colors.blue,
      NotificationType.success => Colors.green,
      NotificationType.warning => Colors.orange,
      NotificationType.error => Colors.red,
      NotificationType.promotion => Colors.purple,
    };
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

