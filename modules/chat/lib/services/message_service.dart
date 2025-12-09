/// Message service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/message.dart';

/// Service for message operations.
class MessageService {
  final DioClient _dioClient;

  MessageService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get messages for a chat.
  Future<Result<List<Message>>> getMessages({
    required String chatId,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _dioClient.get<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        queryParameters: queryParams,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final messages = (data['messages'] as List)
              .map((json) => Message.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.success(messages);
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
        Failure.network(message: 'Failed to get messages: $e'),
      );
    }
  }

  /// Send a text message.
  Future<Result<Message>> sendTextMessage({
    required String chatId,
    required String content,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        data: {
          'type': MessageType.text.name,
          'content': content,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final message = Message.fromJson(
            data['message'] as Map<String, dynamic>,
          );
          return Result.success(message);
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
        Failure.network(message: 'Failed to send message: $e'),
      );
    }
  }

  /// Send a media message.
  Future<Result<Message>> sendMediaMessage({
    required String chatId,
    required MessageType type,
    required String fileUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/chats/$chatId/messages',
        data: {
          'type': type.name,
          'file_url': fileUrl,
          if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
          if (fileName != null) 'file_name': fileName,
          if (fileSize != null) 'file_size': fileSize,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final message = Message.fromJson(
            data['message'] as Map<String, dynamic>,
          );
          return Result.success(message);
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
        Failure.network(message: 'Failed to send media message: $e'),
      );
    }
  }

  /// Mark message as read.
  Future<Result<void>> markAsRead({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId/read',
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
        Failure.network(message: 'Failed to mark message as read: $e'),
      );
    }
  }

  /// Delete a message.
  Future<Result<void>> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      final response = await _dioClient.delete<Map<String, dynamic>>(
        '/chats/$chatId/messages/$messageId',
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
        Failure.network(message: 'Failed to delete message: $e'),
      );
    }
  }
}

