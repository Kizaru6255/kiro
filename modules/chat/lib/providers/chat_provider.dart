/// Chat provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat.dart';
import '../services/chat_service.dart';

/// Chat service provider.
final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

/// Chats list provider.
final chatsProvider = FutureProvider<List<Chat>>((ref) async {
  final service = ref.watch(chatServiceProvider);
  final result = await service.getChats();
  return result.fold(
    onSuccess: (chats) => chats,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Single chat provider.
final chatProvider = FutureProvider.family<Chat, String>((ref, chatId) async {
  final service = ref.watch(chatServiceProvider);
  final result = await service.getChat(chatId);
  return result.fold(
    onSuccess: (chat) => chat,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Chat notifier.
class ChatNotifier extends StateNotifier<AsyncValue<List<Chat>>> {
  final ChatService _chatService;

  ChatNotifier(this._chatService) : super(const AsyncValue.loading()) {
    _loadChats();
  }

  Future<void> _loadChats() async {
    state = const AsyncValue.loading();
    final result = await _chatService.getChats();
    result.fold(
      onSuccess: (chats) => state = AsyncValue.data(chats),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Create a new chat.
  Future<void> createChat({
    required ChatType type,
    required List<String> participantIds,
    String? name,
    String? description,
  }) async {
    final result = await _chatService.createChat(
      type: type,
      participantIds: participantIds,
      name: name,
      description: description,
    );

    result.fold(
      onSuccess: (_) => _loadChats(),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Mark chat as read.
  Future<void> markAsRead(String chatId) async {
    await _chatService.markAsRead(chatId);
    _loadChats();
  }

  /// Refresh chats.
  Future<void> refresh() => _loadChats();
}

/// Chat notifier provider.
final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<Chat>>>((ref) {
  final service = ref.watch(chatServiceProvider);
  return ChatNotifier(service);
});

