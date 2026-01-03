/// Booking state model (presentation layer).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/time_slot_entity.dart';

part 'booking_state.freezed.dart';

/// Booking state.
@freezed
class BookingState with _$BookingState {
  /// Initial state.
  const factory BookingState.initial() = _Initial;

  /// Loading state.
  const factory BookingState.loading() = _Loading;

  /// Loaded state with bookings.
  const factory BookingState.loaded(List<BookingEntity> bookings) = _Loaded;

  /// Error state.
  const factory BookingState.error(String message) = _Error;
}

/// Time slot state.
@freezed
class TimeSlotState with _$TimeSlotState {
  /// Initial state.
  const factory TimeSlotState.initial() = _TimeSlotInitial;

  /// Loading state.
  const factory TimeSlotState.loading() = _TimeSlotLoading;

  /// Loaded state with time slots.
  const factory TimeSlotState.loaded(List<TimeSlotEntity> timeSlots) =
      _TimeSlotLoaded;

  /// Error state.
  const factory TimeSlotState.error(String message) = _TimeSlotError;
}

/// Booking state extensions.
extension BookingStateExtension on BookingState {
  /// Whether state is loading.
  bool get isLoading => this is _Loading;

  /// Get bookings if loaded.
  List<BookingEntity>? get bookings => maybeWhen(
        loaded: (bookings) => bookings,
        orElse: () => null,
      );

  /// Get error message if error.
  String? get errorMessage => maybeWhen(
        error: (message) => message,
        orElse: () => null,
      );
}


