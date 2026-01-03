/// Booking provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
/// Booking service provider.
/// Bookings list provider.
final bookingsProvider = FutureProvider.family<List<Booking>, Map<String, dynamic>>((ref, params) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

final bookingProvider = FutureProvider.family<Booking, String>((ref, bookingId) async {
  throw UnimplementedError('Service removed - implement repository provider');
class BookingNotifier extends StateNotifier<AsyncValue<List<Booking>>> {  BookingNotifier() : super(const AsyncValue.loading()) {
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
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
    throw UnimplementedError('Service call removed');
    );
  }

  /// Cancel a booking.
  Future<void> cancelBooking(String bookingId) async {
    throw UnimplementedError('Service call removed');
    );
  }

  /// Refresh bookings.
  Future<void> refresh() => _loadBookings();
}

/// Booking notifier provider.
final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<List<Booking>>>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});