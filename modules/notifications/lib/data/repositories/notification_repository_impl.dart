/// Notification repository implementation (data layer).
library;

import 'package:dio/dio.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/errors/errors.dart';
import '../datasources/notification_remote_datasource.dart';
import '../datasources/notification_local_datasource.dart';
import '../models/notification_dto.dart';

/// Implementation of notification repository.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NotificationLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<List<NotificationEntity>>> getNotifications() async {
    try {
      final response = await _remoteDataSource.getNotifications();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final notifications = (data['notifications'] as List)
            .map((json) => NotificationDto.fromJson(
                json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();

        // Cache notifications
        _localDataSource.cacheNotifications(
          (data['notifications'] as List).cast<Map<String, dynamic>>(),
        );

        return Result.success(notifications);
      } else {
        // Try cache on network failure
        return _getFromCache();
      }
    } on DioException {
      return _getFromCache();
    } catch (_) {
      return _getFromCache();
    }
  }

  Future<Result<List<NotificationEntity>>> _getFromCache() async {
    try {
      final cached = await _localDataSource.getCachedNotifications();
      if (cached != null) {
        final notifications = cached
            .map((json) => NotificationDto.fromJson(json))
            .map((dto) => dto.toEntity())
            .toList();
        return Result.success(notifications);
      }
      return Result.failure(
        Failure.network(message: 'No cached notifications available'),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get notifications: $e'),
      );
    }
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      final response = await _remoteDataSource.markAsRead(notificationId);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Result.success(null);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to mark notification as read: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to mark notification as read',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to mark notification as read: $e'),
      );
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      final response = await _remoteDataSource.markAllAsRead();

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Result.success(null);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to mark all as read: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to mark all as read',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to mark all as read: $e'),
      );
    }
  }
}
