/// Location card widget.
library;

import 'package:flutter/material.dart';

import '../models/location.dart';

/// Card displaying location information.
class LocationCard extends StatelessWidget {
  final Location location;

  const LocationCard({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Latitude',
              location.latitude.toStringAsFixed(6),
            ),
            _buildInfoRow(
              context,
              'Longitude',
              location.longitude.toStringAsFixed(6),
            ),
            if (location.altitude != null)
              _buildInfoRow(
                context,
                'Altitude',
                '${location.altitude!.toStringAsFixed(2)} m',
              ),
            if (location.accuracy != null)
              _buildInfoRow(
                context,
                'Accuracy',
                '${location.accuracy!.toStringAsFixed(2)} m',
              ),
            if (location.speed != null)
              _buildInfoRow(
                context,
                'Speed',
                '${location.speed!.toStringAsFixed(2)} m/s',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

