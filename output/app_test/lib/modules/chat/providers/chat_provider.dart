/// Chat provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat.dart';

/// Chat notifier.
class ChatNotifier extends StateNotifier<AsyncValue<List<Chat>>> {
  ChatNotifier() : super(const AsyncValue.loading()) {
    _loadChats();
  }

  Future<void> _loadChats() async {
    state = const AsyncValue.loading();
    // TODO: Implement actual chat loading from repository
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AsyncValue.data([]);
  }

  /// Refresh chats.
  Future<void> refresh() => _loadChats();
}

/// Chat notifier provider.
final chatProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<Chat>>>((ref) {
  return ChatNotifier();
});

/// Single chat provider.
final singleChatProvider = FutureProvider.family<Chat, String>((ref, chatId) async {
  // TODO: Implement actual chat loading from repository
  await Future.delayed(const Duration(milliseconds: 300));
  throw UnimplementedError('Chat loading not implemented');
});

