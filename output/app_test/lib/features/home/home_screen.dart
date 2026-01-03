/// Home screen.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/router.dart';

/// Main home screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('app_test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: _buildModuleGrid(context),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rocket_launch,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to app_test!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by Kiro',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModuleGrid(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modules',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
        _ModuleCard(
          icon: Icons.login,
          title: 'Authentication',
          description: 'Login, signup, and account management',
          color: Colors.blue,
          onTap: () => context.push(AppRoutes.login),
        ),
        _ModuleCard(
          icon: Icons.account_balance_wallet,
          title: 'Wallet',
          description: 'Manage your digital wallet',
          color: Colors.green,
          onTap: () => context.push(AppRoutes.wallet),
        ),
        _ModuleCard(
          icon: Icons.person,
          title: 'Profile',
          description: 'View and edit your profile',
          color: Colors.purple,
          onTap: () => context.push(AppRoutes.profile),
        ),
        _ModuleCard(
          icon: Icons.calendar_today,
          title: 'Booking',
          description: 'Create and manage bookings',
          color: Colors.orange,
          onTap: () => context.push(AppRoutes.create_booking),
        ),
        _ModuleCard(
          icon: Icons.notifications,
          title: 'Notifications',
          description: 'View your notifications',
          color: Colors.red,
          onTap: () => context.push(AppRoutes.notifications),
        ),
        _ModuleCard(
          icon: Icons.chat,
          title: 'Chat',
          description: 'Real-time messaging',
          color: Colors.teal,
          onTap: () {
            // Navigate to chat
          },
        ),
        _ModuleCard(
          icon: Icons.payment,
          title: 'Payments',
          description: 'Manage payments',
          color: Colors.indigo,
          onTap: () {
            // Navigate to payments
          },
        ),
        _ModuleCard(
          icon: Icons.location_on,
          title: 'Tracking',
          description: 'GPS tracking and maps',
          color: Colors.blueGrey,
          onTap: () {
            // Navigate to tracking
          },
        ),

            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
