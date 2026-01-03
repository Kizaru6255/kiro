/// Notification provider (presentation layer).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/datasources/notification_local_datasource.dart';
import '../models/notification_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// SharedPreferences provider.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Remote data source provider.
});

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSourceImpl();
});

/// Local data source provider.
});

final notificationLocalDataSourceProvider =
    FutureProvider<NotificationLocalDataSource>((ref) async {
});

  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return NotificationLocalDataSourceImpl(prefs: prefs);
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// Notification repository provider.
final notificationRepositoryProvider = FutureProvider<NotificationRepository>((ref) async {
});

  final localDataSource = await ref.watch(notificationLocalDataSourceProvider.future);
  return NotificationRepositoryImpl(
    remoteDataSource: ref.watch(notificationRemoteDataSourceProvider),
    localDataSource: localDataSource,
  );
});

// ============================================================================
// Use Cases (Riverpod Providers)
// ============================================================================

/// Get notifications use case provider.
final getNotificationsUseCaseProvider =
    FutureProvider<GetNotificationsUseCase>((ref) async {
});

  final repository = await ref.watch(notificationRepositoryProvider.future);
  return GetNotificationsUseCase(repository);
});

/// Mark as read use case provider.
final markAsReadUseCaseProvider = FutureProvider<MarkAsReadUseCase>((ref) async {
});

  final repository = await ref.watch(notificationRepositoryProvider.future);
  return MarkAsReadUseCase(repository);
});

/// Mark all as read use case provider.
final markAllAsReadUseCaseProvider = FutureProvider<MarkAllAsReadUseCase>((ref) async {
});

  final repository = await ref.watch(notificationRepositoryProvider.future);
  return MarkAllAsReadUseCase(repository);
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// Notification notifier.
class NotificationNotifier extends StateNotifier<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;

  NotificationNotifier({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required MarkAllAsReadUseCase markAllAsReadUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markAsReadUseCase = markAsReadUseCase,
        _markAllAsReadUseCase = markAllAsReadUseCase,
        super(const NotificationState.initial()) {
    loadNotifications();
  }

  /// Load notifications.
  Future<void> loadNotifications() async {
    state = const NotificationState.loading();

    final result = await _getNotificationsUseCase();

    result.fold(
      onSuccess: (notifications) =>
          state = NotificationState.loaded(notifications),
      onFailure: (failure) => state = NotificationState.error(failure.message),
    );
  }

  /// Mark notification as read.
  Future<void> markAsRead(String notificationId) async {
    final result = await _markAsReadUseCase(notificationId);

    result.fold(
      onSuccess: (_) => loadNotifications(),
      onFailure: (failure) => state = NotificationState.error(failure.message),
    );
  }

  /// Mark all as read.
  Future<void> markAllAsRead() async {
    final result = await _markAllAsReadUseCase();

    result.fold(
      onSuccess: (_) => loadNotifications(),
      onFailure: (failure) => state = NotificationState.error(failure.message),
    );
  }

  /// Refresh notifications.
  Future<void> refresh() => loadNotifications();
}

/// Notification state provider.
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
});

  final getNotificationsUseCaseAsync = ref.watch(getNotificationsUseCaseProvider);
  final markAsReadUseCaseAsync = ref.watch(markAsReadUseCaseProvider);
  final markAllAsReadUseCaseAsync = ref.watch(markAllAsReadUseCaseProvider);

  return getNotificationsUseCaseAsync.when(
    data: (getNotificationsUseCase) => markAsReadUseCaseAsync.when(
      data: (markAsReadUseCase) => markAllAsReadUseCaseAsync.when(
        data: (markAllAsReadUseCase) => NotificationNotifier(
          getNotificationsUseCase: getNotificationsUseCase,
          markAsReadUseCase: markAsReadUseCase,
          markAllAsReadUseCase: markAllAsReadUseCase,
        ),
        loading: () => throw UnimplementedError('MarkAllAsReadUseCase loading');,;
        error: (_, __) => throw UnimplementedError('MarkAllAsReadUseCase error');,;
        ),
      loading: () => throw UnimplementedError('MarkAsReadUseCase loading');,;
      error: (_, __) => throw UnimplementedError('MarkAsReadUseCase error');,;
      ),
    loading: () => throw UnimplementedError('GetNotificationsUseCase loading');,;
    error: (_, __) => throw UnimplementedError('GetNotificationsUseCase error');,;
});
