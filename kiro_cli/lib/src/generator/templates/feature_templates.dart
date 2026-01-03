/// Feature folder templates.
library;

/// Generate home_screen.dart.
String generateHomeScreen({
  required String appName,
  required List<String> modules,
  required bool hasNotifications,
}) {
  final notificationAction = hasNotifications
      ? '''
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            context.push(AppRoutes.notifications);
          },
        ),'''
      : '';
  
  return '''/// Home screen.
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
        title: Text('$appName'),
        actions: [
$notificationAction
        ],
      ),
      body: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Welcome',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your personalized dashboard',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          // Quick actions or content area
          // This is where you can add your app-specific content
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.rocket_launch,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get Started',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start exploring the features of $appName',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
''';
}

/// Generate feature barrel file.
String generateFeatureBarrel({required String featureName}) => '''
/// ${_capitalize(featureName)} feature.
library;

export 'data/data.dart';
export 'presentation/presentation.dart';
''';

/// Generate data barrel.
String generateDataBarrel() => '''
/// Data layer.
library;

export 'models/models.dart';
export 'repositories/repositories.dart';
''';

/// Generate presentation barrel.
String generatePresentationBarrel() => '''
/// Presentation layer.
library;

export 'screens/screens.dart';
export 'widgets/widgets.dart';
''';

/// Generate models barrel.
String generateModelsBarrel() => '''
/// Data models.
library;

// Export models here
''';

/// Generate repositories barrel.
String generateRepositoriesBarrel() => '''
/// Repositories.
library;

// Export repositories here
''';

/// Generate screens barrel.
String generateScreensBarrel() => '''
/// Screens.
library;

// Export screens here
''';

/// Generate widgets barrel.
String generateWidgetsBarrel() => '''
/// Widgets.
library;

// Export widgets here
''';

String _capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}


