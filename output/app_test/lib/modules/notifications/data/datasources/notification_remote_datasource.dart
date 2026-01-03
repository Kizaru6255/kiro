/// Notification remote data source.
library;

import 'package:dio/dio.dart';

/// Remote data source for notifications.
abstract class NotificationRemoteDataSource {
  /// Get all notifications.
  Future<Response<Map<String, dynamic>>> getNotifications();

  /// Mark notification as read.
  Future<Response<void>> markAsRead(String notificationId);

  /// Mark all as read.
  Future<Response<void>> markAllAsRead();
}

/// Implementation of notification remote data source.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<Response<Map<String, dynamic>>> getNotifications() async {
    return await _dio.get<Map<String, dynamic>>(
      '/notifications',
    );
  }

  @override
  Future<Response<void>> markAsRead(String notificationId) async {
    return await _dio.post<void>(
      '/notifications/$notificationId/read',
    );
  }

  @override
  Future<Response<void>> markAllAsRead() async {
    return await _dio.post<void>(
      '/notifications/read-all',
    );
  }
}
