/// Booking model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// Booking status.
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  noShow,
}

/// Booking model.
@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String serviceId,
    String? serviceName,
    required DateTime startTime,
    required DateTime endTime,
    @Default(BookingStatus.pending) BookingStatus status,
    String? notes,
    String? location,
    double? price,
    String? currency,
    DateTime? cancelledAt,
    String? cancelledBy,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

/// Booking extensions.
extension BookingExtension on Booking {
  /// Duration of booking.
  Duration get duration => endTime.difference(startTime);

  /// Check if booking is confirmed.
  bool get isConfirmed => status == BookingStatus.confirmed;

  /// Check if booking is cancelled.
  bool get isCancelled => status == BookingStatus.cancelled;

  /// Check if booking is completed.
  bool get isCompleted => status == BookingStatus.completed;

  /// Check if booking is pending.
  bool get isPending => status == BookingStatus.pending;

  /// Check if booking is upcoming.
  bool get isUpcoming => startTime.isAfter(DateTime.now()) && isConfirmed;

  /// Check if booking is past.
  bool get isPast => endTime.isBefore(DateTime.now());

  /// Formatted date string.
  String get formattedDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }

  /// Formatted time range.
  String get formattedTimeRange {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

