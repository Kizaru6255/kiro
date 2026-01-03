/// Time slot entity (domain layer).
library;

/// Time slot availability.
enum SlotAvailability {
  available,
  booked,
  unavailable,
}

/// Time slot entity.
class TimeSlotEntity {
  final DateTime startTime;
  final DateTime endTime;
  final SlotAvailability availability;
  final String? bookingId;

  const TimeSlotEntity({
    required this.startTime,
    required this.endTime,
    this.availability = SlotAvailability.available,
    this.bookingId,
  });

  /// Duration of slot.
  Duration get duration => endTime.difference(startTime);

  /// Check if slot is available.
  bool get isAvailable => availability == SlotAvailability.available;

  /// Check if slot is booked.
  bool get isBooked => availability == SlotAvailability.booked;

  /// Formatted time range string.
  String get formattedTimeRange {
    final start = startTime;
    final end = endTime;
    final startTimeStr = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endTimeStr = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startTimeStr - $endTimeStr';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotEntity &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => Object.hash(startTime, endTime);
}

