/// Chat model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'message.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

/// Chat type.
enum ChatType {
  direct,
  group,
}

/// Chat model.
@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required ChatType type,
    required String name,
    String? description,
    String? imageUrl,
    required List<String> participantIds,
    Message? lastMessage,
    @Default(0) int unreadCount,
    DateTime? lastActivityAt,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

/// Chat extensions.
extension ChatExtension on Chat {
  /// Check if chat is a direct message.
  bool get isDirect => type == ChatType.direct;

  /// Check if chat is a group.
  bool get isGroup => type == ChatType.group;

  /// Get display name for direct chat.
  String getDisplayName(String currentUserId) {
    if (isGroup) return name;
    // For direct chats, return other participant's name
    final otherParticipants = participantIds.where((id) => id != currentUserId);
    if (otherParticipants.isEmpty) return name;
    return name; // Should be replaced with actual participant name
  }
}

