/// Tracking session entity (domain layer).
library;

import 'location_entity.dart';

/// Tracking session entity.
class TrackingSessionEntity {
  final String id;
  final String userId;
  final List<LocationEntity> locations;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistance;
  final double averageSpeed;
  final Map<String, dynamic>? metadata;

  const TrackingSessionEntity({
    required this.id,
    required this.userId,
    required this.locations,
    required this.startTime,
    this.endTime,
    this.totalDistance = 0.0,
    this.averageSpeed = 0.0,
    this.metadata,
  });

  /// Duration of session.
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Check if session is active.
  bool get isActive => endTime == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


