/// Location provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location.dart';
import '../services/location_service.dart';

/// Location service provider.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Current location provider.
final currentLocationProvider =
    FutureProvider<Location>((ref) async {
  final service = ref.watch(locationServiceProvider);
  final result = await service.getCurrentLocation();
  return result.fold(
    onSuccess: (location) => location,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Location stream provider.
final locationStreamProvider = StreamProvider<Location>((ref) {
  final service = ref.watch(locationServiceProvider);
  return service.getLocationStream();
});

