/// Profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info_card.dart';

/// Screen displaying user profile.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

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
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
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
                'Error loading profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref.read(profileNotifierProvider.notifier).refresh();
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

