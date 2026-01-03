/// Booking remote data source.
library;

import 'package:dio/dio.dart';

/// Remote data source for booking operations.
abstract class BookingRemoteDataSource {
  /// Get all bookings.
  Future<Response<Map<String, dynamic>>> getBookings({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  });

  /// Get booking by ID.
  Future<Response<Map<String, dynamic>>> getBooking(String bookingId);

  /// Create booking.
  Future<Response<Map<String, dynamic>>> createBooking(
    Map<String, dynamic> data,
  );

  /// Cancel booking.
  Future<Response<void>> cancelBooking(String bookingId, String? reason);

  /// Get available time slots.
  Future<Response<Map<String, dynamic>>> getAvailableTimeSlots({
    required DateTime date,
    String? serviceId,
  });
}

/// Implementation of booking remote data source.
class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio _dio;

  BookingRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<Response<Map<String, dynamic>>> getBookings({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }
    if (status != null) {
      queryParams['status'] = status;
    }

    return await _dio.get<Map<String, dynamic>>(
      '/bookings',
      queryParameters: queryParams,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> getBooking(String bookingId) async {
    return await _dio.get<Map<String, dynamic>>(
      '/bookings/$bookingId',
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> createBooking(
    Map<String, dynamic> data,
  ) async {
    return await _dio.post<Map<String, dynamic>>(
      '/bookings',
      data: data,
    );
  }

  @override
  Future<Response<void>> cancelBooking(String bookingId, String? reason) async {
    return await _dio.post<void>(
      '/bookings/$bookingId/cancel',
      data: {'reason': reason},
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> getAvailableTimeSlots({
    required DateTime date,
    String? serviceId,
  }) async {
    final queryParams = <String, dynamic>{
      'date': date.toIso8601String(),
    };
    if (serviceId != null) {
      queryParams['service_id'] = serviceId;
    }

    return await _dio.get<Map<String, dynamic>>(
      '/bookings/time-slots',
      queryParameters: queryParams,
    );
  }
}
