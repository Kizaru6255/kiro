/// Get bookings use case (domain layer).
library;

import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import '../../../../core/errors/errors.dart';

/// Use case for getting bookings.
class GetBookingsUseCase {
  final BookingRepository _repository;

  GetBookingsUseCase(this._repository);

  /// Execute get bookings.
  Future<Result<List<BookingEntity>>> call({
    DateTime? startDate,
    DateTime? endDate,
    BookingStatus? status,
  }) async {
    return await _repository.getBookings(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }
}


