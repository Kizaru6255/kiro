/// Location entity (domain layer).
library;

/// Location entity.
class LocationEntity {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  final DateTime? timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.speed,
    this.timestamp,
  });

  /// Get distance to another location in meters.
  double distanceTo(LocationEntity other) {
    const double earthRadius = 6371000; // meters
    final lat1Rad = latitude * (3.14159265359 / 180);
    final lat2Rad = other.latitude * (3.14159265359 / 180);
    final deltaLat = (other.latitude - latitude) * (3.14159265359 / 180);
    final deltaLon = (other.longitude - longitude) * (3.14159265359 / 180);

    final a = (deltaLat / 2).sin() * (deltaLat / 2).sin() +
        lat1Rad.cos() *
            lat2Rad.cos() *
            (deltaLon / 2).sin() *
            (deltaLon / 2).sin();
    final c = 2 * (a.sqrt()).atan2((1 - a).sqrt());

    return earthRadius * c;
  }

  /// Formatted coordinates string.
  String get formattedCoordinates => '$latitude, $longitude';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntity &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

extension _MathExtensions on double {
  double sin() => this; // Placeholder - use dart:math in actual implementation
  double cos() => this; // Placeholder
  double sqrt() => this; // Placeholder
  double atan2(double other) => this; // Placeholder
}


