/// Booking repository implementation (data layer).
library;

import 'package:dio/dio.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../core/errors/errors.dart';
import '../datasources/booking_remote_datasource.dart';
import '../datasources/booking_local_datasource.dart';
import '../models/booking_dto.dart';
import '../models/time_slot_dto.dart';

/// Implementation of booking repository.
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;
  final BookingLocalDataSource _localDataSource;

  BookingRepositoryImpl({
    required BookingRemoteDataSource remoteDataSource,
    required BookingLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<List<BookingEntity>>> getBookings({
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
  }) async {
    try {
      final response = await _remoteDataSource.getBookings(
        startDate: startDate,
        endDate: endDate,
        status: status?.name,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final bookings = (data['bookings'] as List)
            .map((json) => BookingDto.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();

        // Cache bookings
        _localDataSource.cacheBookings(
          (data['bookings'] as List).cast<Map<String, dynamic>>(),
        );

        return Result.success(bookings);
      } else {
        return _getFromCache();
      }
    } on DioException {
      return _getFromCache();
    } catch (_) {
      return _getFromCache();
    }
  }

  Future<Result<List<BookingEntity>>> _getFromCache() async {
    try {
      final cached = await _localDataSource.getCachedBookings();
      if (cached != null) {
        final bookings = cached
            .map((json) => BookingDto.fromJson(json))
            .map((dto) => dto.toEntity())
            .toList();
        return Result.success(bookings);
      }
      return Result.failure(
        Failure.network(message: 'No cached bookings available'),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get bookings: $e'),
      );
    }
  }

  @override
  Future<Result<BookingEntity>> getBooking(String bookingId) async {
    try {
      final response = await _remoteDataSource.getBooking(bookingId);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final dto = BookingDto.fromJson(
          data['booking'] as Map<String, dynamic>,
        );
        return Result.success(dto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get booking: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get booking',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get booking: $e'),
      );
    }
  }

  @override
  Future<Result<BookingEntity>> createBooking({
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? location,
  }) async {
    try {
      final data = {
        'service_id': serviceId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        if (notes != null) 'notes': notes,
        if (location != null) 'location': location,
      };

      final response = await _remoteDataSource.createBooking(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final dto = BookingDto.fromJson(
            responseData['booking'] as Map<String, dynamic>,
          );
          return Result.success(dto.toEntity());
        }
      }
      return Result.failure(
        Failure.network(
          message: 'Failed to create booking: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to create booking',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to create booking: $e'),
      );
    }
  }

  @override
  Future<Result<void>> cancelBooking(String bookingId, String? reason) async {
    try {
      final response = await _remoteDataSource.cancelBooking(bookingId, reason);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Result.success(null);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to cancel booking: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to cancel booking',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to cancel booking: $e'),
      );
    }
  }

  @override
  Future<Result<List<TimeSlotEntity>>> getAvailableTimeSlots({
    required DateTime date,
    String? serviceId,
  }) async {
    try {
      final response = await _remoteDataSource.getAvailableTimeSlots(
        date: date,
        serviceId: serviceId,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final slots = (data['time_slots'] as List)
            .map((json) => TimeSlotDto.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();
        return Result.success(slots);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get time slots: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get time slots',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get time slots: $e'),
      );
    }
  }
}
