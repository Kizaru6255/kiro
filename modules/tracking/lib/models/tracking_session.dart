/// Tracking session model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'location.dart';

part 'tracking_session.freezed.dart';
part 'tracking_session.g.dart';

/// Tracking session model.
@freezed
class TrackingSession with _$TrackingSession {
  const factory TrackingSession({
    required String id,
    required String userId,
    required List<Location> locations,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0.0) double totalDistance,
    @Default(0.0) double averageSpeed,
    Map<String, dynamic>? metadata,
  }) = _TrackingSession;

  factory TrackingSession.fromJson(Map<String, dynamic> json) =>
      _$TrackingSessionFromJson(json);
}

/// Tracking session extensions.
extension TrackingSessionExtension on TrackingSession {
  /// Duration of session.
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Check if session is active.
  bool get isActive => endTime == null;

  /// Formatted duration.
  String get formattedDuration {
    final d = duration;
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m';
    }
    return '${d.inMinutes}m';
  }
}

