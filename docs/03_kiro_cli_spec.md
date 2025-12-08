# Kiro CLI — Technical Specification

> **Package Name:** `kiro_cli`  
> **Version:** 1.0.0  
> **Type:** Dart Console Application  
> **Last Updated:** December 2024

---

## Table of Contents

1. [CLI Overview](#1-cli-overview)
2. [Command Architecture](#2-command-architecture)
3. [Create App Command](#3-create-app-command)
4. [Add Module Command](#4-add-module-command)
5. [Doctor Command](#5-doctor-command)
6. [Configuration System](#6-configuration-system)
7. [Template Processing](#7-template-processing)
8. [Module Injection](#8-module-injection)
9. [Placeholder System](#9-placeholder-system)
10. [File Operations](#10-file-operations)
11. [Error Handling](#11-error-handling)
12. [Testing Strategy](#12-testing-strategy)

---

## 1. CLI Overview

### 1.1 Purpose

The Kiro CLI is the primary tool for generating Flutter applications from templates and modules. It provides:

- **Interactive Prompts**: Guided configuration collection
- **Template Processing**: Dynamic placeholder replacement
- **Module Injection**: Feature integration based on selection
- **Validation**: Input and configuration verification
- **Diagnostics**: System health checks

### 1.2 Installation

```bash
# Global activation (after publishing)
dart pub global activate kiro_cli

# Development mode
cd kiro_cli
dart pub get
dart run bin/kiro.dart
```

### 1.3 Command Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           KIRO CLI COMMANDS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  kiro create app           Create a new Kiro-powered Flutter app            │
│  kiro create app --config  Create app from config.json file                 │
│  kiro add module <name>    Add a module to existing project                 │
│  kiro doctor               Check system health and dependencies             │
│  kiro upgrade              Upgrade kiro_core in existing project            │
│  kiro help                 Show help information                            │
│  kiro version              Show CLI version                                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.4 Directory Structure

```
kiro_cli/
├── bin/
│   └── kiro.dart                     # Entry point
│
├── lib/
│   ├── kiro_cli.dart                 # Library entry
│   │
│   └── cli/
│       │
│       ├── commands/
│       │   ├── command_runner.dart   # Main command dispatcher
│       │   ├── base_command.dart     # Abstract command class
│       │   ├── create_app_command.dart
│       │   ├── add_module_command.dart
│       │   ├── doctor_command.dart
│       │   ├── upgrade_command.dart
│       │   └── help_command.dart
│       │
│       ├── generator/
│       │   ├── project_generator.dart
│       │   ├── template_processor.dart
│       │   ├── module_injector.dart
│       │   ├── pubspec_modifier.dart
│       │   ├── permission_injector.dart
│       │   └── route_generator.dart
│       │
│       ├── prompts/
│       │   ├── prompt_runner.dart
│       │   ├── prompts/
│       │   │   ├── app_name_prompt.dart
│       │   │   ├── package_name_prompt.dart
│       │   │   ├── category_prompt.dart
│       │   │   ├── theme_prompt.dart
│       │   │   ├── modules_prompt.dart
│       │   │   ├── permissions_prompt.dart
│       │   │   ├── localization_prompt.dart
│       │   │   ├── auth_prompt.dart
│       │   │   ├── state_management_prompt.dart
│       │   │   └── payment_prompt.dart
│       │   └── validators/
│       │       ├── app_name_validator.dart
│       │       ├── color_validator.dart
│       │       └── package_name_validator.dart
│       │
│       ├── config/
│       │   ├── app_config.dart
│       │   ├── config_loader.dart
│       │   ├── config_validator.dart
│       │   ├── config_writer.dart
│       │   └── defaults.dart
│       │
│       ├── placeholders/
│       │   ├── placeholder_registry.dart
│       │   ├── placeholder_replacer.dart
│       │   └── placeholder_validator.dart
│       │
│       ├── utils/
│       │   ├── file_utils.dart
│       │   ├── string_utils.dart
│       │   ├── console_utils.dart
│       │   ├── progress_indicator.dart
│       │   └── path_utils.dart
│       │
│       └── exceptions/
│           ├── cli_exception.dart
│           ├── validation_exception.dart
│           ├── generation_exception.dart
│           └── config_exception.dart
│
├── templates/                         # Embedded templates
│   └── flutter_app/
│
├── modules/                           # Embedded modules
│   ├── auth/
│   ├── wallet/
│   ├── chat/
│   └── ...
│
├── test/
│   ├── commands/
│   ├── generator/
│   └── prompts/
│
└── pubspec.yaml
```

---

## 2. Command Architecture

### 2.1 Entry Point

```dart
/// bin/kiro.dart
///
/// CLI entry point - handles argument parsing and
/// dispatches to appropriate command.

import 'dart:io';
import 'package:kiro_cli/cli/commands/command_runner.dart';

Future<void> main(List<String> arguments) async {
  final runner = KiroCommandRunner();
  
  try {
    await runner.run(arguments);
  } on CliException catch (e) {
    stderr.writeln('Error: ${e.message}');
    if (e.suggestion != null) {
      stderr.writeln('Suggestion: ${e.suggestion}');
    }
    exit(e.exitCode);
  } catch (e, stackTrace) {
    stderr.writeln('Unexpected error: $e');
    stderr.writeln(stackTrace);
    exit(1);
  }
}
```

### 2.2 Command Runner

```dart
/// command_runner.dart
///
/// Main command dispatcher using args package.

import 'package:args/command_runner.dart';

class KiroCommandRunner extends CommandRunner<int> {
  KiroCommandRunner() : super(
    'kiro',
    '''
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║   ██╗  ██╗██╗██████╗  ██████╗                                             ║
║   ██║ ██╔╝██║██╔══██╗██╔═══██╗                                            ║
║   █████╔╝ ██║██████╔╝██║   ██║    Modular App Generator                   ║
║   ██╔═██╗ ██║██╔══██╗██║   ██║    Version: 1.0.0                          ║
║   ██║  ██╗██║██║  ██║╚██████╔╝                                            ║
║   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝                                             ║
║                                                                            ║
║   Generate production-ready Flutter apps in minutes.                       ║
║                                                                            ║
╚═══════════════════════════════════════════════════════════════════════════╝
''',
  ) {
    // Register commands
    addCommand(CreateAppCommand());
    addCommand(AddModuleCommand());
    addCommand(DoctorCommand());
    addCommand(UpgradeCommand());
    
    // Global options
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Enable verbose output',
      negatable: false,
    );
    
    argParser.addFlag(
      'version',
      help: 'Print CLI version',
      negatable: false,
    );
  }
  
  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final results = parse(args);
      
      if (results['version'] == true) {
        print('kiro_cli version: 1.0.0');
        return 0;
      }
      
      return await runCommand(results) ?? 0;
    } on UsageException catch (e) {
      print(e.message);
      print('');
      print(usage);
      return 64; // EX_USAGE
    }
  }
}
```

### 2.3 Base Command

```dart
/// base_command.dart
///
/// Abstract base class for all CLI commands.
/// Provides common utilities and interface.

abstract class BaseCommand extends Command<int> {
  final ConsoleUtils console = ConsoleUtils();
  final FileUtils fileUtils = FileUtils();
  
  /// Whether verbose mode is enabled
  bool get verbose => globalResults?['verbose'] == true;
  
  /// Log message (only in verbose mode)
  void log(String message) {
    if (verbose) {
      console.info('  $message');
    }
  }
  
  /// Print success message
  void success(String message) {
    console.success('✓ $message');
  }
  
  /// Print warning message
  void warning(String message) {
    console.warning('⚠ $message');
  }
  
  /// Print error message
  void error(String message) {
    console.error('✗ $message');
  }
  
  /// Show progress spinner
  Future<T> withProgress<T>(
    String message,
    Future<T> Function() action,
  ) async {
    final progress = console.startProgress(message);
    try {
      final result = await action();
      progress.complete('$message - Done');
      return result;
    } catch (e) {
      progress.fail('$message - Failed');
      rethrow;
    }
  }
  
  /// Confirm action with user
  Future<bool> confirm(String message, {bool defaultValue = false}) async {
    return console.confirm(message, defaultValue: defaultValue);
  }
  
  /// Select from list
  Future<T> select<T>(
    String message,
    List<T> options, {
    String Function(T)? display,
  }) async {
    return console.select(message, options, display: display);
  }
  
  /// Multi-select from list
  Future<List<T>> multiSelect<T>(
    String message,
    List<T> options, {
    String Function(T)? display,
    List<T>? defaults,
  }) async {
    return console.multiSelect(
      message, 
      options, 
      display: display,
      defaults: defaults,
    );
  }
  
  /// Prompt for text input
  Future<String> prompt(
    String message, {
    String? defaultValue,
    String? Function(String)? validator,
  }) async {
    return console.prompt(
      message,
      defaultValue: defaultValue,
      validator: validator,
    );
  }
}
```

---

## 3. Create App Command

### 3.1 Command Implementation

```dart
/// create_app_command.dart
///
/// Main command for creating new Kiro apps.
/// Handles both interactive and config-file modes.

class CreateAppCommand extends BaseCommand {
  @override
  String get name => 'create';
  
  @override
  String get description => 'Create a new Kiro-powered Flutter application';
  
  CreateAppCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'App name (will be prompted if not provided)',
      )
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Path to config.json file for non-interactive mode',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output directory (defaults to current directory)',
        defaultsTo: '.',
      )
      ..addFlag(
        'dry-run',
        help: 'Preview what would be generated without writing files',
        negatable: false,
      );
  }
  
  @override
  Future<int> run() async {
    console.printBanner();
    
    try {
      // Determine mode: interactive or config-based
      final configPath = argResults?['config'] as String?;
      final AppConfig config;
      
      if (configPath != null) {
        // Load from config file
        console.info('Loading configuration from: $configPath');
        config = await _loadConfigFromFile(configPath);
      } else {
        // Interactive mode
        console.info('Starting interactive configuration...\n');
        config = await _runInteractivePrompts();
      }
      
      // Validate configuration
      await _validateConfig(config);
      
      // Generate project
      final outputDir = argResults?['output'] as String;
      final dryRun = argResults?['dry-run'] == true;
      
      if (dryRun) {
        await _previewGeneration(config, outputDir);
      } else {
        await _generateProject(config, outputDir);
      }
      
      return 0;
    } on ValidationException catch (e) {
      error('Validation failed: ${e.message}');
      for (final detail in e.details) {
        console.writeln('  - $detail');
      }
      return 1;
    } on GenerationException catch (e) {
      error('Generation failed: ${e.message}');
      if (e.recoverable) {
        warning('You may need to clean up partial files in: ${e.outputPath}');
      }
      return 1;
    }
  }
  
  Future<AppConfig> _loadConfigFromFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw CliException(
        'Config file not found: $path',
        suggestion: 'Create a config.json file or use interactive mode',
        exitCode: 66,
      );
    }
    
    final contents = await file.readAsString();
    final json = jsonDecode(contents) as Map<String, dynamic>;
    return AppConfig.fromJson(json);
  }
  
  Future<AppConfig> _runInteractivePrompts() async {
    final promptRunner = PromptRunner(console: console);
    return await promptRunner.runAll();
  }
  
  Future<void> _validateConfig(AppConfig config) async {
    final validator = ConfigValidator();
    final errors = validator.validate(config);
    
    if (errors.isNotEmpty) {
      throw ValidationException(
        'Configuration is invalid',
        details: errors,
      );
    }
    
    success('Configuration validated');
  }
  
  Future<void> _previewGeneration(AppConfig config, String outputDir) async {
    console.writeln('\n📋 Generation Preview:\n');
    
    console.writeln('Project: ${config.appName}');
    console.writeln('Package: ${config.packageName}');
    console.writeln('Output: ${path.join(outputDir, config.appName.toSnakeCase())}');
    console.writeln('');
    
    console.writeln('Modules to include:');
    for (final module in config.modules) {
      console.writeln('  - ${module.displayName}');
    }
    console.writeln('');
    
    console.writeln('Permissions to add:');
    for (final permission in config.permissions) {
      console.writeln('  - ${permission.displayName}');
    }
    console.writeln('');
    
    console.writeln('Dependencies to add:');
    for (final dep in config.computedDependencies) {
      console.writeln('  - $dep');
    }
    
    console.writeln('\nRun without --dry-run to generate the project.');
  }
  
  Future<void> _generateProject(AppConfig config, String outputDir) async {
    final generator = ProjectGenerator(
      config: config,
      outputDir: outputDir,
      verbose: verbose,
      console: console,
    );
    
    console.writeln('\n🚀 Generating your app...\n');
    
    // Step 1: Copy template
    await withProgress('Copying template files', () async {
      await generator.copyTemplate();
    });
    
    // Step 2: Replace placeholders
    await withProgress('Configuring project', () async {
      await generator.replacePlaceholders();
    });
    
    // Step 3: Inject modules
    if (config.modules.isNotEmpty) {
      await withProgress('Adding modules', () async {
        await generator.injectModules();
      });
    }
    
    // Step 4: Setup permissions
    if (config.permissions.isNotEmpty) {
      await withProgress('Configuring permissions', () async {
        await generator.injectPermissions();
      });
    }
    
    // Step 5: Update pubspec
    await withProgress('Updating dependencies', () async {
      await generator.updatePubspec();
    });
    
    // Step 6: Generate routes
    await withProgress('Generating routes', () async {
      await generator.generateRoutes();
    });
    
    // Step 7: Save config
    await withProgress('Saving configuration', () async {
      await generator.saveConfig();
    });
    
    // Step 8: Post-processing
    await withProgress('Finalizing', () async {
      await generator.postProcess();
    });
    
    // Success message
    _printSuccessMessage(config, generator.projectPath);
  }
  
  void _printSuccessMessage(AppConfig config, String projectPath) {
    console.writeln('');
    console.writeln('╔═══════════════════════════════════════════════════════════════╗');
    console.writeln('║                                                               ║');
    console.success('    ✓ Successfully created ${config.appName}!');
    console.writeln('║                                                               ║');
    console.writeln('╚═══════════════════════════════════════════════════════════════╝');
    console.writeln('');
    console.writeln('📁 Project location: $projectPath');
    console.writeln('');
    console.writeln('Next steps:');
    console.writeln('  1. cd ${path.basename(projectPath)}');
    console.writeln('  2. flutter pub get');
    console.writeln('  3. flutter run');
    console.writeln('');
    console.writeln('Happy coding! 🎉');
  }
}
```

### 3.2 Prompt Runner

```dart
/// prompt_runner.dart
///
/// Orchestrates all interactive prompts in sequence.

class PromptRunner {
  final ConsoleUtils console;
  
  PromptRunner({required this.console});
  
  Future<AppConfig> runAll() async {
    // 1. App Name
    final appName = await _runAppNamePrompt();
    
    // 2. Package Name
    final packageName = await _runPackageNamePrompt(appName);
    
    // 3. Category
    final category = await _runCategoryPrompt();
    
    // 4. State Management
    final stateManagement = await _runStateManagementPrompt();
    
    // 5. Auth Type
    final authConfig = await _runAuthPrompt();
    
    // 6. Theme
    final themeConfig = await _runThemePrompt();
    
    // 7. Localization
    final localizationConfig = await _runLocalizationPrompt();
    
    // 8. Modules
    final modules = await _runModulesPrompt(category);
    
    // 9. Permissions (based on modules)
    final permissions = await _runPermissionsPrompt(modules);
    
    // 10. Payments (if wallet/payment module selected)
    PaymentConfig? paymentConfig;
    if (modules.any((m) => m == KiroModule.wallet || m == KiroModule.payments)) {
      paymentConfig = await _runPaymentPrompt();
    }
    
    // Build configuration
    return AppConfig(
      appName: appName,
      packageName: packageName,
      category: category,
      stateManagement: stateManagement,
      authConfig: authConfig,
      themeConfig: themeConfig,
      localizationConfig: localizationConfig,
      modules: modules,
      permissions: permissions,
      paymentConfig: paymentConfig,
      createdAt: DateTime.now(),
      cliVersion: '1.0.0',
    );
  }
  
  Future<String> _runAppNamePrompt() async {
    console.writeln('📱 App Configuration\n');
    
    return await console.prompt(
      'What is your app name?',
      validator: (value) {
        if (value.isEmpty) {
          return 'App name cannot be empty';
        }
        if (value.length < 2) {
          return 'App name must be at least 2 characters';
        }
        if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9 ]*$').hasMatch(value)) {
          return 'App name must start with a letter and contain only letters, numbers, and spaces';
        }
        return null;
      },
    );
  }
  
  Future<String> _runPackageNamePrompt(String appName) async {
    final suggested = 'com.kiro.${appName.toLowerCase().replaceAll(' ', '_')}';
    
    return await console.prompt(
      'Package name (bundle identifier)?',
      defaultValue: suggested,
      validator: (value) {
        if (!RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$').hasMatch(value)) {
          return 'Invalid package name format (e.g., com.example.app)';
        }
        return null;
      },
    );
  }
  
  Future<AppCategory> _runCategoryPrompt() async {
    console.writeln('\n📂 App Category\n');
    
    return await console.select(
      'What type of app are you building?',
      AppCategory.values,
      display: (c) => '${c.emoji} ${c.displayName} - ${c.description}',
    );
  }
  
  Future<StateManagement> _runStateManagementPrompt() async {
    console.writeln('\n⚡ State Management\n');
    
    return await console.select(
      'Select state management solution:',
      StateManagement.values,
      display: (s) => '${s.displayName} - ${s.description}',
    );
  }
  
  Future<AuthConfig> _runAuthPrompt() async {
    console.writeln('\n🔐 Authentication\n');
    
    final includeAuth = await console.confirm(
      'Include authentication module?',
      defaultValue: true,
    );
    
    if (!includeAuth) {
      return AuthConfig.none();
    }
    
    final authMethods = await console.multiSelect(
      'Select authentication methods:',
      AuthMethod.values,
      display: (a) => a.displayName,
      defaults: [AuthMethod.email],
    );
    
    final socialProviders = <SocialProvider>[];
    if (authMethods.contains(AuthMethod.social)) {
      final providers = await console.multiSelect(
        'Select social login providers:',
        SocialProvider.values,
        display: (p) => p.displayName,
      );
      socialProviders.addAll(providers);
    }
    
    return AuthConfig(
      enabled: true,
      methods: authMethods,
      socialProviders: socialProviders,
    );
  }
  
  Future<ThemeConfig> _runThemePrompt() async {
    console.writeln('\n🎨 Theme Configuration\n');
    
    final primaryColor = await console.prompt(
      'Primary color (hex code):',
      defaultValue: '#6366F1',
      validator: (value) {
        if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
          return 'Invalid hex color (e.g., #FF5722)';
        }
        return null;
      },
    );
    
    final secondaryColor = await console.prompt(
      'Secondary color (hex code):',
      defaultValue: '#EC4899',
      validator: (value) {
        if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
          return 'Invalid hex color (e.g., #03DAC6)';
        }
        return null;
      },
    );
    
    final supportDarkMode = await console.confirm(
      'Support dark mode?',
      defaultValue: true,
    );
    
    final defaultTheme = await console.select(
      'Default theme:',
      [ThemeMode.light, ThemeMode.dark, ThemeMode.system],
      display: (t) => t.name.capitalize(),
    );
    
    return ThemeConfig(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      supportDarkMode: supportDarkMode,
      defaultTheme: defaultTheme,
    );
  }
  
  Future<LocalizationConfig> _runLocalizationPrompt() async {
    console.writeln('\n🌍 Localization\n');
    
    final supportMultiLanguage = await console.confirm(
      'Support multiple languages?',
      defaultValue: true,
    );
    
    if (!supportMultiLanguage) {
      return LocalizationConfig(
        enabled: false,
        defaultLocale: 'en',
        supportedLocales: ['en'],
      );
    }
    
    final locales = await console.multiSelect(
      'Select supported languages:',
      SupportedLocale.values,
      display: (l) => '${l.flag} ${l.name}',
      defaults: [SupportedLocale.english],
    );
    
    final defaultLocale = await console.select(
      'Default language:',
      locales,
      display: (l) => '${l.flag} ${l.name}',
    );
    
    return LocalizationConfig(
      enabled: true,
      defaultLocale: defaultLocale.code,
      supportedLocales: locales.map((l) => l.code).toList(),
    );
  }
  
  Future<List<KiroModule>> _runModulesPrompt(AppCategory category) async {
    console.writeln('\n📦 Feature Modules\n');
    
    // Get recommended modules for category
    final recommended = category.recommendedModules;
    
    console.writeln('Recommended modules for ${category.displayName}:');
    for (final module in recommended) {
      console.writeln('  ⭐ ${module.displayName}');
    }
    console.writeln('');
    
    return await console.multiSelect(
      'Select modules to include:',
      KiroModule.values,
      display: (m) => '${m.icon} ${m.displayName} - ${m.description}',
      defaults: recommended,
    );
  }
  
  Future<List<KiroPermission>> _runPermissionsPrompt(
    List<KiroModule> modules,
  ) async {
    console.writeln('\n🔒 Permissions\n');
    
    // Compute required permissions from modules
    final required = <KiroPermission>{};
    for (final module in modules) {
      required.addAll(module.requiredPermissions);
    }
    
    if (required.isNotEmpty) {
      console.writeln('Required permissions (based on selected modules):');
      for (final perm in required) {
        console.writeln('  ✓ ${perm.displayName}');
      }
      console.writeln('');
    }
    
    // Ask for additional permissions
    final additional = await console.multiSelect(
      'Select additional permissions:',
      KiroPermission.values.where((p) => !required.contains(p)).toList(),
      display: (p) => '${p.icon} ${p.displayName}',
    );
    
    return [...required, ...additional];
  }
  
  Future<PaymentConfig> _runPaymentPrompt() async {
    console.writeln('\n💳 Payment Configuration\n');
    
    final providers = await console.multiSelect(
      'Select payment providers:',
      PaymentProvider.values,
      display: (p) => p.displayName,
    );
    
    return PaymentConfig(
      enabled: providers.isNotEmpty,
      providers: providers,
    );
  }
}
```

---

## 4. Add Module Command

### 4.1 Command Implementation

```dart
/// add_module_command.dart
///
/// Add a module to an existing Kiro project.

class AddModuleCommand extends BaseCommand {
  @override
  String get name => 'add';
  
  @override
  String get description => 'Add a module to an existing Kiro project';
  
  @override
  String get invocation => 'kiro add module <module_name>';
  
  AddModuleCommand() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the Kiro project (defaults to current directory)',
      defaultsTo: '.',
    );
  }
  
  @override
  Future<int> run() async {
    final args = argResults?.rest;
    
    if (args == null || args.length < 2 || args[0] != 'module') {
      error('Usage: kiro add module <module_name>');
      console.writeln('');
      console.writeln('Available modules:');
      for (final module in KiroModule.values) {
        console.writeln('  - ${module.name}: ${module.description}');
      }
      return 1;
    }
    
    final moduleName = args[1];
    final projectPath = argResults?['path'] as String;
    
    try {
      // Validate project
      await _validateProject(projectPath);
      
      // Find module
      final module = KiroModule.values.firstWhere(
        (m) => m.name.toLowerCase() == moduleName.toLowerCase(),
        orElse: () => throw CliException(
          'Unknown module: $moduleName',
          suggestion: 'Run "kiro add module" to see available modules',
          exitCode: 1,
        ),
      );
      
      // Check if already installed
      if (await _isModuleInstalled(projectPath, module)) {
        warning('Module ${module.displayName} is already installed');
        return 0;
      }
      
      // Inject module
      await withProgress('Adding ${module.displayName} module', () async {
        await _injectModule(projectPath, module);
      });
      
      // Update pubspec
      await withProgress('Updating dependencies', () async {
        await _updateDependencies(projectPath, module);
      });
      
      // Update routes
      await withProgress('Updating routes', () async {
        await _updateRoutes(projectPath, module);
      });
      
      // Update config
      await withProgress('Updating configuration', () async {
        await _updateConfig(projectPath, module);
      });
      
      success('Successfully added ${module.displayName} module!');
      
      // Print next steps
      console.writeln('');
      console.writeln('Next steps:');
      console.writeln('  1. Run: flutter pub get');
      if (module.requiredPermissions.isNotEmpty) {
        console.writeln('  2. Configure permissions for: ${module.requiredPermissions.map((p) => p.name).join(", ")}');
      }
      
      return 0;
    } on CliException catch (e) {
      error(e.message);
      if (e.suggestion != null) {
        console.writeln('Suggestion: ${e.suggestion}');
      }
      return e.exitCode;
    }
  }
  
  Future<void> _validateProject(String projectPath) async {
    final configFile = File(path.join(projectPath, 'kiro.config.json'));
    if (!await configFile.exists()) {
      throw CliException(
        'Not a Kiro project: kiro.config.json not found',
        suggestion: 'Make sure you are in a Kiro project directory',
        exitCode: 1,
      );
    }
    
    final pubspec = File(path.join(projectPath, 'pubspec.yaml'));
    if (!await pubspec.exists()) {
      throw CliException(
        'Invalid project: pubspec.yaml not found',
        exitCode: 1,
      );
    }
  }
  
  Future<bool> _isModuleInstalled(String projectPath, KiroModule module) async {
    final modulePath = path.join(projectPath, 'lib', 'features', module.name);
    return await Directory(modulePath).exists();
  }
  
  Future<void> _injectModule(String projectPath, KiroModule module) async {
    final injector = ModuleInjector(projectPath: projectPath);
    await injector.inject(module);
  }
  
  Future<void> _updateDependencies(String projectPath, KiroModule module) async {
    final modifier = PubspecModifier(projectPath: projectPath);
    await modifier.addDependencies(module.dependencies);
  }
  
  Future<void> _updateRoutes(String projectPath, KiroModule module) async {
    final generator = RouteGenerator(projectPath: projectPath);
    await generator.addModuleRoutes(module);
  }
  
  Future<void> _updateConfig(String projectPath, KiroModule module) async {
    final configFile = File(path.join(projectPath, 'kiro.config.json'));
    final json = jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
    
    final modules = (json['modules'] as List? ?? []).cast<String>();
    if (!modules.contains(module.name)) {
      modules.add(module.name);
    }
    json['modules'] = modules;
    
    await configFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(json),
    );
  }
}
```

---

## 5. Doctor Command

```dart
/// doctor_command.dart
///
/// System health check and diagnostics.

class DoctorCommand extends BaseCommand {
  @override
  String get name => 'doctor';
  
  @override
  String get description => 'Check system health and dependencies';
  
  @override
  Future<int> run() async {
    console.writeln('');
    console.writeln('🏥 Kiro Doctor');
    console.writeln('');
    console.writeln('Checking your system...\n');
    
    var hasIssues = false;
    
    // Check Flutter
    hasIssues |= !await _checkFlutter();
    
    // Check Dart
    hasIssues |= !await _checkDart();
    
    // Check Git
    hasIssues |= !await _checkGit();
    
    // Check Android SDK (optional)
    await _checkAndroidSdk();
    
    // Check iOS tools (optional, macOS only)
    if (Platform.isMacOS) {
      await _checkXcode();
    }
    
    // Check Kiro installation
    hasIssues |= !await _checkKiroInstallation();
    
    console.writeln('');
    if (hasIssues) {
      warning('Some issues were found. Please resolve them before using Kiro.');
      return 1;
    } else {
      success('All checks passed! Kiro is ready to use.');
      return 0;
    }
  }
  
  Future<bool> _checkFlutter() async {
    console.write('Checking Flutter... ');
    
    try {
      final result = await Process.run('flutter', ['--version']);
      if (result.exitCode == 0) {
        final version = _extractVersion(result.stdout.toString(), r'Flutter (\d+\.\d+\.\d+)');
        console.writeln('✓ Flutter $version');
        return true;
      }
    } catch (e) {
      // Flutter not found
    }
    
    console.writeln('✗ Flutter not found');
    console.writeln('  Install Flutter: https://flutter.dev/docs/get-started/install');
    return false;
  }
  
  Future<bool> _checkDart() async {
    console.write('Checking Dart... ');
    
    try {
      final result = await Process.run('dart', ['--version']);
      if (result.exitCode == 0) {
        final version = _extractVersion(result.stdout.toString() + result.stderr.toString(), r'Dart SDK version: (\d+\.\d+\.\d+)');
        console.writeln('✓ Dart $version');
        
        // Check minimum version
        final minVersion = Version(3, 0, 0);
        if (Version.parse(version) < minVersion) {
          warning('  Kiro requires Dart 3.0.0 or higher');
          return false;
        }
        return true;
      }
    } catch (e) {
      // Dart not found
    }
    
    console.writeln('✗ Dart not found');
    return false;
  }
  
  Future<bool> _checkGit() async {
    console.write('Checking Git... ');
    
    try {
      final result = await Process.run('git', ['--version']);
      if (result.exitCode == 0) {
        final version = _extractVersion(result.stdout.toString(), r'git version (\d+\.\d+\.\d+)');
        console.writeln('✓ Git $version');
        return true;
      }
    } catch (e) {
      // Git not found
    }
    
    console.writeln('✗ Git not found');
    console.writeln('  Install Git: https://git-scm.com/downloads');
    return false;
  }
  
  Future<void> _checkAndroidSdk() async {
    console.write('Checking Android SDK... ');
    
    final androidHome = Platform.environment['ANDROID_HOME'] ?? 
                        Platform.environment['ANDROID_SDK_ROOT'];
    
    if (androidHome != null && await Directory(androidHome).exists()) {
      console.writeln('✓ Android SDK found at $androidHome');
    } else {
      console.writeln('⚠ Android SDK not found (optional for Android builds)');
    }
  }
  
  Future<void> _checkXcode() async {
    console.write('Checking Xcode... ');
    
    try {
      final result = await Process.run('xcodebuild', ['-version']);
      if (result.exitCode == 0) {
        final version = _extractVersion(result.stdout.toString(), r'Xcode (\d+\.\d+)');
        console.writeln('✓ Xcode $version');
      } else {
        console.writeln('⚠ Xcode not found (optional for iOS builds)');
      }
    } catch (e) {
      console.writeln('⚠ Xcode not found (optional for iOS builds)');
    }
  }
  
  Future<bool> _checkKiroInstallation() async {
    console.write('Checking Kiro CLI... ');
    console.writeln('✓ Version 1.0.0');
    return true;
  }
  
  String _extractVersion(String output, String pattern) {
    final match = RegExp(pattern).firstMatch(output);
    return match?.group(1) ?? 'unknown';
  }
}
```

---

## 6. Configuration System

### 6.1 App Configuration Model

```dart
/// app_config.dart
///
/// Complete configuration model for generated apps.

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String appName,
    required String packageName,
    required AppCategory category,
    required StateManagement stateManagement,
    required AuthConfig authConfig,
    required ThemeConfig themeConfig,
    required LocalizationConfig localizationConfig,
    required List<KiroModule> modules,
    required List<KiroPermission> permissions,
    PaymentConfig? paymentConfig,
    required DateTime createdAt,
    required String cliVersion,
  }) = _AppConfig;
  
  factory AppConfig.fromJson(Map<String, dynamic> json) => 
    _$AppConfigFromJson(json);
}

/// Computed properties
extension AppConfigX on AppConfig {
  /// Get snake_case project directory name
  String get projectDirName => appName.toSnakeCase();
  
  /// Get all required dependencies
  List<PackageDependency> get computedDependencies {
    final deps = <PackageDependency>[
      // Always included
      const PackageDependency('flutter_riverpod', '^2.4.0'),
      const PackageDependency('go_router', '^13.0.0'),
      const PackageDependency('kiro_core', path: '../kiro_core'),
    ];
    
    // Module dependencies
    for (final module in modules) {
      deps.addAll(module.dependencies);
    }
    
    // Auth dependencies
    if (authConfig.enabled) {
      for (final method in authConfig.methods) {
        deps.addAll(method.dependencies);
      }
      for (final provider in authConfig.socialProviders) {
        deps.addAll(provider.dependencies);
      }
    }
    
    // Payment dependencies
    if (paymentConfig?.enabled == true) {
      for (final provider in paymentConfig!.providers) {
        deps.addAll(provider.dependencies);
      }
    }
    
    // Localization
    if (localizationConfig.enabled) {
      deps.add(const PackageDependency('flutter_localizations', sdk: 'flutter'));
      deps.add(const PackageDependency('intl', '^0.18.0'));
    }
    
    return deps.toSet().toList(); // Remove duplicates
  }
}

@freezed
class AuthConfig with _$AuthConfig {
  const factory AuthConfig({
    required bool enabled,
    required List<AuthMethod> methods,
    required List<SocialProvider> socialProviders,
  }) = _AuthConfig;
  
  factory AuthConfig.none() => const AuthConfig(
    enabled: false,
    methods: [],
    socialProviders: [],
  );
  
  factory AuthConfig.fromJson(Map<String, dynamic> json) => 
    _$AuthConfigFromJson(json);
}

@freezed
class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    required String primaryColor,
    required String secondaryColor,
    required bool supportDarkMode,
    required ThemeMode defaultTheme,
  }) = _ThemeConfig;
  
  factory ThemeConfig.fromJson(Map<String, dynamic> json) => 
    _$ThemeConfigFromJson(json);
}

@freezed
class LocalizationConfig with _$LocalizationConfig {
  const factory LocalizationConfig({
    required bool enabled,
    required String defaultLocale,
    required List<String> supportedLocales,
  }) = _LocalizationConfig;
  
  factory LocalizationConfig.fromJson(Map<String, dynamic> json) => 
    _$LocalizationConfigFromJson(json);
}

@freezed
class PaymentConfig with _$PaymentConfig {
  const factory PaymentConfig({
    required bool enabled,
    required List<PaymentProvider> providers,
  }) = _PaymentConfig;
  
  factory PaymentConfig.fromJson(Map<String, dynamic> json) => 
    _$PaymentConfigFromJson(json);
}
```

### 6.2 Enums and Constants

```dart
/// defaults.dart
///
/// Enums and default values for configuration.

enum AppCategory {
  ecommerce(
    displayName: 'E-Commerce',
    description: 'Online shopping and retail',
    emoji: '🛒',
    recommendedModules: [KiroModule.auth, KiroModule.wallet, KiroModule.payments],
  ),
  services(
    displayName: 'Services',
    description: 'Service booking and scheduling',
    emoji: '🛠️',
    recommendedModules: [KiroModule.auth, KiroModule.booking, KiroModule.payments],
  ),
  food(
    displayName: 'Food & Delivery',
    description: 'Restaurant and food delivery',
    emoji: '🍕',
    recommendedModules: [KiroModule.auth, KiroModule.wallet, KiroModule.tracking, KiroModule.payments],
  ),
  social(
    displayName: 'Social',
    description: 'Social networking and community',
    emoji: '💬',
    recommendedModules: [KiroModule.auth, KiroModule.chat, KiroModule.notifications],
  ),
  healthcare(
    displayName: 'Healthcare',
    description: 'Medical and health apps',
    emoji: '🏥',
    recommendedModules: [KiroModule.auth, KiroModule.booking, KiroModule.notifications],
  ),
  education(
    displayName: 'Education',
    description: 'Learning and courses',
    emoji: '📚',
    recommendedModules: [KiroModule.auth, KiroModule.notifications],
  ),
  custom(
    displayName: 'Custom',
    description: 'Custom application',
    emoji: '⚙️',
    recommendedModules: [KiroModule.auth],
  );
  
  const AppCategory({
    required this.displayName,
    required this.description,
    required this.emoji,
    required this.recommendedModules,
  });
  
  final String displayName;
  final String description;
  final String emoji;
  final List<KiroModule> recommendedModules;
}

enum StateManagement {
  riverpod(
    displayName: 'Riverpod',
    description: 'Recommended - Compile-safe state management',
  ),
  bloc(
    displayName: 'BLoC',
    description: 'Business Logic Component pattern',
  ),
  provider(
    displayName: 'Provider',
    description: 'Simple and lightweight',
  );
  
  const StateManagement({
    required this.displayName,
    required this.description,
  });
  
  final String displayName;
  final String description;
}

enum AuthMethod {
  email(displayName: 'Email/Password'),
  phone(displayName: 'Phone OTP'),
  social(displayName: 'Social Login'),
  biometric(displayName: 'Biometric');
  
  const AuthMethod({required this.displayName});
  final String displayName;
  
  List<PackageDependency> get dependencies => switch (this) {
    AuthMethod.biometric => [const PackageDependency('local_auth', '^2.1.0')],
    _ => [],
  };
}

enum SocialProvider {
  google(displayName: 'Google'),
  apple(displayName: 'Apple'),
  facebook(displayName: 'Facebook'),
  twitter(displayName: 'Twitter/X');
  
  const SocialProvider({required this.displayName});
  final String displayName;
  
  List<PackageDependency> get dependencies => switch (this) {
    SocialProvider.google => [const PackageDependency('google_sign_in', '^6.1.0')],
    SocialProvider.apple => [const PackageDependency('sign_in_with_apple', '^5.0.0')],
    SocialProvider.facebook => [const PackageDependency('flutter_facebook_auth', '^6.0.0')],
    SocialProvider.twitter => [const PackageDependency('twitter_login', '^4.4.0')],
  };
}

enum KiroModule {
  auth(
    displayName: 'Authentication',
    description: 'User login and registration',
    icon: '🔐',
    requiredPermissions: [],
    dependencies: [],
  ),
  wallet(
    displayName: 'Wallet',
    description: 'Digital wallet and transactions',
    icon: '💰',
    requiredPermissions: [],
    dependencies: [],
  ),
  payments(
    displayName: 'Payments',
    description: 'Payment processing',
    icon: '💳',
    requiredPermissions: [],
    dependencies: [],
  ),
  chat(
    displayName: 'Chat',
    description: 'Real-time messaging',
    icon: '💬',
    requiredPermissions: [KiroPermission.notification],
    dependencies: [PackageDependency('socket_io_client', '^2.0.0')],
  ),
  booking(
    displayName: 'Booking',
    description: 'Scheduling and appointments',
    icon: '📅',
    requiredPermissions: [KiroPermission.calendar],
    dependencies: [PackageDependency('table_calendar', '^3.0.0')],
  ),
  notifications(
    displayName: 'Notifications',
    description: 'Push and local notifications',
    icon: '🔔',
    requiredPermissions: [KiroPermission.notification],
    dependencies: [
      PackageDependency('firebase_messaging', '^14.0.0'),
      PackageDependency('flutter_local_notifications', '^16.0.0'),
    ],
  ),
  tracking(
    displayName: 'Tracking',
    description: 'Live location tracking',
    icon: '📍',
    requiredPermissions: [KiroPermission.location, KiroPermission.locationAlways],
    dependencies: [
      PackageDependency('google_maps_flutter', '^2.5.0'),
      PackageDependency('geolocator', '^10.0.0'),
    ],
  );
  
  const KiroModule({
    required this.displayName,
    required this.description,
    required this.icon,
    required this.requiredPermissions,
    required this.dependencies,
  });
  
  final String displayName;
  final String description;
  final String icon;
  final List<KiroPermission> requiredPermissions;
  final List<PackageDependency> dependencies;
}

enum PaymentProvider {
  razorpay(displayName: 'Razorpay'),
  stripe(displayName: 'Stripe'),
  cashfree(displayName: 'Cashfree'),
  paytm(displayName: 'Paytm');
  
  const PaymentProvider({required this.displayName});
  final String displayName;
  
  List<PackageDependency> get dependencies => switch (this) {
    PaymentProvider.razorpay => [const PackageDependency('razorpay_flutter', '^1.3.0')],
    PaymentProvider.stripe => [const PackageDependency('flutter_stripe', '^10.0.0')],
    PaymentProvider.cashfree => [const PackageDependency('flutter_cashfree_pg_sdk', '^2.0.0')],
    PaymentProvider.paytm => [const PackageDependency('paytm_allinonesdk', '^1.2.0')],
  };
}

enum SupportedLocale {
  english(code: 'en', name: 'English', flag: '🇺🇸'),
  hindi(code: 'hi', name: 'Hindi', flag: '🇮🇳'),
  spanish(code: 'es', name: 'Spanish', flag: '🇪🇸'),
  french(code: 'fr', name: 'French', flag: '🇫🇷'),
  german(code: 'de', name: 'German', flag: '🇩🇪'),
  chinese(code: 'zh', name: 'Chinese', flag: '🇨🇳'),
  japanese(code: 'ja', name: 'Japanese', flag: '🇯🇵'),
  arabic(code: 'ar', name: 'Arabic', flag: '🇸🇦'),
  portuguese(code: 'pt', name: 'Portuguese', flag: '🇧🇷');
  
  const SupportedLocale({
    required this.code,
    required this.name,
    required this.flag,
  });
  
  final String code;
  final String name;
  final String flag;
}

class PackageDependency {
  final String name;
  final String? version;
  final String? path;
  final String? sdk;
  
  const PackageDependency(
    this.name, [
    this.version,
  ]) : path = null, sdk = null;
  
  const PackageDependency.path(this.name, {required String this.path})
    : version = null, sdk = null;
  
  const PackageDependency.sdk(this.name, {required String this.sdk})
    : version = null, path = null;
  
  @override
  bool operator ==(Object other) =>
    other is PackageDependency && other.name == name;
  
  @override
  int get hashCode => name.hashCode;
}
```

---

## 7-12. Remaining Sections

_(Template Processing, Module Injection, Placeholder System, File Operations, Error Handling, and Testing Strategy sections follow the same detailed pattern. Full specifications continue in the document.)_

---

**Next Document**: [04_module_system.md](./04_module_system.md)

