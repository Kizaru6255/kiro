/// Remove command for removing modules from existing projects.
library;

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';

import '../config/app_config.dart';
import '../generator/module_remover.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import '../utils/process_utils.dart';
import 'base_command.dart';

/// Command to remove modules from existing Kiro app.
class RemoveCommand extends Command<int> {
  @override
  final String name = 'remove';

  @override
  final String description = 'Remove modules from an existing Kiro project.';

  RemoveCommand() {
    addSubcommand(RemoveModuleCommand());
  }

  @override
  Future<int> run() async {
    Console.info('Use "kiro remove module <name>" to remove a module.');
    Console.blank();
    Console.info('Available modules:');
    for (final module in KiroModule.values) {
      Console.listItem('${module.name} - ${module.description}');
    }
    return 0;
  }
}

/// Subcommand to remove a module.
class RemoveModuleCommand extends BaseCommand {
  @override
  final String name = 'module';

  @override
  final String description = 'Remove a module from the current Kiro project.';

  RemoveModuleCommand() {
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
        help: 'Force removal without confirmation',
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
      Console.hint('Example: kiro remove module auth');
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

    Console.header('Removing ${module.displayName} Module');
    Console.warning('This will permanently delete the module files.');
    Console.blank();

    // Confirm removal
    final force = argResults!['force'] as bool;
    if (!force && !confirm('Are you sure you want to remove this module?', defaultValue: false)) {
      Console.info('Module removal cancelled.');
      return 0;
    }

    try {
      // Remove module
      Console.step('Removing module...');
      final remover = ModuleRemover(absolutePath);
      final result = await remover.removeModule(moduleName);

      if (!result.success) {
        Console.error('Failed to remove module:');
        for (final error in result.errors) {
          Console.error('  • $error');
        }
        return 1;
      }

      // Run pub get to clean up
      Console.step('Cleaning up dependencies...');
      final pubResult = await ProcessUtils.pubGet(workingDirectory: absolutePath);
      if (pubResult.success) {
        Console.success('Dependencies cleaned');
      } else {
        Console.warning('pub get had issues (you can run it manually)');
      }

      // Success summary
      Console.blank();
      Console.success('✓ Module "${module.displayName}" removed successfully!');
      Console.blank();
      Console.info('Next steps:');
      Console.numberedItem(1, 'Review and remove unused dependencies from pubspec.yaml');
      Console.numberedItem(2, 'Update any code that references this module');
      Console.numberedItem(3, 'Run "flutter pub get" if needed');
      Console.blank();

      return 0;
    } catch (e, stackTrace) {
      Console.error('Failed to remove module: $e');
      if (argResults!['verbose'] == true) {
        Console.hint('Stack trace: $stackTrace');
      }
      return 1;
    }
  }
}


