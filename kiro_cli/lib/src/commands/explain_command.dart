/// Explain command for understanding generated code.
library;

import 'package:args/command_runner.dart';

import '../generator/architecture_validator.dart';
import '../generator/module_metadata.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import 'base_command.dart';

/// Command to explain generated code and architecture.
class ExplainCommand extends Command<int> {
  @override
  final String name = 'explain';

  @override
  final String description = 'Explain generated code, architecture, and modules.';

  ExplainCommand() {
    addSubcommand(ExplainModuleCommand());
    addSubcommand(ExplainArchitectureCommand());
    addSubcommand(ExplainDependenciesCommand());
  }

  @override
  Future<int> run() async {
    Console.info('Use "kiro explain <subcommand>" to understand your code.');
    Console.blank();
    Console.info('Available subcommands:');
    Console.listItem('module       - Explain a specific module');
    Console.listItem('architecture - Explain Clean Architecture');
    Console.listItem('dependencies - Show dependency graph');
    return 0;
  }
}

/// Explain a module.
class ExplainModuleCommand extends BaseCommand {
  @override
  final String name = 'module';

  @override
  final String description = 'Explain a specific module structure and purpose.';

  ExplainModuleCommand() {
    argParser.addOption(
      'project',
      abbr: 'p',
      help: 'Project path (default: current directory)',
      defaultsTo: '.',
    );
  }

  @override
  Future<int> execute() async {
    Console.banner();

    final args = argResults!.rest;
    if (args.isEmpty) {
      Console.error('Please specify a module name.');
      Console.hint('Example: kiro explain module auth');
      return 1;
    }

    final moduleName = args.first;
    final projectPath = argResults!['project'] as String;
    final absolutePath = FileUtils.absolute(projectPath);

    Console.header('Module Explanation: $moduleName');
    Console.blank();

    final modulePath = FileUtils.join(absolutePath, 'lib', 'modules', moduleName);
    if (!await FileUtils.directoryExists(modulePath)) {
      Console.error('Module "$moduleName" not found in project.');
      return 1;
    }

    try {
      final metadata = await ModuleMetadata.fromFile(modulePath);

      // Module Overview
      Console.subheader('Overview');
      Console.keyValue('Name', metadata.displayName);
      Console.keyValue('Version', metadata.version);
      Console.blank();

      // Structure
      Console.subheader('Structure');
      Console.info('This module follows Clean Architecture:');
      Console.blank();
      Console.listItem('domain/ - Business logic and entities');
      Console.listItem('data/ - Data sources and repositories');
      Console.listItem('presentation/ - UI screens and widgets');
      Console.blank();

      // Routes
      if (metadata.routes.isNotEmpty) {
        Console.subheader('Routes');
        Console.info('This module provides ${metadata.routes.length} route(s):');
        Console.blank();
        for (final route in metadata.routes) {
          Console.listItem('${route.path} → ${route.screen}');
          if (route.requiresAuth) {
            Console.hint('  (Requires authentication)');
          }
        }
        Console.blank();
      }

      // Providers
      if (metadata.providers.isNotEmpty) {
        Console.subheader('State Management');
        Console.info('This module uses ${metadata.providers.length} provider(s):');
        Console.blank();
        for (final provider in metadata.providers) {
          Console.listItem('${provider.name}');
        }
        Console.blank();
      }

      // Dependencies
      if (metadata.dependencies.isNotEmpty) {
        Console.subheader('Dependencies');
        Console.info('This module depends on:');
        Console.blank();
        for (final dep in metadata.dependencies) {
          Console.listItem('• $dep');
        }
        Console.blank();
      }

      // Layer Responsibilities
      Console.subheader('Layer Responsibilities');
      Console.info('Domain Layer:');
      Console.hint('  • Contains business logic (use cases)');
      Console.hint('  • Defines entities (domain models)');
      Console.hint('  • Repository interfaces');
      Console.blank();
      Console.info('Data Layer:');
      Console.hint('  • Implements repository interfaces');
      Console.hint('  • Handles API calls and local storage');
      Console.hint('  • Data models and serialization');
      Console.blank();
      Console.info('Presentation Layer:');
      Console.hint('  • UI screens and widgets');
      Console.hint('  • State management (providers)');
      Console.hint('  • User interactions');

      Console.blank();
      Console.success('Module explanation complete!');
      return 0;
    } catch (e) {
      Console.error('Failed to explain module: $e');
      return 1;
    }
  }
}

/// Explain architecture.
class ExplainArchitectureCommand extends BaseCommand {
  @override
  final String name = 'architecture';

  @override
  final String description = 'Explain Clean Architecture principles.';

  ExplainArchitectureCommand() {
    argParser.addOption(
      'project',
      abbr: 'p',
      help: 'Project path (default: current directory)',
      defaultsTo: '.',
    );
  }

