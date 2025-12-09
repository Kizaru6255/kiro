/// Add command for adding modules to existing projects.
library;

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';

import '../config/app_config.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
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
      argParser.addOption(
        'project',
        abbr: 'p',
        help: 'Path to the project (default: current directory)',
        defaultsTo: '.',
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

    Console.header('Adding ${module.displayName} Module');
    Console.info('Module: ${module.description}');
    Console.blank();

    // TODO: Implement actual module injection
    Console.step('Creating module structure...');
    await _createModuleStructure(absolutePath, module);

    Console.step('Updating dependencies...');
    await _updateDependencies(absolutePath, module);

    Console.step('Generating boilerplate code...');
    await _generateModuleCode(absolutePath, module);

    Console.blank();
    Console.success('${module.displayName} module added successfully!');
    Console.blank();
    Console.info('Next steps:');
    Console.numberedItem(1, 'Run "flutter pub get"');
    Console.numberedItem(2, 'Import the module in your app');
    Console.numberedItem(3, 'Configure the module as needed');
    Console.blank();

    return 0;
  }

  Future<void> _createModuleStructure(String projectPath, KiroModule module) async {
    final modulePath = FileUtils.join(projectPath, 'lib', 'features', module.name);
    
    await FileUtils.ensureDirectory(FileUtils.join(modulePath, 'data', 'models'));
    await FileUtils.ensureDirectory(FileUtils.join(modulePath, 'data', 'repositories'));
    await FileUtils.ensureDirectory(FileUtils.join(modulePath, 'data', 'services'));
    await FileUtils.ensureDirectory(FileUtils.join(modulePath, 'presentation', 'screens'));
    await FileUtils.ensureDirectory(FileUtils.join(modulePath, 'presentation', 'widgets'));
    await FileUtils.ensureDirectory(FileUtils.join(modulePath, 'presentation', 'providers'));
  }

  Future<void> _updateDependencies(String projectPath, KiroModule module) async {
    // TODO: Parse pubspec.yaml and add module-specific dependencies
    // For now, just log what would be added
    final deps = _getModuleDependencies(module);
    if (deps.isNotEmpty) {
      Console.hint('  Would add dependencies: ${deps.join(', ')}');
    }
  }

  Future<void> _generateModuleCode(String projectPath, KiroModule module) async {
    final modulePath = FileUtils.join(projectPath, 'lib', 'features', module.name);
    
    // Create barrel file
    final barrelContent = '''
/// ${module.displayName} module.
library;

// Data
export 'data/models/models.dart';
export 'data/repositories/repositories.dart';
export 'data/services/services.dart';

// Presentation
export 'presentation/providers/providers.dart';
export 'presentation/screens/screens.dart';
export 'presentation/widgets/widgets.dart';
''';
    
    await FileUtils.writeFile(
      FileUtils.join(modulePath, '${module.name}.dart'),
      barrelContent,
    );

    // Create placeholder barrel files
    await FileUtils.writeFile(
      FileUtils.join(modulePath, 'data', 'models', 'models.dart'),
      '/// ${module.displayName} models.\nlibrary;\n',
    );
    await FileUtils.writeFile(
      FileUtils.join(modulePath, 'data', 'repositories', 'repositories.dart'),
      '/// ${module.displayName} repositories.\nlibrary;\n',
    );
    await FileUtils.writeFile(
      FileUtils.join(modulePath, 'data', 'services', 'services.dart'),
      '/// ${module.displayName} services.\nlibrary;\n',
    );
    await FileUtils.writeFile(
      FileUtils.join(modulePath, 'presentation', 'providers', 'providers.dart'),
      '/// ${module.displayName} providers.\nlibrary;\n',
    );
    await FileUtils.writeFile(
      FileUtils.join(modulePath, 'presentation', 'screens', 'screens.dart'),
      '/// ${module.displayName} screens.\nlibrary;\n',
    );
    await FileUtils.writeFile(
      FileUtils.join(modulePath, 'presentation', 'widgets', 'widgets.dart'),
      '/// ${module.displayName} widgets.\nlibrary;\n',
    );
  }

  List<String> _getModuleDependencies(KiroModule module) {
    return switch (module) {
      KiroModule.auth => ['firebase_auth', 'google_sign_in'],
      KiroModule.wallet => [],
      KiroModule.chat => ['cloud_firestore', 'firebase_storage'],
      KiroModule.booking => ['table_calendar', 'intl'],
      KiroModule.payments => ['razorpay_flutter'],
      KiroModule.notifications => ['firebase_messaging', 'flutter_local_notifications'],
      KiroModule.tracking => ['google_maps_flutter', 'geolocator'],
      KiroModule.profile => ['image_picker', 'cached_network_image'],
    };
  }
}

