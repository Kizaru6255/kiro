/// Chat provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat.dart';
/// Chat service provider.
/// Chats list provider.
final chatsProvider = FutureProvider<List<Chat>>((ref) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

/// Single chat provider.
});

final singleChatProvider = FutureProvider.family<Chat, String>((ref, chatId) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

class ChatNotifier extends StateNotifier<AsyncValue<List<Chat>>> {  ChatNotifier() : super(const AsyncValue.loading()) {
    _loadChats();
  }

  Future<void> _loadChats() async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }

  /// Create a new chat.
  Future<void> createChat({
    required ChatType type,
    required List<String> participantIds,
    String? name,
    String? description,
  }) async {
    throw UnimplementedError('Service call removed');
    );
  }

  /// Mark chat as read.
  Future<void> markAsRead(String chatId) async {
    throw UnimplementedError('Service call removed');
    _loadChats();
  }

  /// Refresh chats.
  Future<void> refresh() => _loadChats();
}

/// Chat notifier provider.
final chatProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<Chat>>>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});