/// Tracking screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/location_provider.dart';
import '../widgets/location_card.dart';

/// Screen for location tracking.
class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.push('/tracking/map'),
          ),
        ],
      ),
      body: locationAsync.when(
        data: (location) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LocationCard(location: location),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref.invalidate(currentLocationProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Location'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Location Error',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref.invalidate(currentLocationProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

