/// Message bubble widget.
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/message_entity.dart';

/// Widget for displaying a message bubble.
class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isOwnMessage;
  final VoidCallback? onTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isOwnMessage
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.isMedia && message.fileUrl != null)
                _buildMediaContent(context)
              else
                Text(
                  message.content,
                  style: TextStyle(
                    color: isOwnMessage ? Colors.white : null,
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: isOwnMessage
                          ? Colors.white70
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  if (isOwnMessage) ...[
                    const SizedBox(width: 4),
                    Icon(
                      _getStatusIcon(message.status),
                      size: 12,
                      color: Colors.white70,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    if (message.type == MessageType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: message.fileUrl!,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 200,
            color: Colors.grey.shade300,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: Colors.grey.shade300,
            child: const Icon(Icons.error),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(_getFileIcon(message.type)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.fileName ?? 'File',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (message.formattedFileSize != null)
                  Text(
                    message.formattedFileSize!,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(MessageType type) {
    return switch (type) {
      MessageType.file => Icons.insert_drive_file,
      MessageType.audio => Icons.audiotrack,
      MessageType.video => Icons.videocam,
      _ => Icons.file_present,
    };
  }

  IconData _getStatusIcon(MessageStatus status) {
    return switch (status) {
      MessageStatus.sending => Icons.access_time,
      MessageStatus.sent => Icons.check,
      MessageStatus.delivered => Icons.done_all,
      MessageStatus.read => Icons.done_all,
      MessageStatus.failed => Icons.error,
    };
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

