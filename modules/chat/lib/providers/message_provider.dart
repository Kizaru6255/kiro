/// Message provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
import '../services/message_service.dart';

/// Message service provider.
final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService();
});

/// Messages list provider.
final messagesProvider = FutureProvider.family<List<Message>, String>((ref, chatId) async {
  final service = ref.watch(messageServiceProvider);
  final result = await service.getMessages(chatId: chatId);
  return result.fold(
    onSuccess: (messages) => messages,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Message notifier.
class MessageNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final MessageService _messageService;
  final String _chatId;

  MessageNotifier(this._messageService, this._chatId)
      : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = const AsyncValue.loading();
    final result = await _messageService.getMessages(chatId: _chatId);
    result.fold(
      onSuccess: (messages) => state = AsyncValue.data(messages),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Send a text message.
  Future<void> sendTextMessage(String content) async {
    final result = await _messageService.sendTextMessage(
      chatId: _chatId,
      content: content,
    );

    result.fold(
      onSuccess: (_) => _loadMessages(),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Send a media message.
  Future<void> sendMediaMessage({
    required MessageType type,
    required String fileUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
  }) async {
    final result = await _messageService.sendMediaMessage(
      chatId: _chatId,
      type: type,
      fileUrl: fileUrl,
      thumbnailUrl: thumbnailUrl,
      fileName: fileName,
      fileSize: fileSize,
    );

    result.fold(
      onSuccess: (_) => _loadMessages(),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Mark message as read.
  Future<void> markAsRead(String messageId) async {
    await _messageService.markAsRead(
      chatId: _chatId,
      messageId: messageId,
    );
  }

  /// Refresh messages.
  Future<void> refresh() => _loadMessages();
}

/// Message notifier provider.
final messageNotifierProvider =
    StateNotifierProvider.family<MessageNotifier, AsyncValue<List<Message>>, String>(
  (ref, chatId) {
    final service = ref.watch(messageServiceProvider);
    return MessageNotifier(service, chatId);
  },
);

