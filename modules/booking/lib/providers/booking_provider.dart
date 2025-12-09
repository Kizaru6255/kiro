/// Booking provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
import '../services/booking_service.dart';

/// Booking service provider.
final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService();
});

/// Bookings list provider.
final bookingsProvider = FutureProvider.family<List<Booking>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(bookingServiceProvider);
  final result = await service.getBookings(
    startDate: params['startDate'] as DateTime?,
    endDate: params['endDate'] as DateTime?,
    status: params['status'] as BookingStatus?,
  );
  return result.fold(
    onSuccess: (bookings) => bookings,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Single booking provider.
final bookingProvider = FutureProvider.family<Booking, String>((ref, bookingId) async {
  final service = ref.watch(bookingServiceProvider);
  final result = await service.getBooking(bookingId);
  return result.fold(
    onSuccess: (booking) => booking,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Booking notifier.
class BookingNotifier extends StateNotifier<AsyncValue<List<Booking>>> {
  final BookingService _bookingService;

  BookingNotifier(this._bookingService) : super(const AsyncValue.loading()) {
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    state = const AsyncValue.loading();
    final result = await _bookingService.getBookings();
    result.fold(
      onSuccess: (bookings) => state = AsyncValue.data(bookings),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Create a booking.
  Future<void> createBooking({
    required String serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? location,
  }) async {
    final result = await _bookingService.createBooking(
      serviceId: serviceId,
      startTime: startTime,
      endTime: endTime,
      notes: notes,
      location: location,
    );

    result.fold(
      onSuccess: (_) => _loadBookings(),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Cancel a booking.
  Future<void> cancelBooking(String bookingId) async {
    final result = await _bookingService.cancelBooking(bookingId);
    result.fold(
      onSuccess: (_) => _loadBookings(),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Refresh bookings.
  Future<void> refresh() => _loadBookings();
}

/// Booking notifier provider.
final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<List<Booking>>>((ref) {
  final service = ref.watch(bookingServiceProvider);
  return BookingNotifier(service);
});

