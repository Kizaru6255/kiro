/// Booking entity (domain layer).
library;

/// Booking status.
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  noShow,
}

/// Booking entity.
class BookingEntity {
  final String id;
  final String userId;
  final String serviceId;
  final String? serviceName;
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final String? notes;
  final String? location;
  final double? price;
  final String? currency;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.serviceName,
    required this.startTime,
    required this.endTime,
    this.status = BookingStatus.pending,
    this.notes,
    this.location,
    this.price,
    this.currency,
    this.cancelledAt,
    this.cancelledBy,
    this.createdAt,
    this.metadata,
  });

  /// Duration of booking.
  Duration get duration => endTime.difference(startTime);

  /// Check if booking is confirmed.
  bool get isConfirmed => status == BookingStatus.confirmed;

  /// Check if booking is cancelled.
  bool get isCancelled => status == BookingStatus.cancelled;

  /// Check if booking is completed.
  bool get isCompleted => status == BookingStatus.completed;

  /// Formatted date string.
  String get formattedDate {
    final date = startTime;
    return '${date.day}/${date.month}/${date.year}';
  }

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
      other is BookingEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

