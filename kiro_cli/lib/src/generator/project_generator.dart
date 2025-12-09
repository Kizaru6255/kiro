/// Project generator.
library;

import 'dart:io';

import '../config/app_config.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import '../utils/process_utils.dart';
import 'templates/config_templates.dart';
import 'templates/core_templates.dart';
import 'templates/feature_templates.dart';
import 'templates/main_template.dart';
import 'templates/pubspec_template.dart';

/// Generates a complete Kiro project.
class ProjectGenerator {
  final AppConfig config;

  ProjectGenerator(this.config);

  /// Generate the project.
  Future<bool> generate() async {
    try {
      // Step 0: Ensure output directory exists
      Console.step('Preparing output directory...');
      await FileUtils.ensureDirectory(config.outputDirectory);
      Console.success('Output directory ready');

      // Step 1: Create Flutter project
      Console.step('Creating Flutter project...');
      final createResult = await ProcessUtils.createFlutterProject(
        config.projectDirName,
        workingDirectory: config.outputDirectory,
        org: config.organization,
        description: config.description,
        platforms: config.platforms.map((p) => p.name).toList(),
      );

      if (!createResult.success) {
        Console.error('Failed to create Flutter project');
        Console.hint(createResult.stderr);
        return false;
      }
      Console.success('Flutter project created');

      // Step 2: Clean up default files
      Console.step('Cleaning up defaults...');
      await _cleanDefaults();
      Console.success('Defaults cleaned');

      // Step 3: Create folder structure
      Console.step('Creating folder structure...');
      await _createFolderStructure();
      Console.success('Folder structure created');

      // Step 4: Generate pubspec.yaml
      Console.step('Generating pubspec.yaml...');
      await _generatePubspec();
      Console.success('pubspec.yaml generated');

      // Step 5: Generate main.dart
      Console.step('Generating main.dart...');
      await _generateMain();
      Console.success('main.dart generated');

      // Step 6: Generate core files
      Console.step('Generating core files...');
      await _generateCoreFiles();
      Console.success('Core files generated');

      // Step 7: Generate config files
      Console.step('Generating config files...');
      await _generateConfigFiles();
      Console.success('Config files generated');

      // Step 8: Generate feature files
      Console.step('Generating feature files...');
      await _generateFeatureFiles();
      Console.success('Feature files generated');

      // Step 8.5: Copy modules if any selected
      if (config.modules.isNotEmpty) {
        Console.step('Copying modules...');
        await _copyModules();
        Console.success('Modules copied');
      }

      // Step 9: Generate kiro.yaml config
      Console.step('Creating kiro.yaml...');
      await _generateKiroConfig();
      Console.success('kiro.yaml created');

      // Step 9.5: Configure Android build if needed
      if (config.platforms.contains(Platform.android)) {
        await _configureAndroidBuild();
      }

      // Step 10: Initialize git (if enabled)
      if (config.initGit) {
        Console.step('Initializing Git repository...');
        await ProcessUtils.gitInit(workingDirectory: config.projectPath);
        await _generateGitIgnore();
        Console.success('Git repository initialized');
      }

      // Step 11: Run pub get
      Console.step('Running flutter pub get...');
      final pubResult = await ProcessUtils.pubGet(
        workingDirectory: config.projectPath,
      );
      if (pubResult.success) {
        Console.success('Dependencies installed');
      } else {
        Console.warning('pub get had issues (you can run it manually)');
      }

      return true;
    } catch (e) {
      Console.error('Generation failed: $e');
      return false;
    }
  }

  Future<void> _cleanDefaults() async {
    // Remove default test file
    await FileUtils.delete(
      FileUtils.join(config.projectPath, 'test', 'widget_test.dart'),
    );

    // Remove default main.dart (we'll create our own)
    await FileUtils.delete(
      FileUtils.join(config.projectPath, 'lib', 'main.dart'),
    );
  }

