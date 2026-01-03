/// Add command for adding modules to existing projects.
library;

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';

import '../config/app_config.dart';
import '../generator/dependency_validator.dart';
import '../generator/env_config_generator.dart';
import '../generator/module_injector.dart';
import '../generator/module_metadata.dart';
import '../generator/provider_registry.dart';
import '../generator/pubspec_updater.dart';
import '../generator/route_generator.dart';
import '../generator/test_generator.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import '../utils/process_utils.dart';
import 'base_command.dart';

/// Command to add modules to existing Kiro app.
class AddCommand extends Command<int> {
  @override
  final String name = 'add';

  @override
  final String description = 'Add modules or features to an existing Kiro project.';

  AddCommand() {
    addSubcommand(AddModuleCommand());
  }

  @override
  Future<int> run() async {
    Console.info('Use "kiro add module <name>" to add a module.');
    Console.blank();
    Console.info('Available modules:');
    for (final module in KiroModule.values) {
      Console.listItem('${module.name} - ${module.description}');
    }
    return 0;
  }
}

/// Subcommand to add a module.
class AddModuleCommand extends BaseCommand {
  @override
  final String name = 'module';

  @override
  final String description = 'Add a module to the current Kiro project.';

  AddModuleCommand() {
    argParser
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Path to the project (default: current directory)',
        defaultsTo: '.',
      )
      ..addFlag(
        'skip-tests',
        help: 'Skip generating test skeletons',
        defaultsTo: false,
      )
      ..addFlag(
        'skip-env',
        help: 'Skip generating environment configs',
        defaultsTo: false,
      );
  }

  @override
  Future<int> execute() async {
    Console.banner();

    final args = argResults!.rest;
    if (args.isEmpty) {
      Console.error('Please specify a module name.');
      Console.blank();
      Console.info('Available modules:');
      for (final module in KiroModule.values) {
        Console.listItem('${module.name} - ${module.description}');
      }
      Console.blank();
      Console.hint('Example: kiro add module auth');
      return 1;
    }

    final moduleName = args.first.toLowerCase();
    final module = KiroModule.values.where((m) => m.name == moduleName).firstOrNull;

    if (module == null) {
      Console.error('Unknown module: $moduleName');
      Console.blank();
      Console.info('Available modules:');
      for (final m in KiroModule.values) {
        Console.listItem('${m.name} - ${m.description}');
      }
      return 1;
    }

    final projectPath = argResults!['project'] as String;
    final absolutePath = FileUtils.absolute(projectPath);

    // Check if it's a valid Flutter project
    final pubspecPath = FileUtils.join(absolutePath, 'pubspec.yaml');
    if (!await FileUtils.fileExists(pubspecPath)) {
      Console.error('Not a valid Flutter project at: $absolutePath');
      Console.hint('Make sure you are in a Flutter project directory.');
      return 1;
    }

    // Check if it's a Kiro project
    final kiroConfigPath = FileUtils.join(absolutePath, 'kiro.yaml');
    final isKiroProject = await FileUtils.fileExists(kiroConfigPath);

    if (!isKiroProject) {
      Console.warning('This doesn\'t appear to be a Kiro project.');
      if (!confirm('Continue anyway?')) {
        return 0;
      }
    }

    // Find Kiro root (where modules/ directory is)
    final kiroRoot = await _findKiroRoot(absolutePath);
    if (kiroRoot == null) {
      Console.error('Could not find Kiro root directory (modules/ folder).');
      Console.hint('Make sure you are running this from a Kiro workspace.');
      return 1;
    }

    Console.header('Adding ${module.displayName} Module');
    Console.info('Module: ${module.description}');
    Console.blank();

    try {
      // Step 1: Load module metadata
      Console.step('Loading module metadata...');
      final modulePath = FileUtils.join(kiroRoot, 'modules', module.name);
      final moduleMetadata = await ModuleMetadata.fromFile(modulePath);
      Console.success('Module metadata loaded');

      // Step 2: Load existing modules
      Console.step('Loading existing modules...');
      final existingModules = await _loadExistingModules(absolutePath);
      Console.success('Found ${existingModules.length} existing module(s)');

      // Step 3: Validate dependencies
      Console.step('Validating dependencies...');
      final coreDependencies = ['kiro_core', 'network', 'storage', 'permissions'];
      final validationResult = DependencyValidator.validateDependencies(
        existingModules: existingModules,
        newModule: moduleMetadata,
        coreDependencies: coreDependencies,
      );

      if (!validationResult.success) {
        Console.error('Dependency validation failed:');
        for (final error in validationResult.errors) {
          Console.error('  • $error');
        }
        return 1;
      }

      if (validationResult.warnings.isNotEmpty) {
        Console.warning('Dependency warnings:');
        for (final warning in validationResult.warnings) {
          Console.warning('  • $warning');
        }
      }
      Console.success('Dependencies validated');

      // Step 4: Inject module
      Console.step('Injecting module files...');
      final injector = ModuleInjector(
        projectPath: absolutePath,
        kiroRoot: kiroRoot,
      );
      final injectionResult = await injector.injectModule(moduleMetadata);

      if (!injectionResult.success) {
        Console.error('Module injection failed:');
        for (final error in injectionResult.errors) {
          Console.error('  • $error');
        }
        return 1;
      }
      Console.success('Module injected successfully');

      // Step 5: Update pubspec.yaml
      Console.step('Updating dependencies...');
      final pubspecUpdater = PubspecUpdater(absolutePath);
      final kiroCoreVersion = moduleMetadata.config['kiro_core_version'] as String?;
      final pubspecUpdated = await pubspecUpdater.updatePubspec(
        module: moduleMetadata,
        kiroCoreVersion: kiroCoreVersion,
      );
      if (pubspecUpdated) {
        Console.success('Dependencies updated');
      } else {
        Console.warning('Could not update all dependencies automatically');
      }

      // Step 6: Generate/Update routes
      Console.step('Generating routes...');
      final allModules = [...existingModules, moduleMetadata];
      final appName = await _getAppName(absolutePath);
      final routesContent = RouteGenerator.generateRoutes(
        modules: allModules,
        appName: appName,
      );
      await FileUtils.writeFile(
        FileUtils.join(absolutePath, 'lib', 'config', 'router.dart'),
        routesContent,
      );
      Console.success('Routes generated');

      // Step 7: Generate/Update provider registry
      Console.step('Registering providers...');
      final providersContent = ProviderRegistryGenerator.generateProviderRegistry(
        modules: allModules,
        appName: appName,
      );
      await FileUtils.writeFile(
        FileUtils.join(absolutePath, 'lib', 'core', 'providers.dart'),
        providersContent,
      );
      Console.success('Providers registered');

      // Step 8: Generate test skeletons (optional)
      if (!(argResults!['skip-tests'] as bool)) {
        Console.step('Generating test skeletons...');
        final testGenerator = TestGenerator(absolutePath);
        await testGenerator.generateTestSkeletons(moduleMetadata);
        Console.success('Test skeletons generated');
      }

      // Step 9: Generate environment configs (optional)
      if (!(argResults!['skip-env'] as bool)) {
        final useFirebase = await _checkFirebaseEnabled(absolutePath);
        Console.step('Generating environment configs...');
        final envGenerator = EnvConfigGenerator(
          projectPath: absolutePath,
          useFirebase: useFirebase,
        );
        await envGenerator.generateEnvConfigs();
        Console.success('Environment configs generated');
      }

      // Step 10: Run pub get
      Console.step('Running flutter pub get...');
      final pubResult = await ProcessUtils.pubGet(workingDirectory: absolutePath);
      if (pubResult.success) {
        Console.success('Dependencies installed');
      } else {
        Console.warning('pub get had issues (you can run it manually)');
      }

      // Success summary
      Console.blank();
      Console.success('✓ Module "${module.displayName}" added successfully!');
      Console.blank();
      Console.header('Summary');
      Console.keyValue('Module', module.displayName);
      Console.keyValue('Routes', '${moduleMetadata.routes.length} route(s) added');
      Console.keyValue('Providers', '${moduleMetadata.providers.length} provider(s) registered');
      Console.blank();
      Console.info('Next steps:');
      Console.numberedItem(1, 'Review generated routes in lib/config/router.dart');
      Console.numberedItem(2, 'Review provider registry in lib/core/providers.dart');
      if (!(argResults!['skip-tests'] as bool)) {
        Console.numberedItem(3, 'Implement tests in test/modules/${module.name}/');
      }
      Console.numberedItem(4, 'Configure module settings in lib/modules/${module.name}/module.yaml');
      Console.blank();

      return 0;
    } catch (e, stackTrace) {
      Console.error('Failed to add module: $e');
      if (argResults!['verbose'] == true) {
        Console.hint('Stack trace: $stackTrace');
      }
      return 1;
    }
  }

  /// Find Kiro root directory.
  Future<String?> _findKiroRoot(String projectPath) async {
    // Start from project directory and go up
    var current = projectPath;
    var previous = '';

    while (current != previous) {
      final modulesPath = FileUtils.join(current, 'modules');
      if (await FileUtils.directoryExists(modulesPath)) {
        return current;
      }
      previous = current;
      current = FileUtils.normalize(FileUtils.join(current, '..'));
    }

    // Try relative to current working directory
    final cwd = FileUtils.currentDirectory;
    var cwdCurrent = cwd;
    var cwdPrevious = '';

    while (cwdCurrent != cwdPrevious) {
      final modulesPath = FileUtils.join(cwdCurrent, 'modules');
      if (await FileUtils.directoryExists(modulesPath)) {
        return cwdCurrent;
      }
      cwdPrevious = cwdCurrent;
      cwdCurrent = FileUtils.normalize(FileUtils.join(cwdCurrent, '..'));
    }

    return null;
  }

  /// Load existing modules from project.
  Future<List<ModuleMetadata>> _loadExistingModules(String projectPath) async {
    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      return [];
    }

    return await ModuleMetadata.loadAll(modulesDir);
  }

  /// Get app name from pubspec.yaml.
  Future<String> _getAppName(String projectPath) async {
    try {
      final pubspecPath = FileUtils.join(projectPath, 'pubspec.yaml');
      final content = await FileUtils.readFile(pubspecPath);
      // Simple regex extraction
      final match = RegExp(r'^name:\s*(\w+)', multiLine: true).firstMatch(content);
      return match?.group(1) ?? 'app';
    } catch (_) {
      return 'app';
    }
  }

  /// Check if Firebase is enabled in project.
  Future<bool> _checkFirebaseEnabled(String projectPath) async {
    try {
      final pubspecPath = FileUtils.join(projectPath, 'pubspec.yaml');
      final content = await FileUtils.readFile(pubspecPath);
      return content.contains('firebase_core');
    } catch (_) {
      return false;
    }
  }
}
