/// Location model.
library;

import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/location_entity.dart';

part 'location.freezed.dart';
part 'location.g.dart';

/// Location model.
@freezed
class Location with _$Location {
  const factory Location({
    required double latitude,
    required double longitude,
    double? altitude,
    double? accuracy,
    double? speed,
    DateTime? timestamp,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

/// Location extensions.
extension LocationExtension on Location {
  /// Get distance to another location in meters.
  double distanceTo(Location other) {
    const double earthRadius = 6371000; // meters
    final lat1Rad = latitude * (math.pi / 180);
    final lat2Rad = other.latitude * (math.pi / 180);
    final deltaLat = (other.latitude - latitude) * (math.pi / 180);
    final deltaLon = (other.longitude - longitude) * (math.pi / 180);

    final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Formatted coordinates string.
  String get formattedCoordinates => '$latitude, $longitude';

  /// Convert to LocationEntity.
  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      accuracy: accuracy,
      speed: speed,
      timestamp: timestamp,
    );
  }
}

