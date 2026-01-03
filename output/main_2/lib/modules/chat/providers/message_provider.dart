/// Message provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
/// Message service provider.
/// Messages list provider.
final messagesProvider = FutureProvider.family<List<Message>, String>((ref, chatId) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

class MessageNotifier extends StateNotifier<AsyncValue<List<Message>>> {  final String _chatId;

  MessageNotifier(this._chatId)
      : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }

  /// Send a text message.
  Future<void> sendTextMessage(String content) async {
    throw UnimplementedError('Service call removed');
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
    throw UnimplementedError('Service call removed');
    );
  }

  /// Mark message as read.
  Future<void> markAsRead(String messageId) async {
    throw UnimplementedError('Service call removed');
  }

  /// Refresh messages.
  Future<void> refresh() => _loadMessages();
}

/// Message notifier provider.
final messageProvider =
    StateNotifierProvider.family<MessageNotifier, AsyncValue<List<Message>>, String>(
  (ref, chatId) {
    throw UnimplementedError('Service removed - implement repository provider');