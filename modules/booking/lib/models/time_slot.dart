/// Time slot model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/time_slot_entity.dart' as entity;

part 'time_slot.freezed.dart';
part 'time_slot.g.dart';

/// Time slot availability.
enum SlotAvailability {
  available,
  booked,
  unavailable,
}

/// Time slot model.
@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required DateTime startTime,
    required DateTime endTime,
    @Default(SlotAvailability.available) SlotAvailability availability,
    String? bookingId,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}

/// Time slot extensions.
extension TimeSlotExtension on TimeSlot {
  /// Duration of slot.
  Duration get duration => endTime.difference(startTime);

  /// Check if slot is available.
  bool get isAvailable => availability == SlotAvailability.available;

  /// Check if slot is booked.
  bool get isBooked => availability == SlotAvailability.booked;

  /// Formatted time range.
  String get formattedTimeRange {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Convert to TimeSlotEntity.
  entity.TimeSlotEntity toEntity() {
    final entityAvailability = switch (availability) {
      SlotAvailability.available => entity.SlotAvailability.available,
      SlotAvailability.booked => entity.SlotAvailability.booked,
      SlotAvailability.unavailable => entity.SlotAvailability.unavailable,
    };
    
    return entity.TimeSlotEntity(
      startTime: startTime,
      endTime: endTime,
      availability: entityAvailability,
      bookingId: bookingId,
    );
  }
}

