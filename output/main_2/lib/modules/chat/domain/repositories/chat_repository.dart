/// Chat repository interface (domain layer).
library;

import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';
import '../../../../core/errors/errors.dart';

/// Chat repository interface.
abstract class ChatRepository {
  /// Get all chats.
  Future<Result<List<ChatEntity>>> getChats();

  /// Get chat by ID.
  Future<Result<ChatEntity>> getChat(String chatId);

  /// Create chat.
  Future<Result<ChatEntity>> createChat({
    required ChatType type,
    required String name,
    required List<String> participantIds,
    String? description,
  });

  /// Send message.
  Future<Result<MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
    String? fileUrl,
  });

  /// Get messages for chat.
  Future<Result<List<MessageEntity>>> getMessages(String chatId);
}


