/// Blueprint manager for project templates.
library;

import '../config/app_config.dart';
import '../utils/console.dart';
import 'project_generator.dart';

/// Manages project blueprints (pre-configured templates).
class BlueprintManager {
  /// Available blueprints.
  static const Map<String, Blueprint> blueprints = {
    'ecommerce': Blueprint(
      name: 'ecommerce',
      displayName: 'E-Commerce',
      description: 'Complete e-commerce app with products, cart, payments',
      modules: ['auth', 'payments', 'profile', 'notifications'],
      config: {
        'primary_color': '#FF6B35',
        'use_firebase': true,
      },
    ),
    'fintech': Blueprint(
      name: 'fintech',
      displayName: 'FinTech',
      description: 'Financial app with wallet, transactions, payments',
      modules: ['auth', 'wallet', 'payments', 'notifications', 'profile'],
      config: {
        'primary_color': '#1E88E5',
        'use_firebase': true,
      },
    ),
    'saas': Blueprint(
      name: 'saas',
      displayName: 'SaaS',
      description: 'SaaS app with auth, subscriptions, dashboard',
      modules: ['auth', 'profile', 'notifications', 'payments'],
      config: {
        'primary_color': '#6366F1',
        'use_firebase': true,
      },
    ),
    'social': Blueprint(
      name: 'social',
      displayName: 'Social Media',
      description: 'Social app with chat, profile, notifications',
      modules: ['auth', 'chat', 'profile', 'notifications'],
      config: {
        'primary_color': '#8B5CF6',
        'use_firebase': true,
      },
    ),
    'healthcare': Blueprint(
      name: 'healthcare',
      displayName: 'Healthcare',
      description: 'Healthcare app with booking, tracking, notifications',
      modules: ['auth', 'booking', 'tracking', 'notifications', 'profile'],
      config: {
        'primary_color': '#10B981',
        'use_firebase': true,
      },
    ),
  };

  /// Get blueprint by name.
  static Blueprint? getBlueprint(String name) {
    return blueprints[name.toLowerCase()];
  }

  /// List all available blueprints.
  static List<Blueprint> listBlueprints() {
    return blueprints.values.toList();
  }

  /// Generate app from blueprint.
  static Future<bool> generateFromBlueprint({
    required String blueprintName,
    required AppConfig baseConfig,
  }) async {
    final blueprint = getBlueprint(blueprintName);
    if (blueprint == null) {
      Console.error('Unknown blueprint: $blueprintName');
      Console.info('Available blueprints:');
      for (final bp in listBlueprints()) {
        Console.listItem('${bp.name} - ${bp.displayName}');
      }
      return false;
    }

    Console.header('Generating ${blueprint.displayName} App');
    Console.info(blueprint.description);
    Console.blank();

    // Create config from blueprint
    final blueprintConfig = AppConfig(
      appName: baseConfig.appName,
      packageName: baseConfig.packageName,
      description: blueprint.description,
      organization: baseConfig.organization,
      platforms: baseConfig.platforms,
      modules: blueprint.modules
          .map((m) => KiroModule.values.firstWhere(
                (mod) => mod.name == m,
                orElse: () => KiroModule.auth,
              ))
          .toList(),
      stateManagement: baseConfig.stateManagement,
      primaryColor: blueprint.config['primary_color'] as String? ?? baseConfig.primaryColor,
      useFirebase: blueprint.config['use_firebase'] as bool? ?? baseConfig.useFirebase,
      initGit: baseConfig.initGit,
      outputDirectory: baseConfig.outputDirectory,
      locales: baseConfig.locales,
      defaultLocale: baseConfig.defaultLocale,
    );

    final generator = ProjectGenerator(blueprintConfig);
    final success = await generator.generate();

    if (success) {
      Console.blank();
      Console.success('${blueprint.displayName} app generated successfully!');
      Console.blank();
      Console.info('Blueprint includes:');
      for (final module in blueprint.modules) {
        Console.listItem('• $module module');
      }
      Console.blank();
    }

    return success;
  }
}

/// Project blueprint definition.
class Blueprint {
  final String name;
  final String displayName;
  final String description;
  final List<String> modules;
  final Map<String, dynamic> config;

  const Blueprint({
    required this.name,
    required this.displayName,
    required this.description,
    required this.modules,
    this.config = const {},
  });
}

