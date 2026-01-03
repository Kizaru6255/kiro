/// Booking repository interface (domain layer).
library;

import '../entities/booking_entity.dart';
import '../entities/time_slot_entity.dart';
import '../../../../core/errors/errors.dart';

/// Booking repository interface.
abstract class BookingRepository {
  /// Get all bookings for current user.
  Future<Result<List<BookingEntity>>> getBookings({
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
  });

  /// Get booking by ID.
  Future<Result<BookingEntity>> getBooking(String bookingId);

  /// Create booking.
  Future<Result<BookingEntity>> createBooking({
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? location,
  });

  /// Cancel booking.
  Future<Result<void>> cancelBooking(String bookingId, String? reason);

  /// Get available time slots.
  Future<Result<List<TimeSlotEntity>>> getAvailableTimeSlots({
    required DateTime date,
    String? serviceId,
  });
}


