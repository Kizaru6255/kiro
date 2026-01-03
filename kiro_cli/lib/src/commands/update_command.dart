/// Update command for updating modules in existing projects.
library;

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';

import '../config/app_config.dart';
import '../generator/module_updater.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import '../utils/process_utils.dart';
import 'base_command.dart';

/// Command to update modules in existing Kiro app.
class UpdateCommand extends Command<int> {
  @override
  final String name = 'update';

  @override
  final String description = 'Update modules in an existing Kiro project.';

  UpdateCommand() {
    addSubcommand(UpdateModuleCommand());
  }

  @override
  Future<int> run() async {
    Console.info('Use "kiro update module <name>" to update a module.');
    Console.blank();
    Console.info('Available modules:');
    for (final module in KiroModule.values) {
      Console.listItem('${module.name} - ${module.description}');
    }
    return 0;
  }
}

/// Subcommand to update a module.
class UpdateModuleCommand extends BaseCommand {
  @override
  final String name = 'module';

  @override
  final String description = 'Update a module in the current Kiro project.';

  UpdateModuleCommand() {
    argParser
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Path to the project (default: current directory)',
        defaultsTo: '.',
      )
      ..addFlag(
        'force',
        abbr: 'f',
        help: 'Force update without confirmation',
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
      Console.hint('Example: kiro update module auth');
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

    // Find Kiro root
    final kiroRoot = await _findKiroRoot(absolutePath);
    if (kiroRoot == null) {
      Console.error('Could not find Kiro root directory (modules/ folder).');
      Console.hint('Make sure you are running this from a Kiro workspace.');
      return 1;
    }

    Console.header('Updating ${module.displayName} Module');
    Console.info('This will update the module files from the source.');
    Console.blank();

    // Confirm update
    final force = argResults!['force'] as bool;
    if (!force && !confirm('Are you sure you want to update this module?', defaultValue: true)) {
      Console.info('Module update cancelled.');
      return 0;
    }

    try {
      // Update module
      Console.step('Updating module...');
      final updater = ModuleUpdater(
        projectPath: absolutePath,
        kiroRoot: kiroRoot,
      );
      final result = await updater.updateModule(moduleName);

      if (!result.success) {
        Console.error('Failed to update module:');
        for (final error in result.errors) {
          Console.error('  • $error');
        }
        return 1;
      }

      // Run pub get
      Console.step('Updating dependencies...');
      final pubResult = await ProcessUtils.pubGet(workingDirectory: absolutePath);
      if (pubResult.success) {
        Console.success('Dependencies updated');
      } else {
        Console.warning('pub get had issues (you can run it manually)');
      }

      // Success summary
      Console.blank();
      Console.success('✓ Module "${module.displayName}" updated successfully!');
      if (result.oldVersion != null && result.newVersion != null) {
        Console.info('Version: ${result.oldVersion} → ${result.newVersion}');
      }
      Console.blank();
      Console.info('Next steps:');
      Console.numberedItem(1, 'Review updated routes in lib/config/router.dart');
      Console.numberedItem(2, 'Review updated providers in lib/core/providers.dart');
      Console.numberedItem(3, 'Test the updated module functionality');
      Console.numberedItem(4, 'Run "flutter pub get" if needed');
      Console.blank();

      return 0;
    } catch (e, stackTrace) {
      Console.error('Failed to update module: $e');
      if (argResults!['verbose'] == true) {
        Console.hint('Stack trace: $stackTrace');
      }
      return 1;
    }
  }

  /// Find Kiro root directory.
  Future<String?> _findKiroRoot(String projectPath) async {
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
}