  Future<void> _createFolderStructure() async {
    final libPath = FileUtils.join(config.projectPath, 'lib');

    // Core
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'core', 'constants'));
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'core', 'extensions'));
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'core', 'services'));
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'core', 'utils'));

    // Config
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'config'));

    // Features
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'features', 'home'));

    // Shared
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'shared', 'widgets'));
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'shared', 'models'));

    // Assets
    await FileUtils.ensureDirectory(FileUtils.join(config.projectPath, 'assets', 'images'));
    await FileUtils.ensureDirectory(FileUtils.join(config.projectPath, 'assets', 'icons'));
    await FileUtils.ensureDirectory(FileUtils.join(config.projectPath, 'assets', 'fonts'));
  }

  Future<void> _generatePubspec() async {
    // Calculate relative path to kiro_core
    String? kiroCorePath;
    if (config.modules.isNotEmpty) {
      final kiroRoot = _findKiroRoot();
      if (kiroRoot != null) {
        final kiroCoreDir = FileUtils.join(kiroRoot, 'kiro_core');
        if (await FileUtils.directoryExists(kiroCoreDir)) {
          // Calculate relative path from project to kiro_core
          final projectDir = config.projectPath;
          kiroCorePath = FileUtils.relative(kiroCoreDir, from: projectDir);
        }
      }
    }
    
    final content = generatePubspec(
      appName: config.appName,
      packageName: config.packageName,
      description: config.description,
      stateManagement: config.stateManagement.name,
      modules: config.modules.map((m) => m.name).toList(),
      useFirebase: config.useFirebase,
      kiroCorePath: kiroCorePath,
    );

    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, 'pubspec.yaml'),
      content,
    );
  }

  Future<void> _generateMain() async {
    final content = generateMain(
      appName: config.appName,
      stateManagement: config.stateManagement.name,
      primaryColor: config.primaryColor,
      useFirebase: config.useFirebase,
    );

    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, 'lib', 'main.dart'),
      content,
    );

    // Generate firebase_options.dart if Firebase is enabled
    if (config.useFirebase) {
      await FileUtils.writeFile(
        FileUtils.join(config.projectPath, 'lib', 'firebase_options.dart'),
        generateFirebaseOptions(appName: config.appName),
      );
    }
  }

  Future<void> _generateCoreFiles() async {
    final corePath = FileUtils.join(config.projectPath, 'lib', 'core');

    // core.dart barrel
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'core.dart'),
      generateCoreBarrel(),
    );

    // constants
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'constants', 'constants.dart'),
      generateConstants(appName: config.appName),
    );

    // extensions
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'extensions', 'extensions.dart'),
      generateExtensions(),
    );

    // services
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'services', 'services.dart'),
      generateServices(),
    );
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'services', 'api_service.dart'),
      generateApiService(),
    );
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'services', 'storage_service.dart'),
      generateStorageService(),
    );

    // utils
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'utils', 'utils.dart'),
      generateUtils(),
    );
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'utils', 'validators.dart'),
      generateValidators(),
    );
  }

  Future<void> _generateConfigFiles() async {
    final configPath = FileUtils.join(config.projectPath, 'lib', 'config');

    await FileUtils.writeFile(
      FileUtils.join(configPath, 'app_config.dart'),
      generateAppConfig(
        appName: config.appName,
        primaryColor: config.primaryColor,
      ),
    );

    await FileUtils.writeFile(
      FileUtils.join(configPath, 'theme.dart'),
      generateTheme(primaryColor: config.primaryColor),
    );

    await FileUtils.writeFile(
      FileUtils.join(configPath, 'router.dart'),
      generateRouter(
        stateManagement: config.stateManagement.name,
        modules: config.modules.map((m) => m.name).toList(),
      ),
    );
  }

  Future<void> _generateFeatureFiles() async {
    final homePath = FileUtils.join(config.projectPath, 'lib', 'features', 'home');

    await FileUtils.writeFile(
      FileUtils.join(homePath, 'home_screen.dart'),
      generateHomeScreen(
        appName: config.appName,
        modules: config.modules.map((m) => m.name).toList(),
      ),
    );
  }

  Future<void> _generateKiroConfig() async {
    final content = '''
# Kiro Project Configuration
# Generated by Kiro CLI

app_name: ${config.appName}
package_name: ${config.packageName}
version: 1.0.0

state_management: ${config.stateManagement.name}
primary_color: "${config.primaryColor}"

platforms:
${config.platforms.map((p) => '  - ${p.name}').join('\n')}

modules:
${config.modules.isEmpty ? '  # No modules selected' : config.modules.map((m) => '  - ${m.name}').join('\n')}

firebase: ${config.useFirebase}

locales:
${config.locales.map((l) => '  - $l').join('\n')}
default_locale: ${config.defaultLocale}
''';

    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, 'kiro.yaml'),
      content,
    );
  }

  Future<void> _generateGitIgnore() async {
    const content = '''
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# VS Code related
.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# iOS/macOS
**/ios/Pods/
**/macos/Pods/

# Environment
.env
.env.local
''';

    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, '.gitignore'),
      content,
    );
  }

  /// Configure Android build.gradle.kts for module-specific requirements.
  Future<void> _configureAndroidBuild() async {
    final buildGradlePath = FileUtils.join(
      config.projectPath,
      'android',
      'app',
      'build.gradle.kts',
    );

    if (!await FileUtils.fileExists(buildGradlePath)) {
      return;
    }

    final content = await FileUtils.readFile(buildGradlePath);
    var modified = content;

    // Enable core library desugaring if notifications module is included
    if (config.modules.contains(KiroModule.notifications)) {
      // Add isCoreLibraryDesugaringEnabled to compileOptions if not present
      if (!content.contains('isCoreLibraryDesugaringEnabled')) {
        // Find targetCompatibility line and add desugaring after it
        final targetCompatPattern = RegExp(r'targetCompatibility = JavaVersion\.VERSION_\d+');
        if (targetCompatPattern.hasMatch(content)) {
          modified = modified.replaceFirstMapped(
            targetCompatPattern,
            (match) => '${match.group(0)}\n        isCoreLibraryDesugaringEnabled = true',
          );
        }
      }

      // Add dependencies block with desugar_jdk_libs if not present
      if (!content.contains('coreLibraryDesugaring')) {
        // Check if dependencies block exists
        if (content.contains('dependencies {')) {
          // Add to existing dependencies block (after the opening brace)
          modified = modified.replaceFirst(
            'dependencies {',
            'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")',
          );
        } else {
          // Add new dependencies block before flutter block
          modified = modified.replaceFirst(
            'flutter {',
            'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")\n}\n\nflutter {',
          );
        }
      }
    }

    if (modified != content) {
      await FileUtils.writeFile(buildGradlePath, modified);
    }
  }

  /// Copy module files from modules/ directory to generated app.
  Future<void> _copyModules() async {
    if (config.modules.isEmpty) return;

    // Find kiro root directory (where modules/ folder is)
    // The CLI is in kiro_cli/, so we need to go up one level
    final kiroRoot = _findKiroRoot();
    if (kiroRoot == null) {
      Console.warning('Could not find kiro root directory. Skipping module copy.');
      return;
    }

    for (final module in config.modules) {
      final sourcePath = FileUtils.join(
        kiroRoot,
        'modules',
        module.name,
        'lib',
      );

      if (!await FileUtils.directoryExists(sourcePath)) {
        Console.warning('Module ${module.name} not found at $sourcePath');
        continue;
      }

      final destPath = FileUtils.join(
        config.projectPath,
        'lib',
        'modules',
        module.name,
      );

      Console.hint('  Copying ${module.name} module...');
      await FileUtils.copyDirectory(sourcePath, destPath);
    }
  }

  /// Find the kiro root directory (where modules/ folder exists).
  String? _findKiroRoot() {
    // Start from current working directory and go up until we find modules/
    var current = FileUtils.currentDirectory;
    var previous = '';

    while (current != previous) {
      final modulesPath = FileUtils.join(current, 'modules');
      if (Directory(modulesPath).existsSync()) {
        return current;
      }
      previous = current;
      current = FileUtils.normalize(FileUtils.join(current, '..'));
    }

    // If not found, try relative to kiro_cli location
    // The CLI is typically in kiro_cli/, so modules/ is one level up
    final cliPath = FileUtils.currentDirectory;
    if (cliPath.contains('kiro_cli')) {
      final potentialRoot = FileUtils.normalize(FileUtils.join(cliPath, '..'));
      final modulesPath = FileUtils.join(potentialRoot, 'modules');
      if (Directory(modulesPath).existsSync()) {
        return potentialRoot;
      }
    }

    return null;
  }
}

