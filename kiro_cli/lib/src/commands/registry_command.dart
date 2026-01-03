/// Registry command for managing module registry.
library;

import 'package:args/command_runner.dart';

import '../generator/registry_manager.dart';
import '../utils/console.dart';
import 'base_command.dart';

/// Command to manage module registry.
class RegistryCommand extends Command<int> {
  @override
  final String name = 'registry';

  @override
  final String description = 'Manage module registry and search/install modules.';

  RegistryCommand() {
    addSubcommand(RegistryInitCommand());
    addSubcommand(RegistrySearchCommand());
    addSubcommand(RegistryInstallCommand());
    addSubcommand(RegistryListCommand());
  }

  @override
  Future<int> run() async {
    Console.info('Use "kiro registry <subcommand>" to manage registry.');
    Console.blank();
    Console.info('Available subcommands:');
    Console.listItem('init     - Initialize registry configuration');
    Console.listItem('search   - Search modules in registry');
    Console.listItem('install  - Install module from registry');
    Console.listItem('list     - List available modules');
    return 0;
  }
}

/// Initialize registry.
class RegistryInitCommand extends BaseCommand {
  @override
  final String name = 'init';

  @override
  final String description = 'Initialize registry configuration.';

  RegistryInitCommand() {
    argParser
      ..addOption(
        'url',
        help: 'Registry URL (default: https://registry.kiro.dev)',
      )
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Project path (default: current directory)',
        defaultsTo: '.',
      );
  }

  @override
  Future<int> execute() async {
    Console.banner();
    Console.header('Initialize Registry');

    final registryUrl = argResults!['url'] as String?;
    final projectPath = argResults!['project'] as String;

    final success = await RegistryManager.initRegistry(
      registryUrl: registryUrl,
      projectPath: projectPath,
    );

    if (success) {
      Console.blank();
      Console.success('Registry initialized successfully!');
      Console.blank();
      Console.info('Next steps:');
      Console.numberedItem(1, 'Search modules: kiro registry search <query>');
      Console.numberedItem(2, 'Install module: kiro registry install <name>');
      Console.blank();
      return 0;
    } else {
      return 1;
    }
  }
}

/// Search modules in registry.
class RegistrySearchCommand extends BaseCommand {
  @override
  final String name = 'search';

  @override
  final String description = 'Search modules in registry.';

  RegistrySearchCommand() {
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
      Console.error('Please specify a search query.');
      Console.hint('Example: kiro registry search auth');
      return 1;
    }

    final query = args.join(' ');
    final projectPath = argResults!['project'] as String;

    Console.header('Searching Modules');
    Console.info('Query: "$query"');
    Console.blank();

    final modules = await RegistryManager.searchModules(
      query: query,
      projectPath: projectPath,
    );

    if (modules.isEmpty) {
      Console.warning('No modules found.');
      Console.hint('Try a different search query or check your registry connection.');
      return 0;
    }

    Console.success('Found ${modules.length} module(s):');
    Console.blank();

    for (final module in modules) {
      Console.subheader(module.name);
      Console.keyValue('Author', module.author);
      Console.keyValue('Version', module.version);
      Console.keyValue('Description', module.description);
      if (module.tags.isNotEmpty) {
        Console.keyValue('Tags', module.tags.join(', '));
      }
      Console.keyValue('Downloads', module.downloads.toString());
      if (module.rating > 0) {
        Console.keyValue('Rating', '${module.rating.toStringAsFixed(1)}/5.0');
      }
      Console.hint('Install: kiro registry install ${module.name}');
      Console.blank();
    }

    return 0;
  }
}

/// Install module from registry.
class RegistryInstallCommand extends BaseCommand {
  @override
  final String name = 'install';

  @override
  final String description = 'Install module from registry.';

  RegistryInstallCommand() {
    argParser
      ..addOption(
        'version',
        help: 'Module version (default: latest)',
      )
      ..addOption(
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
      Console.hint('Example: kiro registry install auth');
      return 1;
    }

    final moduleName = args.first;
    final version = argResults!['version'] as String?;
    final projectPath = argResults!['project'] as String;

    Console.header('Installing Module');
    Console.info('Module: $moduleName');
    if (version != null) {
      Console.info('Version: $version');
    }
    Console.blank();

    final success = await RegistryManager.installModule(
      moduleName: moduleName,
      version: version,
      projectPath: projectPath,
    );

    if (success) {
      Console.blank();
      Console.success('Module installed successfully!');
      Console.blank();
      Console.info('Next steps:');
      Console.numberedItem(1, 'Add to project: kiro add module $moduleName');
      Console.numberedItem(2, 'Review module documentation');
      Console.blank();
      return 0;
    } else {
      return 1;
    }
  }
}

/// List modules in registry.
class RegistryListCommand extends BaseCommand {
  @override
  final String name = 'list';

  @override
  final String description = 'List available modules in registry.';

  RegistryListCommand() {
    argParser
      ..addOption(
        'limit',
        help: 'Maximum number of modules to list (default: 50)',
        defaultsTo: '50',
      )
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Project path (default: current directory)',
        defaultsTo: '.',
      );
  }

  @override
  Future<int> execute() async {
    Console.banner();
    Console.header('Available Modules');

    final limit = int.tryParse(argResults!['limit'] as String) ?? 50;
    final projectPath = argResults!['project'] as String;

    Console.step('Fetching modules from registry...');
    final modules = await RegistryManager.listModules(
      projectPath: projectPath,
      limit: limit,
    );

    if (modules.isEmpty) {
      Console.warning('No modules found in registry.');
      Console.hint('Run "kiro registry init" to configure registry.');
      return 0;
    }

    Console.success('Found ${modules.length} module(s):');
    Console.blank();

    for (var i = 0; i < modules.length; i++) {
      final module = modules[i];
      Console.write('${i + 1}. ');
      Console.write(module.name, color: '\x1B[1m');
      Console.write(' v${module.version}');
      Console.write(' by ${module.author}');
      if (module.rating > 0) {
        Console.write(' ⭐ ${module.rating.toStringAsFixed(1)}');
      }
      Console.blank();
      Console.hint('  ${module.description}');
      Console.blank();
    }

    Console.info('Use "kiro registry search <query>" to search modules.');
    Console.info('Use "kiro registry install <name>" to install a module.');
    Console.blank();

    return 0;
  }
}

