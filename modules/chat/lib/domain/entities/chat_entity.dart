/// Chat entity (domain layer).
library;

import 'message_entity.dart';

/// Chat type.
enum ChatType {
  direct,
  group,
}

/// Chat entity.
class ChatEntity {
  final String id;
  final ChatType type;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<String> participantIds;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const ChatEntity({
    required this.id,
    required this.type,
    required this.name,
    this.description,
    this.imageUrl,
    required this.participantIds,
    this.lastMessage,
    this.unreadCount = 0,
    this.lastActivityAt,
    required this.createdAt,
    this.metadata,
  });

  /// Check if chat is a direct message.
  bool get isDirect => type == ChatType.direct;

  /// Check if chat is a group.
  bool get isGroup => type == ChatType.group;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


