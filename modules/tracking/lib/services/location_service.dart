/// Location service.
library;

import 'package:geolocator/geolocator.dart';
import 'package:kiro_core/kiro_core.dart';

import '../models/location.dart';

/// Service for location operations.
class LocationService {
  /// Get current location.
  Future<Result<Location>> getCurrentLocation() async {
    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Result.failure(
          Failure.network(message: 'Location services are disabled'),
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Result.failure(
            Failure.network(message: 'Location permissions are denied'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Result.failure(
          Failure.network(
            message: 'Location permissions are permanently denied',
          ),
        );
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        speed: position.speed,
        timestamp: position.timestamp,
      );

      return Result.success(location);
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get location: $e'),
      );
    }
  }

  /// Stream location updates.
  Stream<Location> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    ).map((position) => Location(
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          accuracy: position.accuracy,
          speed: position.speed,
          timestamp: position.timestamp,
        ));
  }
}

