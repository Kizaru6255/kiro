/// Message provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';

/// Message notifier.
class MessageNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final String _chatId;

  MessageNotifier(this._chatId)
      : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = const AsyncValue.loading();
    // TODO: Implement actual message loading from repository
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AsyncValue.data([]);
  }

  /// Send a text message.
  Future<void> sendTextMessage(String content) async {
    // TODO: Implement actual message sending
    await Future.delayed(const Duration(milliseconds: 300));
    _loadMessages();
  }

  /// Refresh messages.
  Future<void> refresh() => _loadMessages();
}

/// Message notifier provider.
final messageProvider =
    StateNotifierProvider.family<MessageNotifier, AsyncValue<List<Message>>, String>(
  (ref, chatId) {
    return MessageNotifier(chatId);
  },
);

