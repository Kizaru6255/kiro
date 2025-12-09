/// Time slot service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/time_slot.dart';

/// Service for time slot operations.
class TimeSlotService {
  final DioClient _dioClient;

  TimeSlotService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get available time slots for a date.
  Future<Result<List<TimeSlot>>> getAvailableSlots({
    required String serviceId,
    required DateTime date,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/services/$serviceId/time-slots',
        queryParameters: {
          'date': date.toIso8601String(),
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final slots = (data['time_slots'] as List)
              .map((json) => TimeSlot.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.success(slots);
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
        Failure.network(message: 'Failed to get time slots: $e'),
      );
    }
  }
}

