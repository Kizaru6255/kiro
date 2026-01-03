/// Create command for generating new Kiro apps.
library;

import 'package:args/command_runner.dart';

import '../config/app_config.dart';
import '../generator/blueprint_manager.dart';
import '../generator/project_generator.dart';
import '../generator/sample_app_generator.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import 'base_command.dart';

/// Command to create a new Kiro app.
class CreateCommand extends Command<int> {
  @override
  final String name = 'create';

  @override
  final String description = 'Create a new Kiro-powered Flutter application.';

  CreateCommand() {
    addSubcommand(CreateAppCommand());
  }

  @override
  Future<int> run() async {
    Console.info('Use "kiro create app" to create a new application.');
    return 0;
  }
}

/// Subcommand to create app.
class CreateAppCommand extends BaseCommand {
  @override
  final String name = 'app';

  @override
  final String description = 'Create a new Flutter application with Kiro architecture.';

  CreateAppCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Name of the application',
      )
      ..addOption(
        'org',
        abbr: 'o',
        help: 'Organization identifier (e.g., com.example)',
        defaultsTo: 'com.example',
      )
      ..addOption(
        'output',
        abbr: 'd',
        help: 'Output directory',
        defaultsTo: '.',
      )
      ..addMultiOption(
        'platforms',
        abbr: 'p',
        help: 'Target platforms (android, ios, web, macos, windows, linux)',
        defaultsTo: ['android', 'ios'],
      )
      ..addMultiOption(
        'modules',
        abbr: 'm',
        help: 'Modules to include (auth, wallet, chat, booking, payments, notifications, tracking, profile)',
      )
      ..addOption(
        'state',
        abbr: 's',
        help: 'State management (riverpod, bloc, provider)',
        defaultsTo: 'riverpod',
      )
      ..addOption(
        'color',
        help: 'Primary color (hex, e.g., #6366F1)',
        defaultsTo: '#6366F1',
      )
      ..addFlag(
        'firebase',
        help: 'Include Firebase setup',
        defaultsTo: false,
      )
      ..addFlag(
        'git',
        help: 'Initialize Git repository',
        defaultsTo: true,
      )
      ..addFlag(
        'splash',
        help: 'Include splash screen',
        defaultsTo: false,
      )
      ..addFlag(
        'onboarding',
        help: 'Include onboarding screens',
        defaultsTo: false,
      )
      ..addMultiOption(
        'bottom-nav',
        help: 'Bottom navigation tabs (e.g., chat,wallet,profile). Home is always included.',
      )
      ..addFlag(
        'interactive',
        abbr: 'i',
        help: 'Run in interactive mode',
        defaultsTo: true,
      )
      ..addFlag(
        'sample',
        help: 'Generate a sample app with pre-configured modules',
        defaultsTo: false,
      )
      ..addOption(
        'blueprint',
        help: 'Use a blueprint template (ecommerce, fintech, saas, social, healthcare)',
      );
  }

  @override
  Future<int> execute() async {
    Console.banner();

    final isInteractive = argResults!['interactive'] as bool;
    
    AppConfig config;
    
    if (isInteractive) {
      config = await _interactiveSetup();
    } else {
      config = _parseArgsToConfig();
    }

    // Validate configuration before generating
    final validationWarnings = _validateConfig(config);
    if (validationWarnings.isNotEmpty) {
      Console.blank();
      Console.warning('Configuration validation warnings:');
      for (final warning in validationWarnings) {
        Console.hint('  • $warning');
      }
      Console.blank();
      // Don't fail, just warn - we auto-fix reserved words
    }

    // Confirm before generating
    Console.blank();
    Console.header('Project Configuration');
    Console.keyValue('App Name', config.appName);
    Console.keyValue('Package', config.packageName);
    Console.keyValue('Platforms', config.platforms.map((p) => p.displayName).join(', '));
    Console.keyValue('Modules', config.modules.isEmpty 
        ? 'None' 
        : config.modules.map((m) => m.displayName).join(', '));
    Console.keyValue('State Management', config.stateManagement.displayName);
    Console.keyValue('Primary Color', config.primaryColor);
    Console.keyValue('Output', config.projectPath);
    Console.blank();

    if (!confirm('Create project with these settings?', defaultValue: true)) {
      Console.warning('Project creation cancelled.');
      return 0;
    }

    // Check if directory exists
    if (await FileUtils.directoryExists(config.projectPath)) {
      Console.error('Directory "${config.projectPath}" already exists.');
      if (!confirm('Overwrite existing directory?')) {
        return 1;
      }
      await FileUtils.delete(config.projectPath);
    }

    // Generate project
    Console.blank();
    final isSample = argResults!['sample'] as bool;
    final blueprintName = argResults!['blueprint'] as String?;
    
    if (blueprintName != null) {
      Console.header('Generating from Blueprint');
      final success = await BlueprintManager.generateFromBlueprint(
        blueprintName: blueprintName,
        baseConfig: config,
      );
      
      if (success) {
        Console.complete(config.projectDirName);
        return 0;
      } else {
        Console.error('Failed to generate from blueprint.');
        return 1;
      }
    }
    
    if (isSample) {
      Console.header('Generating Sample App');
      final sampleGenerator = SampleAppGenerator(config);
      final success = await sampleGenerator.generate();
      
      if (success) {
        Console.complete(config.projectDirName);
        return 0;
      } else {
        Console.error('Failed to generate sample app.');
        return 1;
      }
    }

    Console.header('Generating Project');
    final generator = ProjectGenerator(config);
    final success = await generator.generate();

    if (success) {
      Console.complete(config.projectDirName);
      return 0;
    } else {
      Console.error('Failed to generate project.');
      return 1;
    }
  }

  Future<AppConfig> _interactiveSetup() async {
    // App Name
    Console.subheader('Basic Information');
    
    String? appName = argResults!['name'] as String?;
    while (appName == null || appName.isEmpty) {
      appName = prompt('App name (e.g., MyAwesomeApp)');
      if (appName == null || appName.isEmpty) {
        Console.error('App name is required.');
      } else {
        // Validate app name
        final sanitized = FileUtils.toSnakeCase(appName);
        if (_isDartReservedWord(sanitized)) {
          Console.warning('"$appName" is a Dart reserved word. It will be converted to "${sanitized}_app".');
        }
      }
    }

    final description = prompt(
      'Description',
      defaultValue: 'A new Flutter application powered by Kiro.',
    ) ?? '';

    final org = prompt(
      'Organization',
      defaultValue: argResults!['org'] as String,
    ) ?? 'com.example';

    // Platforms
    Console.subheader('Target Platforms');
    Console.info('Select platforms (comma-separated):');
    Console.hint('  1. Android  2. iOS  3. Web  4. macOS  5. Windows  6. Linux');
    
    final platformInput = prompt('Platforms', defaultValue: '1,2') ?? '1,2';
    final platformNumbers = platformInput.split(',').map((s) => s.trim());
    final platforms = <Platform>[];
    
    for (final num in platformNumbers) {
      switch (num) {
        case '1': platforms.add(Platform.android);
        case '2': platforms.add(Platform.ios);
        case '3': platforms.add(Platform.web);
        case '4': platforms.add(Platform.macos);
        case '5': platforms.add(Platform.windows);
        case '6': platforms.add(Platform.linux);
      }
    }
    if (platforms.isEmpty) {
      platforms.addAll([Platform.android, Platform.ios]);
    }

    // State Management (Riverpod only)
    Console.subheader('State Management');
    Console.info('Using Riverpod (compile-safe state management)');
    final stateManagement = StateManagement.riverpod;

    // Modules
    Console.subheader('Modules');
    Console.info('Select modules to include (comma-separated, or "none"):');
    for (var i = 0; i < KiroModule.values.length; i++) {
      final module = KiroModule.values[i];
      Console.hint('  ${i + 1}. ${module.displayName} - ${module.description}');
    }
    
    final moduleInput = prompt('Modules', defaultValue: 'none') ?? 'none';
    final modules = <KiroModule>[];
    
    if (moduleInput.toLowerCase() != 'none') {
      final moduleNumbers = moduleInput.split(',').map((s) => s.trim());
      for (final num in moduleNumbers) {
        final index = int.tryParse(num);
        if (index != null && index >= 1 && index <= KiroModule.values.length) {
          modules.add(KiroModule.values[index - 1]);
        }
      }
    }

    // Theme
    Console.subheader('Theme');
    final primaryColor = prompt(
      'Primary color (hex)',
      defaultValue: argResults!['color'] as String,
    ) ?? '#6366F1';

    // Firebase
    Console.subheader('Additional Options');
    final useFirebase = confirm('Include Firebase setup?');
    final initGit = confirm('Initialize Git repository?', defaultValue: true);

    // App Flow Options
    Console.subheader('App Flow Configuration');
    final includeSplash = confirm('Include Splash Screen?', defaultValue: false);
    final includeOnboarding = confirm('Include Onboarding Screens?', defaultValue: false);
    
    // Bottom Navigation Tabs
    final bottomNavTabs = <String>['home']; // Home is always included
    if (modules.isNotEmpty) {
      Console.info('Select modules for bottom navigation (comma-separated):');
      Console.hint('  Available modules: ${modules.map((m) => m.name).join(', ')}');
      Console.hint('  Note: Home is always included. Notifications will appear in AppBar.');
      
      final navInput = prompt('Bottom nav modules (e.g., chat,profile)', defaultValue: '') ?? '';
      if (navInput.isNotEmpty) {
        final selectedNavModules = navInput.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        // Validate that selected modules are actually in the modules list
        for (final navModule in selectedNavModules) {
          if (modules.any((m) => m.name == navModule)) {
            bottomNavTabs.add(navModule);
          }
        }
      } else {
        // Default: add chat and profile if they exist
        if (modules.contains(KiroModule.chat)) {
          bottomNavTabs.add('chat');
        }
        if (modules.contains(KiroModule.profile)) {
          bottomNavTabs.add('profile');
        }
      }
    }

    // Output
    final outputDir = prompt(
      'Output directory',
      defaultValue: argResults!['output'] as String,
    ) ?? '.';

    // Generate validated package name
    final validatedPackageName = AppConfig.generatePackageName(appName, org);
    
    return AppConfig(
      appName: appName,
      packageName: validatedPackageName,
      description: description,
      organization: org,
      platforms: platforms,
      modules: modules,
      stateManagement: stateManagement,
      primaryColor: primaryColor,
      useFirebase: useFirebase,
      initGit: initGit,
      outputDirectory: FileUtils.absolute(outputDir),
      includeSplash: includeSplash,
      includeOnboarding: includeOnboarding,
      bottomNavTabs: bottomNavTabs,
    );
  }

  /// Check if a word is a Dart reserved word.
  bool _isDartReservedWord(String word) {
    const reservedWords = {
      'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch',
      'class', 'const', 'continue', 'covariant', 'default', 'deferred', 'do',
      'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
      'factory', 'false', 'final', 'finally', 'for', 'function', 'get', 'hide',
      'if', 'implements', 'import', 'in', 'interface', 'is', 'library', 'mixin',
      'new', 'null', 'of', 'on', 'operator', 'part', 'required', 'rethrow',
      'return', 'set', 'show', 'static', 'super', 'switch', 'sync', 'this',
      'throw', 'true', 'try', 'typedef', 'var', 'void', 'while', 'with', 'yield',
    };
    return reservedWords.contains(word.toLowerCase());
  }

  /// Validate configuration before generating project.
  List<String> _validateConfig(AppConfig config) {
    final warnings = <String>[];
    
    // Validate app name
    if (config.appName.isEmpty) {
      warnings.add('App name cannot be empty');
    }
    
    // Check if app name would be a reserved word (before conversion)
    final sanitizedAppName = FileUtils.toSnakeCase(config.appName);
    if (_isDartReservedWord(sanitizedAppName)) {
      warnings.add('App name "$config.appName" contains a Dart reserved word ("$sanitizedAppName"). It will be automatically converted to "${sanitizedAppName}_app" in the package name.');
    }
    
    // Validate package name format
    final packageNameParts = config.packageName.split('.');
    if (packageNameParts.isEmpty) {
      warnings.add('Package name is invalid');
    } else {
      // Check each part of the package name
      for (final part in packageNameParts) {
        if (part.isEmpty) {
          warnings.add('Package name contains empty segments');
          break;
        }
        
        // Check if it matches Dart identifier rules
        if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(part)) {
          warnings.add('Package name segment "$part" is invalid. Must start with lowercase letter and contain only [a-z0-9_]');
        }
      }
    }
    
    // Validate output directory
    if (config.outputDirectory.isEmpty) {
      warnings.add('Output directory cannot be empty');
    }
    
    return warnings;
  }

  AppConfig _parseArgsToConfig() {
    final appName = argResults!['name'] as String? ?? 'my_app';
    final org = argResults!['org'] as String;
    final outputDir = argResults!['output'] as String;
    final platformNames = argResults!['platforms'] as List<String>;
    final moduleNames = argResults!['modules'] as List<String>;
    final stateName = argResults!['state'] as String;
    final color = argResults!['color'] as String;
    final firebase = argResults!['firebase'] as bool;
    final git = argResults!['git'] as bool;
    final splash = argResults!['splash'] as bool;
    final onboarding = argResults!['onboarding'] as bool;
    final bottomNavInput = argResults!['bottom-nav'] as List<String>? ?? [];

    final platforms = platformNames
        .map((p) => Platform.values.firstWhere(
              (e) => e.name == p.toLowerCase(),
              orElse: () => Platform.android,
            ))
        .toList();

    final modules = moduleNames
        .map((m) => KiroModule.values.firstWhere(
              (e) => e.name == m.toLowerCase(),
              orElse: () => KiroModule.auth,
            ))
        .toList();

    final stateManagement = StateManagement.values.firstWhere(
      (e) => e.name == stateName.toLowerCase(),
      orElse: () => StateManagement.riverpod,
    );

    // Generate validated package name
    final validatedPackageName = AppConfig.generatePackageName(appName, org);
    
    // Bottom nav tabs (home is always included)
    final bottomNavTabs = <String>['home'];
    if (bottomNavInput.isNotEmpty) {
      // Use provided bottom nav tabs
      for (final tab in bottomNavInput) {
        final tabName = tab.trim().toLowerCase();
        if (tabName.isNotEmpty && tabName != 'home') {
          // Validate that the module exists
          if (modules.any((m) => m.name == tabName)) {
            bottomNavTabs.add(tabName);
          }
        }
      }
    } else {
      // Default: add chat and profile if they exist
      if (modules.contains(KiroModule.chat)) {
        bottomNavTabs.add('chat');
      }
      if (modules.contains(KiroModule.profile)) {
        bottomNavTabs.add('profile');
      }
    }
    
    return AppConfig(
      appName: appName,
      packageName: validatedPackageName,
      description: 'A new Flutter application powered by Kiro.',
      organization: org,
      platforms: platforms,
      modules: modules,
      stateManagement: stateManagement,
      primaryColor: color,
      useFirebase: firebase,
      initGit: git,
      outputDirectory: FileUtils.absolute(outputDir),
      includeSplash: splash,
      includeOnboarding: onboarding,
      bottomNavTabs: bottomNavTabs,
    );
  }
}

