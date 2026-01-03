/// Profile info card widget.
library;

import 'package:flutter/material.dart';

import '../../domain/entities/user_profile_entity.dart';

/// Card displaying profile information.
class ProfileInfoCard extends StatelessWidget {
  final UserProfileEntity profile;

  const ProfileInfoCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (profile.email.isNotEmpty)
              _buildInfoRow(context, Icons.email, 'Email', profile.email),
            if (profile.phoneNumber != null)
              _buildInfoRow(
                context,
                Icons.phone,
                'Phone',
                profile.phoneNumber!,
              ),
            if (profile.address != null) ...[
              const SizedBox(height: 16),
              Text(
                'Address',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.location_on,
                'Address',
                profile.address!,
              ),
              if (profile.city != null)
                _buildInfoRow(context, Icons.location_city, 'City', profile.city!),
              if (profile.state != null)
                _buildInfoRow(context, Icons.map, 'State', profile.state!),
              if (profile.country != null)
                _buildInfoRow(
                  context,
                  Icons.public,
                  'Country',
                  profile.country!,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

