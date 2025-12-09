/// Feature folder templates.
library;

/// Generate home_screen.dart.
String generateHomeScreen({
  required String appName,
  required List<String> modules,
}) {
  final moduleCards = StringBuffer();
  final imports = StringBuffer();
  
  imports.writeln("import 'package:flutter/material.dart';");
  imports.writeln("import 'package:go_router/go_router.dart';");
  imports.writeln();
  imports.writeln("import '../../config/router.dart';");
  
  // Generate module cards
  if (modules.contains('auth')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.login,');
    moduleCards.writeln('          title: \'Authentication\',');
    moduleCards.writeln('          description: \'Login, signup, and account management\',');
    moduleCards.writeln('          color: Colors.blue,');
    moduleCards.writeln('          onTap: () => context.push(AppRoutes.login),');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('wallet')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.account_balance_wallet,');
    moduleCards.writeln('          title: \'Wallet\',');
    moduleCards.writeln('          description: \'Manage your digital wallet\',');
    moduleCards.writeln('          color: Colors.green,');
    moduleCards.writeln('          onTap: () => context.push(AppRoutes.wallet),');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('profile')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.person,');
    moduleCards.writeln('          title: \'Profile\',');
    moduleCards.writeln('          description: \'View and edit your profile\',');
    moduleCards.writeln('          color: Colors.purple,');
    moduleCards.writeln('          onTap: () => context.push(AppRoutes.profile),');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('booking')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.calendar_today,');
    moduleCards.writeln('          title: \'Booking\',');
    moduleCards.writeln('          description: \'Create and manage bookings\',');
    moduleCards.writeln('          color: Colors.orange,');
    moduleCards.writeln('          onTap: () => context.push(AppRoutes.createBooking),');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('notifications')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.notifications,');
    moduleCards.writeln('          title: \'Notifications\',');
    moduleCards.writeln('          description: \'View your notifications\',');
    moduleCards.writeln('          color: Colors.red,');
    moduleCards.writeln('          onTap: () => context.push(AppRoutes.notifications),');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('chat')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.chat,');
    moduleCards.writeln('          title: \'Chat\',');
    moduleCards.writeln('          description: \'Real-time messaging\',');
    moduleCards.writeln('          color: Colors.teal,');
    moduleCards.writeln('          onTap: () {');
    moduleCards.writeln('            // Navigate to chat');
    moduleCards.writeln('          },');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('payments')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.payment,');
    moduleCards.writeln('          title: \'Payments\',');
    moduleCards.writeln('          description: \'Manage payments\',');
    moduleCards.writeln('          color: Colors.indigo,');
    moduleCards.writeln('          onTap: () {');
    moduleCards.writeln('            // Navigate to payments');
    moduleCards.writeln('          },');
    moduleCards.writeln('        ),');
  }
  
  if (modules.contains('tracking')) {
    moduleCards.writeln('        _ModuleCard(');
    moduleCards.writeln('          icon: Icons.location_on,');
    moduleCards.writeln('          title: \'Tracking\',');
    moduleCards.writeln('          description: \'GPS tracking and maps\',');
    moduleCards.writeln('          color: Colors.blueGrey,');
    moduleCards.writeln('          onTap: () {');
    moduleCards.writeln('            // Navigate to tracking');
    moduleCards.writeln('          },');
    moduleCards.writeln('        ),');
  }
  
  if (modules.isEmpty) {
    moduleCards.writeln('        const SizedBox(height: 24),');
    moduleCards.writeln('        Text(');
    moduleCards.writeln('          \'No modules enabled\',');
    moduleCards.writeln('          style: Theme.of(context).textTheme.bodyLarge?.copyWith(');
    moduleCards.writeln('            color: Theme.of(context).colorScheme.outline,');
    moduleCards.writeln('          ),');
    moduleCards.writeln('        ),');
  }
  
  return '''
/// Home screen.
library;

$imports
/// Main home screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$appName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: ${modules.isEmpty ? '_buildEmptyState(context)' : '_buildModuleGrid(context)'},
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
            'Welcome to $appName!',
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
$moduleCards
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

