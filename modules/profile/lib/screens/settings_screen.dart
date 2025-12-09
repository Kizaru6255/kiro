/// Settings screen.
library;

import 'package:flutter/material.dart';

/// Screen for app settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('Change app language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: const Text('Light / Dark mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to theme settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Open terms of service
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
    );
  }
}

