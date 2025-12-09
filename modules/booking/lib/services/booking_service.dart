/// Booking service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/booking.dart';

/// Service for booking operations.
class BookingService {
  final DioClient _dioClient;

  BookingService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get all bookings for current user.
  Future<Result<List<Booking>>> getBookings({
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }
      if (status != null) {
        queryParams['status'] = status.name;
      }

      final response = await _dioClient.get<Map<String, dynamic>>(
        '/bookings',
        queryParameters: queryParams,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final bookings = (data['bookings'] as List)
              .map((json) => Booking.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.success(bookings);
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
        Failure.network(message: 'Failed to get bookings: $e'),
      );
    }
  }

  /// Get booking by ID.
  Future<Result<Booking>> getBooking(String bookingId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/bookings/$bookingId',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final booking = Booking.fromJson(
            data['booking'] as Map<String, dynamic>,
          );
          return Result.success(booking);
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
        Failure.network(message: 'Failed to get booking: $e'),
      );
    }
  }

  /// Create a new booking.
  Future<Result<Booking>> createBooking({
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? location,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/bookings',
        data: {
          'service_id': serviceId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
          if (notes != null) 'notes': notes,
          if (location != null) 'location': location,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final booking = Booking.fromJson(
            data['booking'] as Map<String, dynamic>,
          );
          return Result.success(booking);
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
        Failure.network(message: 'Failed to create booking: $e'),
      );
    }
  }

  /// Cancel a booking.
  Future<Result<Booking>> cancelBooking(String bookingId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/bookings/$bookingId/cancel',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final booking = Booking.fromJson(
            data['booking'] as Map<String, dynamic>,
          );
          return Result.success(booking);
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
        Failure.network(message: 'Failed to cancel booking: $e'),
      );
    }
  }

  /// Reschedule a booking.
  Future<Result<Booking>> rescheduleBooking({
    required String bookingId,
    required DateTime newStartTime,
    required DateTime newEndTime,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/bookings/$bookingId/reschedule',
        data: {
          'start_time': newStartTime.toIso8601String(),
          'end_time': newEndTime.toIso8601String(),
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final booking = Booking.fromJson(
            data['booking'] as Map<String, dynamic>,
          );
          return Result.success(booking);
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
        Failure.network(message: 'Failed to reschedule booking: $e'),
      );
    }
  }
}

