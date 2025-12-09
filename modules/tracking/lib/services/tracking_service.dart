/// Tracking service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/tracking_session.dart';

/// Service for tracking operations.
class TrackingService {
  final DioClient _dioClient;

  TrackingService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Start tracking session.
  Future<Result<TrackingSession>> startSession() async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/tracking/sessions',
        data: {},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final session = TrackingSession.fromJson(
            data['session'] as Map<String, dynamic>,
          );
          return Result.success(session);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to start tracking session: $e'),
      );
    }
  }

  /// Stop tracking session.
  Future<Result<TrackingSession>> stopSession(String sessionId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/tracking/sessions/$sessionId/stop',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final session = TrackingSession.fromJson(
            data['session'] as Map<String, dynamic>,
          );
          return Result.success(session);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to stop tracking session: $e'),
      );
    }
  }
}

