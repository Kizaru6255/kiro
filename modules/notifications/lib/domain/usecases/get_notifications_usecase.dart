/// Get notifications use case (domain layer).
library;

import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for getting all notifications.
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  /// Execute get notifications.
  Future<Result<List<NotificationEntity>>> call() async {
    return await _repository.getNotifications();
  }
}