  @override
  Future<int> execute() async {
    Console.banner();
    Console.header('Clean Architecture Explanation');
    Console.blank();

    Console.subheader('What is Clean Architecture?');
    Console.info(
      'Clean Architecture is a software design philosophy that separates '
      'concerns into distinct layers, making code more maintainable, testable, '
      'and independent of frameworks.',
    );
    Console.blank();

    Console.subheader('Layer Structure');
    Console.info('1. Presentation Layer (UI)');
    Console.hint('   • Screens, widgets, providers');
    Console.hint('   • Handles user interactions');
    Console.hint('   • Can only depend on Domain layer');
    Console.blank();

    Console.info('2. Domain Layer (Business Logic)');
    Console.hint('   • Entities, use cases, repository interfaces');
    Console.hint('   • Contains core business rules');
    Console.hint('   • Cannot depend on Data or Presentation');
    Console.blank();

    Console.info('3. Data Layer (Data Sources)');
    Console.hint('   • Repository implementations, data sources');
    Console.hint('   • Handles API calls, local storage');
    Console.hint('   • Can depend on Domain layer');
    Console.blank();

    Console.subheader('Dependency Rules');
    Console.info('✅ Allowed:');
    Console.listItem('Presentation → Domain');
    Console.listItem('Data → Domain');
    Console.blank();
    Console.info('❌ Not Allowed:');
    Console.listItem('Presentation → Data');
    Console.listItem('Domain → Data or Presentation');
    Console.blank();

    Console.subheader('Benefits');
    Console.listItem('• Testable: Each layer can be tested independently');
    Console.listItem('• Maintainable: Changes in one layer don\'t affect others');
    Console.listItem('• Scalable: Easy to add new features');
    Console.listItem('• Framework Independent: Business logic doesn\'t depend on Flutter');

    Console.blank();

    // Check project architecture
    final projectPath = argResults!['project'] as String;
    final absolutePath = FileUtils.absolute(projectPath);

    final pubspecPath = FileUtils.join(absolutePath, 'pubspec.yaml');
    if (await FileUtils.fileExists(pubspecPath)) {
      Console.subheader('Your Project Architecture');
      final result = await ArchitectureValidator.validateProject(absolutePath);

      if (result.valid) {
        Console.success('Your project follows Clean Architecture! ✅');
      } else {
        Console.warning('Found ${result.violations.length} architecture violation(s)');
        Console.hint('Run "kiro doctor --architecture" for details');
      }
    }

    Console.blank();
    return 0;
  }
}

/// Explain dependencies.
class ExplainDependenciesCommand extends BaseCommand {
  @override
  final String name = 'dependencies';

  @override
  final String description = 'Show dependency graph and relationships.';

  ExplainDependenciesCommand() {
    argParser.addOption(
      'project',
      abbr: 'p',
      help: 'Project path (default: current directory)',
      defaultsTo: '.',
    );
  }

  @override
  Future<int> execute() async {
    Console.banner();
    Console.header('Dependency Graph');
    Console.blank();

    final projectPath = argResults!['project'] as String;
    final absolutePath = FileUtils.absolute(projectPath);

    final modulesDir = FileUtils.join(absolutePath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      Console.warning('No modules found in project.');
      return 0;
    }

    final modules = await ModuleMetadata.loadAll(modulesDir);

    if (modules.isEmpty) {
      Console.warning('No modules found.');
      return 0;
    }

    Console.subheader('Module Dependencies');
    Console.blank();

    for (final module in modules) {
      Console.write(module.displayName, color: '\x1B[1m');
      Console.write(' (${module.name})');
      Console.blank();

      if (module.dependencies.isEmpty) {
        Console.hint('  No module dependencies');
      } else {
        Console.info('  Depends on:');
        for (final dep in module.dependencies) {
          Console.listItem('    → $dep');
        }
      }

      // Show what depends on this module
      final dependents = modules
          .where((m) => m.dependencies.contains(module.name))
          .map((m) => m.name)
          .toList();

      if (dependents.isNotEmpty) {
        Console.info('  Required by:');
        for (final dependent in dependents) {
          Console.listItem('    ← $dependent');
        }
      }

      Console.blank();
    }

    // Dependency graph visualization
    Console.subheader('Dependency Graph');
    Console.blank();
    Console.info('Visual representation:');
    Console.blank();

    for (final module in modules) {
      if (module.dependencies.isNotEmpty) {
        for (final dep in module.dependencies) {
          Console.write('  $dep');
          Console.write(' → ', color: '\x1B[33m');
          Console.write(module.name);
          Console.blank();
        }
      }
    }

    Console.blank();
    Console.info('Legend:');
    Console.hint('  → Module dependency');
    Console.hint('  (No arrows = no dependencies)');
    Console.blank();

    return 0;
  }
}

