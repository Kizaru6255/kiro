/// Mark as read use case (domain layer).
library;

import '../repositories/notification_repository.dart';
import '../../../../core/errors/errors.dart';

/// Use case for marking notification as read.
class MarkAsReadUseCase {
  final NotificationRepository _repository;

  MarkAsReadUseCase(this._repository);

  /// Execute mark as read.
  Future<Result<void>> call(String notificationId) async {
    if (notificationId.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'Notification ID cannot be empty'),
      );
    }

    return await _repository.markAsRead(notificationId);
  }
}


