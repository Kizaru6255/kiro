/// Profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info_card.dart';

/// Screen displaying user profile.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: profileAsync.maybeWhen(
        loaded: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              ProfileAvatar(
                photoUrl: profile.photoUrl,
                initials: profile.initials,
                size: 100,
              ),
              const SizedBox(height: 16),
              Text(
                profile.fullName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (profile.bio != null) ...[
                const SizedBox(height: 8),
                Text(
                  profile.bio!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ProfileInfoCard(profile: profile),
            ],
          ),
        ),
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

