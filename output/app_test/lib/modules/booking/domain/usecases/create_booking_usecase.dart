/// Create booking use case (domain layer).
library;

import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import '../../../../core/errors/errors.dart';

/// Use case for creating a booking.
class CreateBookingUseCase {
  final BookingRepository _repository;

  CreateBookingUseCase(this._repository);

  /// Execute create booking.
  Future<Result<BookingEntity>> call({
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? location,
  }) async {
    // Domain validation
    if (startTime.isBefore(DateTime.now())) {
      return Result.failure(
        Failure.validation(message: 'Start time cannot be in the past'),
      );
    }

    if (endTime.isBefore(startTime)) {
      return Result.failure(
        Failure.validation(message: 'End time must be after start time'),
      );
    }

    return await _repository.createBooking(
      serviceId: serviceId,
      startTime: startTime,
      endTime: endTime,
      notes: notes,
      location: location,
    );
  }
}


