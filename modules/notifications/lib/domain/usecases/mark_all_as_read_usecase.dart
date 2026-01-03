/// Mark all as read use case (domain layer).
library;

import '../repositories/notification_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for marking all notifications as read.
class MarkAllAsReadUseCase {
  final NotificationRepository _repository;

  MarkAllAsReadUseCase(this._repository);

  /// Execute mark all as read.
  Future<Result<void>> call() async {
    return await _repository.markAllAsRead();
  }
}


