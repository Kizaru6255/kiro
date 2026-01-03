/// Map screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../providers/location_provider.dart';

/// Screen displaying map with current location.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: locationAsync.when(
        data: (location) => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: const InfoWindow(title: 'Your Location'),
            ),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

