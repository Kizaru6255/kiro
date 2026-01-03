/// Chat item widget.
library;

import 'package:flutter/material.dart';

import '../../domain/entities/chat_entity.dart';

/// List item widget for displaying a chat.
class ChatItem extends StatelessWidget {
  final ChatEntity chat;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: chat.imageUrl != null
            ? NetworkImage(chat.imageUrl!)
            : null,
        child: chat.imageUrl == null
            ? Text(chat.name[0].toUpperCase())
            : null,
      ),
      title: Text(chat.name),
      subtitle: chat.lastMessage != null
          ? Text(
              chat.lastMessage!.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chat.lastMessage != null)
            Text(
              _formatTime(chat.lastMessage!.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (chat.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

