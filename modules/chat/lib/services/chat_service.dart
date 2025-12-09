/// Chat service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/chat.dart';

/// Service for chat operations.
class ChatService {
  final DioClient _dioClient;

  ChatService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get all chats for current user.
  Future<Result<List<Chat>>> getChats() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/chats',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final chats = (data['chats'] as List)
              .map((json) => Chat.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.success(chats);
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
        Failure.network(message: 'Failed to get chats: $e'),
      );
    }
  }

  /// Get chat by ID.
  Future<Result<Chat>> getChat(String chatId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/chats/$chatId',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final chat = Chat.fromJson(data['chat'] as Map<String, dynamic>);
          return Result.success(chat);
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
        Failure.network(message: 'Failed to get chat: $e'),
      );
    }
  }

  /// Create a new chat.
  Future<Result<Chat>> createChat({
    required ChatType type,
    required List<String> participantIds,
    String? name,
    String? description,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/chats',
        data: {
          'type': type.name,
          'participant_ids': participantIds,
          if (name != null) 'name': name,
          if (description != null) 'description': description,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final chat = Chat.fromJson(data['chat'] as Map<String, dynamic>);
          return Result.success(chat);
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
        Failure.network(message: 'Failed to create chat: $e'),
      );
    }
  }

  /// Mark chat as read.
  Future<Result<void>> markAsRead(String chatId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/chats/$chatId/read',
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
        Failure.network(message: 'Failed to mark chat as read: $e'),
      );
    }
  }
}

