/// Tracking repository interface (domain layer).
library;

import '../entities/location_entity.dart';
import '../entities/tracking_session_entity.dart';
import '../../core/errors/errors.dart';

/// Tracking repository interface.
abstract class TrackingRepository {
  /// Get current location.
  Future<Result<LocationEntity>> getCurrentLocation();

  /// Start tracking session.
  Future<Result<TrackingSessionEntity>> startTracking();

  /// Stop tracking session.
  Future<Result<TrackingSessionEntity>> stopTracking(String sessionId);

  /// Get tracking session.
  Future<Result<TrackingSessionEntity>> getTrackingSession(String sessionId);

  /// Get all tracking sessions.
  Future<Result<List<TrackingSessionEntity>>> getTrackingSessions();
}


