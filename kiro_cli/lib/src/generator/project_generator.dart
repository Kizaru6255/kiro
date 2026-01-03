/// Project generator.
library;

import 'dart:io';

import '../config/app_config.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import '../utils/process_utils.dart';
import 'cicd_templates.dart';
import 'cross_platform_templates.dart';
import 'module_metadata.dart';
import 'route_generator.dart';
import 'package:path/path.dart' as p;
import 'templates/config_templates.dart';
import 'templates/core_errors_template.dart';
import 'templates/core_templates.dart';
import 'templates/core_wrappers_template.dart';
import 'templates/feature_templates.dart';
import 'templates/main_template.dart';
import 'templates/pubspec_template.dart';
import 'templates/splash_template.dart';
import 'templates/onboarding_template.dart';
import 'templates/main_shell_template.dart';

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

      // Step 6.5: Generate platform-specific files
      if (config.platforms.length > 1 || config.platforms.contains(Platform.web)) {
        Console.step('Generating platform-specific files...');
        await _generatePlatformFiles();
        Console.success('Platform files generated');
      }

      // Step 7: Generate config files
      Console.step('Generating config files...');
      await _generateConfigFiles();
      Console.success('Config files generated');

      // Step 7.5: Generate routes from module metadata
      if (config.modules.isNotEmpty) {
        Console.step('Generating routes from module metadata...');
        await _generateRoutesFromModules();
        Console.success('Routes generated');
      }

      // Step 8: Generate feature files
      Console.step('Generating feature files...');
      await _generateFeatureFiles();
      Console.success('Feature files generated');

      // Step 8.5: Copy modules if any selected
      if (config.modules.isNotEmpty) {
        Console.step('Copying modules...');
        await _copyModules();
        Console.success('Modules copied');
        
        // Step 8.6: Remove services folders (contain old kiro_core code)
        Console.step('Cleaning up services folders...');
        await _removeServicesFolders();
        Console.success('Services folders removed');
        
        // Step 8.7: Fix import paths in modules (replace module errors with app core errors)
        Console.step('Fixing module imports...');
        await _fixModuleImports();
        Console.success('Module imports fixed');
        
        // Step 8.8: Ensure provider files exist (copy from modules if needed)
        Console.step('Ensuring provider files exist...');
        await _ensureProviderFiles();
        Console.success('Provider files verified');
        
        // Step 8.9: Fix provider files to remove service dependencies
        Console.step('Fixing provider dependencies...');
        await _fixProviderDependencies();
        Console.success('Provider dependencies fixed');
      }

      // Step 9: Generate kiro.yaml config
      Console.step('Creating kiro.yaml...');
      await _generateKiroConfig();
      Console.success('kiro.yaml created');

      // Step 9.5: Configure Android build if needed
      if (config.platforms.contains(Platform.android)) {
        await _configureAndroidBuild();
      }

      // Step 10: Generate CI/CD files
      Console.step('Generating CI/CD configuration...');
      await _generateCICD();
      Console.success('CI/CD configuration generated');

      // Step 10.5: Generate analysis_options.yaml
      Console.step('Generating analysis options...');
      await _generateAnalysisOptions();
      Console.success('Analysis options generated');

      // Step 11: Initialize git (if enabled)
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

      // Step 12: Run build_runner to generate Freezed code
      Console.step('Generating code with build_runner...');
      final buildRunnerResult = await ProcessUtils.buildRunner(
        workingDirectory: config.projectPath,
      );
      if (buildRunnerResult.success) {
        Console.success('Code generation completed');
      } else {
        Console.warning('build_runner had issues (you can run it manually: dart run build_runner build --delete-conflicting-outputs)');
        Console.hint(buildRunnerResult.stderr);
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
    await FileUtils.ensureDirectory(FileUtils.join(libPath, 'core', 'errors'));

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
    final content = generatePubspec(
      appName: config.appName,
      packageName: config.packageName,
      description: config.description,
      stateManagement: config.stateManagement.name,
      modules: config.modules.map((m) => m.name).toList(),
      useFirebase: config.useFirebase,
      kiroCorePath: null, // No longer using kiro_core
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

    // core.dart barrel - only app-specific code
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'core.dart'),
      generateCoreBarrel(),
    );

    // constants - app-specific constants only
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'constants', 'constants.dart'),
      generateConstants(appName: config.appName),
    );

    // extensions - app-specific extensions only
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'extensions', 'extensions.dart'),
      generateExtensions(),
    );

    // services - placeholder for app-specific services
    // Note: Core services (network, storage) come from kiro_core package
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'services', 'services.dart'),
      generateServices(),
    );

    // utils - placeholder for app-specific utilities
    // Note: Core utilities (validators, formatters) come from kiro_core package
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'utils', 'utils.dart'),
      generateUtils(),
    );
    
    // errors - Result and Failure types
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'errors', 'errors.dart'),
      generateCoreErrors(),
    );
    
    // wrappers - Core wrapper classes
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'wrappers.dart'),
      generateCoreWrappers(),
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

    // Router will be generated from module metadata if modules exist
    // Otherwise, generate a basic router
    if (config.modules.isEmpty) {
      await FileUtils.writeFile(
        FileUtils.join(configPath, 'router.dart'),
        generateRouter(
          stateManagement: config.stateManagement.name,
          modules: [],
        ),
      );
    }
    // If modules exist, router will be generated in _generateRoutesFromModules
  }

  Future<void> _generateFeatureFiles() async {
    // Generate home screen
    final homePath = FileUtils.join(config.projectPath, 'lib', 'features', 'home');
    await FileUtils.writeFile(
      FileUtils.join(homePath, 'home_screen.dart'),
      generateHomeScreen(
        appName: config.appName,
        modules: config.modules.map((m) => m.name).toList(),
        hasNotifications: config.modules.any((m) => m.name == 'notifications'),
      ),
    );

    // Generate splash screen if enabled
    if (config.includeSplash) {
      final splashPath = FileUtils.join(config.projectPath, 'lib', 'features', 'splash');
      await FileUtils.ensureDirectory(splashPath);
      await FileUtils.writeFile(
        FileUtils.join(splashPath, 'splash_screen.dart'),
        generateSplashScreen(
          appName: config.appName,
          primaryColor: config.primaryColor,
        ),
      );
    }

    // Generate onboarding screen if enabled
    if (config.includeOnboarding) {
      final onboardingPath = FileUtils.join(config.projectPath, 'lib', 'features', 'onboarding');
      await FileUtils.ensureDirectory(onboardingPath);
      await FileUtils.writeFile(
        FileUtils.join(onboardingPath, 'onboarding_screen.dart'),
        generateOnboardingScreens(
          appName: config.appName,
        ),
      );
    }

    // Generate main shell
    final mainShellPath = FileUtils.join(config.projectPath, 'lib', 'features', 'main_shell');
    await FileUtils.ensureDirectory(mainShellPath);
    await FileUtils.writeFile(
      FileUtils.join(mainShellPath, 'main_shell.dart'),
      generateMainShell(
        appName: config.appName,
        modules: config.modules.map((m) => m.name).toList(),
        bottomNavTabs: config.bottomNavTabs,
        hasNotifications: config.modules.any((m) => m.name == 'notifications'),
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
    if (config.modules.any((m) => m.name == 'notifications')) {
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
      await _copyModuleDirectory(sourcePath, destPath);
    }
  }

  /// Copy module directory excluding services folder and old providers.
  Future<void> _copyModuleDirectory(String source, String dest) async {
    final sourceDir = Directory(source);
    if (!await sourceDir.exists()) {
      return;
    }

    await FileUtils.ensureDirectory(dest);

    await for (final entity in sourceDir.list(recursive: false)) {
      final relativePath = p.basename(entity.path);
      final destPath = FileUtils.join(dest, relativePath);
      
      // Copy services folder (providers may need them)
      // They'll be fixed in _fixProviderDependencies if needed
      if (relativePath == 'services') {
        // Copy services folder
        if (entity is Directory) {
          await _copyModuleDirectory(entity.path, destPath);
        }
        continue;
      }
      
      // Skip providers folder during initial copy (will be copied in _ensureProviderFiles)
      if (relativePath == 'providers') {
        continue;
      }

      if (entity is File) {
        // Skip generated files
        if (entity.path.contains('.freezed.dart') ||
            entity.path.contains('.g.dart') ||
            entity.path.contains('.g.part')) {
          continue;
        }
        await FileUtils.copyFile(entity.path, destPath);
      } else if (entity is Directory) {
        await _copyModuleDirectory(entity.path, destPath);
      }
    }
  }

  /// Remove services folders and old providers from copied modules (they contain old kiro_core code).
  /// Note: Services are kept if providers reference them - they'll be fixed in _fixProviderDependencies.
  Future<void> _removeServicesFolders() async {
    final modulesPath = FileUtils.join(config.projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesPath)) {
      return;
    }

    final modulesDir = Directory(modulesPath);
    await for (final moduleDir in modulesDir.list()) {
      if (moduleDir is Directory) {
        final moduleName = p.basename(moduleDir.path);
        
        // Check if providers reference services before removing
        final providersPath = FileUtils.join(moduleDir.path, 'providers');
        final presentationProvidersPath = FileUtils.join(
          moduleDir.path,
          'presentation',
          'providers',
        );
        
        bool hasServiceReferences = false;
        if (await FileUtils.directoryExists(providersPath)) {
          final providersDir = Directory(providersPath);
          await for (final file in providersDir.list(recursive: true)) {
            if (file is File && file.path.endsWith('.dart')) {
              final content = await FileUtils.readFile(file.path);
              if (content.contains('services/') || content.contains('Service')) {
                hasServiceReferences = true;
                break;
              }
            }
          }
        }
        
        if (!hasServiceReferences && await FileUtils.directoryExists(presentationProvidersPath)) {
          final providersDir = Directory(presentationProvidersPath);
          await for (final file in providersDir.list(recursive: true)) {
            if (file is File && file.path.endsWith('.dart')) {
              final content = await FileUtils.readFile(file.path);
              if (content.contains('services/') || content.contains('Service')) {
                hasServiceReferences = true;
                break;
              }
            }
          }
        }
        
        // Remove services folder completely - providers will be fixed to not use services
        // Services contain kiro_core dependencies that don't exist in generated apps
        final servicesPath = FileUtils.join(moduleDir.path, 'services');
        if (await FileUtils.directoryExists(servicesPath)) {
          await FileUtils.delete(servicesPath);
          Console.hint('  Removed services folder for $moduleName');
        }
        
        // Also remove services from presentation layer if exists
        final presentationServicesPath = FileUtils.join(
          moduleDir.path,
          'presentation',
          'services',
        );
        if (await FileUtils.directoryExists(presentationServicesPath)) {
          await FileUtils.delete(presentationServicesPath);
          Console.hint('  Removed presentation services folder for $moduleName');
        }
      }
    }
  }

  /// Fix module imports to point to app's core errors.
  Future<void> _fixModuleImports() async {
    final modulesPath = FileUtils.join(config.projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesPath)) {
      return;
    }

    final corePath = FileUtils.join(config.projectPath, 'lib', 'core');
    final appErrorsPath = FileUtils.join(corePath, 'errors', 'errors.dart');
    final modulesDir = Directory(modulesPath);
    
    await for (final entity in modulesDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        var content = await FileUtils.readFile(entity.path);
        final fileDir = p.dirname(entity.path);
        final relativeErrorsPath = FileUtils.relative(appErrorsPath, from: fileDir);
        
        // Replace module's local errors.dart imports with app's core/errors
        // Pattern: import '../../core/errors/errors.dart' or similar
        var modified = content;
        if (content.contains('core/errors/errors.dart')) {
          // Find and replace all variations of core/errors/errors.dart imports
          // Match: import '../../core/errors/errors.dart' or import '../core/errors/errors.dart'
          // Use string replacement with a simple regex
          final lines = content.split('\n');
          final newLines = <String>[];
          for (final line in lines) {
            if (line.contains('core/errors/errors.dart') && line.trim().startsWith('import')) {
              newLines.add("import '$relativeErrorsPath';");
            } else {
              newLines.add(line);
            }
          }
          modified = newLines.join('\n');
          
          if (modified != content) {
            await FileUtils.writeFile(entity.path, modified);
          }
        }
      }
    }
  }

  /// Generate routes from module metadata.
  Future<void> _generateRoutesFromModules() async {
    if (config.modules.isEmpty) return;

    final kiroRoot = _findKiroRoot();
    if (kiroRoot == null) {
      Console.warning('Could not find kiro root. Using basic router.');
      return;
    }

    final modulesDir = FileUtils.join(kiroRoot, 'modules');
    final allMetadata = await ModuleMetadata.loadAll(modulesDir);

    // Filter to only selected modules
    final selectedMetadata = allMetadata
        .where((m) => config.modules.any((selected) => selected.name == m.name))
        .toList();

    if (selectedMetadata.isEmpty) {
      Console.warning('No module metadata found. Using basic router.');
      return;
    }

    final routesContent = RouteGenerator.generateRoutesWithConfig(
      modules: selectedMetadata,
      appName: config.appName,
      includeSplash: config.includeSplash,
      includeOnboarding: config.includeOnboarding,
      hasAuth: config.hasAuth,
      bottomNavTabs: config.bottomNavTabs,
    );

    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, 'lib', 'config', 'router.dart'),
      routesContent,
    );
  }

  /// Ensure provider files exist in copied modules.
  /// This verifies that presentation/providers directories and files are present.
  Future<void> _ensureProviderFiles() async {
    final modulesPath = FileUtils.join(config.projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesPath)) {
      return;
    }

    final modulesDir = Directory(modulesPath);
    await for (final moduleDir in modulesDir.list()) {
      if (moduleDir is Directory) {
        final moduleName = p.basename(moduleDir.path);
        final kiroRoot = _findKiroRoot();
        if (kiroRoot == null) continue;

        // Check for providers in presentation/providers
        final presentationProvidersPath = FileUtils.join(
          moduleDir.path,
          'presentation',
          'providers',
        );
        final sourcePresentationProvidersPath = p.join(
          kiroRoot,
          'modules',
          moduleName,
          'lib',
          'presentation',
          'providers',
        );

        if (!await FileUtils.directoryExists(presentationProvidersPath) &&
            await FileUtils.directoryExists(sourcePresentationProvidersPath)) {
          await FileUtils.ensureDirectory(presentationProvidersPath);
          final sourceDir = Directory(sourcePresentationProvidersPath);
          await for (final entity in sourceDir.list(recursive: true)) {
            if (entity is File && entity.path.endsWith('.dart')) {
              final relativePath = p.relative(entity.path, from: sourcePresentationProvidersPath);
              final destPath = FileUtils.join(presentationProvidersPath, relativePath);
              await FileUtils.ensureDirectory(p.dirname(destPath));
              await FileUtils.copyFile(entity.path, destPath);
            }
          }
          Console.hint('  Copied presentation providers for $moduleName module');
        }

        // Check for providers in lib/providers (root level)
        final rootProvidersPath = FileUtils.join(moduleDir.path, 'providers');
        final sourceRootProvidersPath = p.join(
          kiroRoot,
          'modules',
          moduleName,
          'lib',
          'providers',
        );

        if (!await FileUtils.directoryExists(rootProvidersPath) &&
            await FileUtils.directoryExists(sourceRootProvidersPath)) {
          await FileUtils.ensureDirectory(rootProvidersPath);
          final sourceDir = Directory(sourceRootProvidersPath);
          await for (final entity in sourceDir.list(recursive: true)) {
            if (entity is File && entity.path.endsWith('.dart')) {
              final relativePath = p.relative(entity.path, from: sourceRootProvidersPath);
              final destPath = FileUtils.join(rootProvidersPath, relativePath);
              await FileUtils.ensureDirectory(p.dirname(destPath));
              await FileUtils.copyFile(entity.path, destPath);
            }
          }
          Console.hint('  Copied root providers for $moduleName module');
        }
      }
    }
  }

  /// Fix provider files to remove service dependencies.
  Future<void> _fixProviderDependencies() async {
    final modulesPath = FileUtils.join(config.projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesPath)) {
      return;
    }

    final modulesDir = Directory(modulesPath);
    await for (final moduleDir in modulesDir.list()) {
      if (moduleDir is Directory) {
        final moduleName = p.basename(moduleDir.path);
        
        // Fix providers in lib/providers/
        final rootProvidersPath = FileUtils.join(moduleDir.path, 'providers');
        if (await FileUtils.directoryExists(rootProvidersPath)) {
          final providersDir = Directory(rootProvidersPath);
          await for (final file in providersDir.list(recursive: true)) {
            if (file is File && file.path.endsWith('_provider.dart')) {
              await _fixProviderFile(file.path, moduleName);
            }
          }
        }
        
        // Fix providers in presentation/providers/
        final presentationProvidersPath = FileUtils.join(
          moduleDir.path,
          'presentation',
          'providers',
        );
        if (await FileUtils.directoryExists(presentationProvidersPath)) {
          final providersDir = Directory(presentationProvidersPath);
          await for (final file in providersDir.list(recursive: true)) {
            if (file is File && file.path.endsWith('_provider.dart')) {
              await _fixProviderFile(file.path, moduleName);
            }
          }
        }
      }
    }
  }

  /// Fix a single provider file to remove service dependencies.
  Future<void> _fixProviderFile(String filePath, String moduleName) async {
    try {
      var content = await FileUtils.readFile(filePath);
      var originalContent = content;

      // Step 1: Remove service imports
      content = content.replaceAll(
        RegExp("import\\s+['\"].*services/[^'\"]*['\"];\\s*\\n", multiLine: true),
        '',
      );

      // Step 2: Remove service provider definitions completely
      content = content.replaceAll(
        RegExp(r'final\s+\w+ServiceProvider\s*=\s*Provider<\w+Service>\(\(ref\)\s*\{[^}]*return\s+\w+Service\(\);[^}]*\}\);\s*\n', dotAll: true),
        '',
      );

      // Step 3: Remove service field declarations
      content = content.replaceAll(
        RegExp(r'\s*final\s+\w+Service\s+_\w+Service;\s*\n'),
        '',
      );

      // Step 4: Fix constructor parameters - remove service parameters
      // Pattern: ClassName(this._serviceName) -> ClassName()
      content = content.replaceAllMapped(
        RegExp(r'(\w+)\(this\._\w+Service\)'),
        (match) => '${match.group(1)}()',
      );
      // Pattern: ClassName(this._serviceName, otherParam) -> ClassName(otherParam)
      content = content.replaceAllMapped(
        RegExp(r'(\w+)\(this\._\w+Service,\s*([^)]+)\)'),
        (match) => '${match.group(1)}(${match.group(2)})',
      );
      // Pattern: ClassName(otherParam, this._serviceName) -> ClassName(otherParam)
      content = content.replaceAllMapped(
        RegExp(r'(\w+)\(([^,]+),\s*this\._\w+Service\)'),
        (match) => '${match.group(1)}(${match.group(2)})',
      );
      // Pattern: ClassName(param1, this._serviceName, param2) -> ClassName(param1, param2)
      content = content.replaceAllMapped(
        RegExp(r'(\w+)\(([^,]+),\s*this\._\w+Service,\s*([^)]+)\)'),
        (match) => '${match.group(1)}(${match.group(2)}, ${match.group(3)})',
      );
      // Also handle: ClassName(service) -> ClassName() (for non-this parameters)
      content = content.replaceAllMapped(
        RegExp(r'(\w+)\([^)]*\b_\w+Service\b[^)]*\)', caseSensitive: false),
        (match) {
          final className = match.group(1)!;
          final fullMatch = match.group(0)!;
          // Remove service parameter and clean up commas
          var cleaned = fullMatch.replaceAll(RegExp(r',?\s*_\w+Service\b', caseSensitive: true), '');
          cleaned = cleaned.replaceAll(RegExp(r'\b_\w+Service\b\s*,?\s*', caseSensitive: true), '');
          // If only service was there, return empty constructor
          if (cleaned.replaceAll(RegExp(r'[^(),]'), '').trim() == '()' || 
              cleaned.replaceAll(RegExp(r'[^(),]'), '').trim().isEmpty) {
            return '$className()';
          }
          return cleaned;
        },
      );

      // Step 5: Fix provider definitions that watch services
      // Pattern: final provider = Provider((ref) { final service = ref.watch(...); return Class(service); });
      content = content.replaceAllMapped(
        RegExp(
          r'(final\s+\w+Provider\s*=\s*\w+Provider<[^>]+>\(\(ref\)\s*(?:async\s*)?\{)\s*(?:final\s+\w+\s*=\s*(?:ref\.watch\(\w+ServiceProvider\)|/\*[^*]+\*/);\s*\n\s*)?return\s+(\w+)\([^)]*\);',
          dotAll: true,
        ),
        (match) => '${match.group(1)}\n  throw UnimplementedError(\'Service removed - implement repository provider\');',
      );

      // Step 6: Fix ref.watch() calls with service providers - replace with throw
      content = content.replaceAllMapped(
        RegExp(r'final\s+\w+\s*=\s*ref\.watch\(\w+ServiceProvider\);'),
        (match) => 'throw UnimplementedError(\'Service removed - implement repository provider\');',
      );
      // Fix empty ref.watch() calls
      content = content.replaceAllMapped(
        RegExp(r'final\s+\w+\s*=\s*ref\.watch\(\);'),
        (match) => 'throw UnimplementedError(\'Service removed - implement repository provider\');',
      );
      // Fix incomplete assignments in provider bodies
      content = content.replaceAllMapped(
        RegExp(
          r'(final\s+\w+Provider[^\{]*\{[^}]*?)(final\s+\w+\s*=\s*(?:ref\.watch\(\w+ServiceProvider\)|/\*[^*]+\*/);)',
          dotAll: true,
        ),
        (match) => '${match.group(1)}\n  throw UnimplementedError(\'Service removed - implement repository provider\');',
      );
      
      // Step 6.5: Fix provider callbacks that have throw - ensure they close properly
      // Pattern: final provider = Provider((ref) { throw ... }); - should close with });
      content = content.replaceAllMapped(
        RegExp(r'(final\s+\w+Provider\s*=\s*\w+Provider[^\{]*\{[^}]*?throw\s+UnimplementedError\([^)]+\))(?!;)(\s*\n\s*)(?!\}\);)'),
        (match) => '${match.group(1)};${match.group(2)}});',
      );
      
      // Fix provider callbacks that have throw but missing closing
      content = content.replaceAllMapped(
        RegExp(r'(final\s+\w+Provider\s*=\s*\w+Provider[^\{]*\{[^}]*?throw\s+UnimplementedError\([^)]+\);\s*\n)(?!\s*\}\);)'),
        (match) {
          final matchStr = match.group(0)!;
          // Check if next line is class or another provider - if so, close this provider
          final afterMatch = content.substring(content.indexOf(matchStr) + matchStr.length);
          if (afterMatch.trim().startsWith('class ') || 
              (afterMatch.trim().startsWith('final ') && afterMatch.trim().contains('Provider'))) {
            return '${match.group(1)}});';
          }
          return matchStr;
        },
      );

      // Step 7: Fix incomplete statements like "final result = // TODO... throw..."
      content = content.replaceAll(
        RegExp(r'final\s+\w+\s*=\s*//\s*TODO[^\n]*\n\s*throw', dotAll: true),
        'throw',
      );
      
      // Step 7.5: Remove unreachable code after throw in regular functions
      // Pattern: throw ...; followed by code that uses the result
      content = content.replaceAllMapped(
        RegExp(
          r'throw\s+UnimplementedError[^;]+;\s*\n\s*(final\s+\w+\s*=\s*await\s+\w+\.|result\.fold|\w+\.fold|return\s+\w+\.)',
          dotAll: true,
        ),
        (match) => match.group(0)!.split('\n').first + ';',
      );

      // Step 8: Fix service method calls - use replaceAllMapped to properly handle $1
      content = content.replaceAllMapped(
        RegExp(r'(\s+)(await\s+)?_?\w+Service\.\w+\([^)]*\);?\s*\n'),
        (match) => '${match.group(1)}throw UnimplementedError(\'Service call removed\');\n',
      );
      // Fix incomplete service calls like "service.getAvailableSlots(:"
      content = content.replaceAllMapped(
        RegExp(r'(\s+)(await\s+)?_?\w+Service\.\w+\([^)]*:\s*[^)]*\);?\s*\n'),
        (match) => '${match.group(1)}throw UnimplementedError(\'Service call removed\');\n',
      );
      // Fix broken assignments like "final result =$1throw"
      content = content.replaceAll(
        RegExp(r'final\s+\w+\s*=\$1throw'),
        'throw',
      );
      // Fix broken assignments like "final result = await _createBookingUseCase(:,"
      content = content.replaceAllMapped(
        RegExp(r'final\s+\w+\s*=\s*await\s+\w+\([^)]*:\s*[^)]*\);?'),
        (match) => 'throw UnimplementedError(\'Service call removed\');',
      );
      
      // Step 8.5: Fix malformed throw statements with leftover code on same line
      // Pattern: throw UnimplementedError(...);;getChats(); or throw ...;originalCall();
      // Match: throw ...); followed by semicolons and method calls
      content = content.replaceAllMapped(
        RegExp(r'(throw\s+UnimplementedError\([^)]+\));[;]+([^;\n]+\([^)]*\);?)'),
        (match) => match.group(1)!, // Keep only the throw statement
      );
      // Also fix: throw ...);methodCall(); (no semicolon between)
      content = content.replaceAllMapped(
        RegExp(r'(throw\s+UnimplementedError\([^)]+\));([a-zA-Z_]\w*\([^)]*\);?)'),
        (match) => match.group(1)!, // Keep only the throw statement
      );
      
      // Fix: final result = throw UnimplementedError(...) -> throw UnimplementedError(...)
      content = content.replaceAllMapped(
        RegExp(r'final\s+\w+\s*=\s*throw\s+UnimplementedError\([^)]+\);'),
        (match) => match.group(0)!.replaceAll(RegExp(r'final\s+\w+\s*=\s*'), ''),
      );
      
      // Fix: Remove service parameters from constructors in provider callbacks
      // Pattern: return MessageNotifier(service, chatId); -> return MessageNotifier(chatId);
      content = content.replaceAllMapped(
        RegExp(r'return\s+(\w+)\([^,]*service[^,)]*,\s*([^)]+)\);'),
        (match) => 'return ${match.group(1)}(${match.group(2)});',
      );
      content = content.replaceAllMapped(
        RegExp(r'return\s+(\w+)\(([^,]+),\s*[^,)]*service[^)]*\);'),
        (match) => 'return ${match.group(1)}(${match.group(2)});',
      );
      content = content.replaceAllMapped(
        RegExp(r'return\s+(\w+)\([^,)]*service[^)]*\);'),
        (match) => 'return ${match.group(1)}();',
      );
      
      // Step 8.6: Remove unreachable code after throws more aggressively
      // Remove lines that start with result. or return result after a throw
      // Also remove stray ); and other leftover code
      final contentLines = content.split('\n');
      final cleanedLines = <String>[];
      bool skipNext = false;
      
      for (var i = 0; i < contentLines.length; i++) {
        final line = contentLines[i];
        final trimmed = line.trim();
        
        // If previous line was a throw, skip unreachable code
        if (skipNext) {
          // Skip stray ); or ); that are leftover
          if (trimmed == ');' || trimmed == ')' || trimmed.startsWith(');')) {
            skipNext = false; // Reset after removing stray );
            continue;
          }
          
          // Skip result.fold and return result lines
          if (trimmed.startsWith('result.') || 
              trimmed.startsWith('return result') ||
              (trimmed.startsWith('return ') && !trimmed.contains('throw') && !trimmed.contains('Provider'))) {
            // Skip this line, but check if next line is also unreachable
            continue;
          } else {
            // We've passed the unreachable code, reset
            skipNext = false;
          }
        }
        
        // Check if this line contains a throw
        if (trimmed.contains('throw UnimplementedError')) {
          // Make sure throw statement ends with semicolon
          var throwLine = line;
          if (!throwLine.trim().endsWith(';') && !throwLine.trim().endsWith('});')) {
            throwLine = throwLine.replaceAll(RegExp(r'(\s*)$'), ';');
          }
          cleanedLines.add(throwLine);
          skipNext = true; // Next lines might be unreachable
          continue;
        }
        
        // If we're skipping and this is a return statement in a provider callback, skip it
        if (skipNext && trimmed.startsWith('return ') && 
            !trimmed.contains('throw') && 
            (trimmed.contains('Notifier') || trimmed.contains('Provider'))) {
          // This is likely an unreachable return after throw in provider
          skipNext = false; // Reset after skipping return
          continue;
        }
        
        cleanedLines.add(line);
      }
      
      content = cleanedLines.join('\n');
      
      // Step 8.7: Fix specific patterns - remove stray ); after throw statements and ensure semicolons
      // First, ensure all throw statements have semicolons
      content = content.replaceAllMapped(
        RegExp(r'(throw\s+UnimplementedError\([^)]+\))(?!;)'),
        (match) => '${match.group(1)};',
      );
      
      // Remove stray ); after throw statements
      // Pattern: throw ...;\n    );
      content = content.replaceAllMapped(
        RegExp(r'(throw\s+UnimplementedError\([^)]+\);\s*\n)(\s+\);?\s*\n)'),
        (match) => match.group(1)!, // Keep only the throw line
      );
      
      // Remove ); that appears right after throw on same line or next line
      content = content.replaceAllMapped(
        RegExp(r'throw\s+UnimplementedError\([^)]+\);\s*\n\s+\);'),
        (match) => match.group(0)!.replaceAll(RegExp(r'\s+\);'), ''),
      );
      
      // Fix: throw without semicolon followed by });
      content = content.replaceAllMapped(
        RegExp(r'(throw\s+UnimplementedError\([^)]+\))\s*\n\s*\}\);'),
        (match) => '${match.group(1)};\n});',
      );
      
      // Remove any line that is just ); after a throw, and fix provider callbacks
      final finalLines = content.split('\n');
      final finalCleaned = <String>[];
      bool inProviderCallback = false;
      int providerBraceLevel = 0;
      
      for (var i = 0; i < finalLines.length; i++) {
        final line = finalLines[i];
        final trimmed = line.trim();
        
        // Detect provider callback start
        if (trimmed.contains('Provider') && trimmed.contains('(ref)') && !inProviderCallback) {
          inProviderCallback = true;
          providerBraceLevel = 0;
        }
        
        // Track braces in provider callback
        if (inProviderCallback) {
          providerBraceLevel += line.split('{').length - 1;
          providerBraceLevel -= line.split('}').length - 1;
        }
        
        // If previous line was a throw and this is just );, skip it (unless it's closing provider)
        if (i > 0) {
          final prevTrimmed = finalLines[i - 1].trim();
          if (prevTrimmed.contains('throw UnimplementedError') && 
              (trimmed == ');' || trimmed == ')')) {
            // Check if we're in a provider callback that needs closing
            if (inProviderCallback && providerBraceLevel <= 0) {
              // This is closing the provider, keep it but add semicolon to previous throw if needed
              if (!prevTrimmed.endsWith(';')) {
                finalCleaned[finalCleaned.length - 1] = finalCleaned.last.replaceAll(RegExp(r'$'), ';');
              }
              finalCleaned.add('});');
              inProviderCallback = false;
              continue;
            } else {
              // Stray ); after throw, skip it
              continue;
            }
          }
        }
        
        // If we're in provider callback and see class/provider definition, close provider first
        if (inProviderCallback && 
            (trimmed.startsWith('class ') || 
             (trimmed.startsWith('final ') && trimmed.contains('Provider') && !trimmed.contains('(ref)')))) {
          // Close the provider callback
          finalCleaned.add('});');
          finalCleaned.add('');
          inProviderCallback = false;
        }
        
        finalCleaned.add(line);
      }
      
      // If we're still in a provider callback at the end, close it
      if (inProviderCallback) {
        finalCleaned.add('});');
      }
      
      content = finalCleaned.join('\n');
      
      // Final cleanup: remove duplicate }); patterns
      content = content.replaceAll(RegExp(r'\}\);\s*\n\s*\}\);'), '});');
      
      // Fix: throw without semicolon at end of provider callback
      content = content.replaceAllMapped(
        RegExp(r'(throw\s+UnimplementedError\([^)]+\))\s*\n\s*\}\);'),
        (match) => '${match.group(1)};\n});',
      );
      
      // Final pass: Fix provider callbacks that have throw but no proper closing
      // Pattern: final provider = Provider((ref) async { throw ... }); but missing closing
      content = content.replaceAllMapped(
        RegExp(r'(final\s+\w+Provider[^=]*=\s*\w+Provider[^\{]*\{[^}]*throw\s+UnimplementedError\([^)]+\))(?!;)(\s*\n)(?!\s*\}\);)'),
        (match) {
          final afterMatch = content.substring(content.indexOf(match.group(0)!) + match.group(0)!.length);
          // If next non-empty line is class or provider, close this provider
          final nextLine = afterMatch.split('\n').firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
          if (nextLine.trim().startsWith('class ') || 
              (nextLine.trim().startsWith('final ') && nextLine.trim().contains('Provider') && !nextLine.trim().contains('(ref)'))) {
            return '${match.group(1)};${match.group(2)}});';
          }
          return match.group(0)!;
        },
      );
      
      // One more pass: ensure all throws in provider callbacks have semicolons and proper closing
      final lastPassLines = content.split('\n');
      final lastPassCleaned = <String>[];
      bool inAsyncProvider = false;
      
      for (var i = 0; i < lastPassLines.length; i++) {
        var line = lastPassLines[i];
        final trimmed = line.trim();
        
        // Detect async provider callback
        if (trimmed.contains('Provider') && trimmed.contains('(ref)') && trimmed.contains('async')) {
          inAsyncProvider = true;
        }
        
        // If we're in async provider and see throw without semicolon
        if (inAsyncProvider && trimmed.contains('throw UnimplementedError') && !trimmed.endsWith(';')) {
          line = line.replaceAll(RegExp(r'(\s*throw\s+UnimplementedError\([^)]+\))(?!;)'), r'$1;');
        }
        
        // If we see class/provider after async provider with throw, ensure provider is closed
        if (inAsyncProvider && 
            (trimmed.startsWith('class ') || 
             (trimmed.startsWith('final ') && trimmed.contains('Provider') && !trimmed.contains('(ref)')))) {
          // Check if previous line was throw
          if (i > 0 && lastPassLines[i - 1].trim().contains('throw UnimplementedError')) {
            // Insert closing before this line
            lastPassCleaned.add('});');
            lastPassCleaned.add('');
            inAsyncProvider = false;
          }
        }
        
        // Check if provider callback closes
        if (inAsyncProvider && trimmed == '});') {
          inAsyncProvider = false;
        }
        
        lastPassCleaned.add(line);
      }
      
      content = lastPassCleaned.join('\n');

      // Step 9: Remove unreachable code after throw and ensure proper function closure
      final lines = content.split('\n');
      final fixedLines = <String>[];
      int braceLevel = 0;
      bool inProviderFunction = false;
      bool afterThrow = false;
      bool inMethod = false;
      int methodBraceLevel = 0;
      
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final trimmed = line.trim();
        
        // Track brace level
        braceLevel += line.split('{').length - 1;
        braceLevel -= line.split('}').length - 1;
        
        // Detect method start (Future<void> methodName() { or void methodName() {)
        if (!inMethod && (trimmed.startsWith('Future<') || trimmed.startsWith('void ') || trimmed.startsWith('Future<void>')) && 
            trimmed.contains('(') && trimmed.contains('{')) {
          inMethod = true;
          methodBraceLevel = braceLevel;
        }
        
        // Detect provider function start
        if (trimmed.contains('Provider') && trimmed.contains('(ref)') && !inProviderFunction) {
          inProviderFunction = true;
          fixedLines.add(line);
          continue;
        }
        
        // Check if we hit a closing brace for provider function
        if (inProviderFunction && trimmed == '});') {
          fixedLines.add(line);
          inProviderFunction = false;
          afterThrow = false;
          continue;
        }
        
        // Check for throw statement
        if (trimmed.contains('throw UnimplementedError')) {
          fixedLines.add(line);
          afterThrow = true;
          continue;
        }
        
        // After throw, remove unreachable code until we hit a closing brace or return
        if (afterThrow) {
          // If we're in a method and hit the closing brace, reset
          if (inMethod && trimmed == '}' && braceLevel < methodBraceLevel) {
            fixedLines.add(line);
            afterThrow = false;
            inMethod = false;
            continue;
          }
          
          // If we hit a closing brace for provider function
          if (inProviderFunction && trimmed == '});') {
            fixedLines.add(line);
            inProviderFunction = false;
            afterThrow = false;
            continue;
          }
          
          // Skip unreachable code (like result.fold, return statements, etc.)
          if (trimmed.startsWith('result.') || 
              trimmed.startsWith('return result') ||
              (trimmed.startsWith('return ') && !trimmed.contains('throw'))) {
            continue; // Skip this unreachable line
          }
          
          // If we see a closing brace or semicolon that ends the throw context, reset
          if (trimmed == '}' || trimmed == '};' || (trimmed.endsWith(';') && !trimmed.contains('throw'))) {
            // Check if this is actually the end of the throw context
            if (inMethod && braceLevel <= methodBraceLevel) {
              fixedLines.add(line);
              afterThrow = false;
              inMethod = false;
              continue;
            }
          }
          
          // If we see a new method/class/provider definition, we've passed the throw context
          if (trimmed.startsWith('class ') || 
              (trimmed.startsWith('final ') && trimmed.contains('Provider')) ||
              (trimmed.startsWith('Future<') && trimmed.contains('('))) {
            afterThrow = false;
            fixedLines.add(line);
            continue;
          }
          
          // Skip unreachable code
          continue;
        }
        
        // Handle class definitions - fix constructors
        if (trimmed.startsWith('class ') && trimmed.contains('extends')) {
          // If we're still in a provider function, close it first
          if (inProviderFunction) {
            fixedLines.add('});');
            fixedLines.add('');
            inProviderFunction = false;
            afterThrow = false;
          }
          fixedLines.add(line);
          continue;
        }
        
        // Normal line
        fixedLines.add(line);
      }
      
      // If we're still in a provider function at the end, close it
      if (inProviderFunction) {
        fixedLines.add('});');
      }
      
      content = fixedLines.join('\n');
      
      // Step 10: Clean up any remaining issues
      // Fix broken patterns like "});" appearing before class definitions incorrectly
      content = content.replaceAll(RegExp(r'}\);\s*\n\s*class\s+(\w+)\s+extends'), 'class \$1 extends');
      
      // Fix duplicate throws
      content = content.replaceAll(
        RegExp(r'throw\s+UnimplementedError[^;]+;\s*\n\s*throw\s+UnimplementedError', dotAll: true),
        'throw UnimplementedError(\'Service removed\');',
      );

      // Step 11: Ensure all provider functions are properly closed
      // Fix cases where throw is last statement without closing
      content = content.replaceAllMapped(
        RegExp(
          r'(final\s+\w+Provider[^\{]*\{[^}]*?throw\s+UnimplementedError[^;]+;)\s*\n\s*(///|class\s+|final\s+\w+Provider)',
          dotAll: true,
        ),
        (match) => '${match.group(1)}\n});\n\n${match.group(2)}',
      );
      
      // Step 12: Fix nested .when() calls and provider closing
      // The issue: 
      // 1. Nested .when() calls need to be closed with ) before outer when's loading/error
      // 2. The final .when() call needs to close with ); before the provider callback closes with });
      
      // Fix the specific pattern where .when() ends with }); instead of ); followed by });
      // Pattern: ...error: (_, __) => throw..., }); should become ...error: (_, __) => throw..., );\n});
      // We detect this by checking if the error line has 4 spaces or less indent (outer when)
      content = content.replaceAllMapped(
        RegExp(
          r'(\s+error:\s*\([^)]+\)\s*=>\s*throw[^,]+,\s*\n)(\s*)\}\);',
          dotAll: true,
        ),
        (match) {
          final errorPart = match.group(1)!;
          
          // Extract indent from error line (the last line in errorPart)
          final errorLines = errorPart.split('\n').where((l) => l.trim().isNotEmpty).toList();
          if (errorLines.isNotEmpty) {
            final lastErrorLine = errorLines.last;
            final errorIndent = lastErrorLine.substring(0, lastErrorLine.length - lastErrorLine.trimLeft().length);
            
            // If error indent is 4 spaces or less, this is likely the outer .when() in a provider
            // It should close with ); then provider closes with });
            if (errorIndent.length <= 4) {
              return '$errorPart$errorIndent);\n});';
            } else {
              // This is a nested .when(), it should close with ),
              return '$errorPart$errorIndent),';
            }
          }
          
          return match.group(0)!;
        },
      );
      
      // Fix nested .when() calls - ensure inner when is closed before outer when's handlers
      // Pattern: error handler with deeper indent, followed by loading with less indent
      final whenLines = content.split('\n');
      final fixedWhenLines = <String>[];
      
      for (var i = 0; i < whenLines.length; i++) {
        final line = whenLines[i];
        final trimmed = line.trim();
        final indent = line.length > 0 ? line.substring(0, line.length - line.trimLeft().length) : '';
        
        // Check if this is an error handler that might need to close an inner when
        if (trimmed.startsWith('error:') && trimmed.contains('throw UnimplementedError') && !trimmed.endsWith('});')) {
          // Look ahead to find next non-empty, non-comment line
          int nextIdx = i + 1;
          while (nextIdx < whenLines.length && 
                 (whenLines[nextIdx].trim().isEmpty || 
                  whenLines[nextIdx].trim().startsWith('//'))) {
            nextIdx++;
          }
          
          if (nextIdx < whenLines.length) {
            final nextLine = whenLines[nextIdx];
            final nextTrimmed = nextLine.trim();
            final nextIndent = nextLine.length > 0 
                ? nextLine.substring(0, nextLine.length - nextLine.trimLeft().length) 
                : '';
            
            // If next line is loading/error with less indent, we need to close inner when
            if ((nextTrimmed.startsWith('loading:') || nextTrimmed.startsWith('error:')) && 
                nextIndent.length < indent.length &&
                indent.length >= 6) { // Only if indent suggests nesting (at least 6 spaces)
              fixedWhenLines.add(line);
              // Add closing paren and comma for inner when
              fixedWhenLines.add('$indent),');
              continue;
            }
          }
        }
        
        fixedWhenLines.add(line);
      }
      
      content = fixedWhenLines.join('\n');
      
      // Step 14: Fix any remaining broken service calls
      content = content.replaceAll(RegExp(r'\w+Service\.\w+\([^)]*:\s*[^)]*\)'), 'throw UnimplementedError(\'Service call removed\')');
      
      // Step 15: Fix any remaining broken constructor calls
      content = content.replaceAll(RegExp(r'(\w+)\(\s*,\s*([^)]+)\)'), '\$1(\$2)');
      content = content.replaceAll(RegExp(r'(\w+)\(([^,]+),\s*,\s*([^)]+)\)'), '\$1(\$2, \$3)');

      if (content != originalContent) {
        await FileUtils.writeFile(filePath, content);
        Console.hint('  Fixed provider: ${p.basename(filePath)}');
      }
    } catch (e) {
      Console.warning('  Failed to fix provider ${p.basename(filePath)}: $e');
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

  /// Generate CI/CD configuration files.
  Future<void> _generateCICD() async {
    // Generate GitHub Actions
    final githubActions = generateGitHubActions(
      appName: config.appName,
      platforms: config.platforms.map((p) => p.name).toList(),
    );

    await FileUtils.ensureDirectory(
      FileUtils.join(config.projectPath, '.github', 'workflows'),
    );
    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, '.github', 'workflows', 'ci.yml'),
      githubActions,
    );

    // Generate GitLab CI
    final gitLabCI = generateGitLabCI(
      appName: config.appName,
      platforms: config.platforms.map((p) => p.name).toList(),
    );

    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, '.gitlab-ci.yml'),
      gitLabCI,
    );
  }

  /// Generate analysis_options.yaml.
  Future<void> _generateAnalysisOptions() async {
    final content = generateAnalysisOptions();
    await FileUtils.writeFile(
      FileUtils.join(config.projectPath, 'analysis_options.yaml'),
      content,
    );
  }

  /// Generate platform-specific files.
  Future<void> _generatePlatformFiles() async {
    final corePath = FileUtils.join(config.projectPath, 'lib', 'core');

    // Generate platform detector
    final platformDetector = CrossPlatformTemplates.generatePlatformDetector();
    await FileUtils.writeFile(
      FileUtils.join(corePath, 'utils', 'platform_detector.dart'),
      platformDetector,
    );

    // Generate platform-specific configs if needed
    if (config.platforms.contains(Platform.web)) {
      final webConfig = CrossPlatformTemplates.generateWebConfig();
      await FileUtils.writeFile(
        FileUtils.join(corePath, 'config', 'web_config.dart'),
        webConfig,
      );
    }

    if (config.platforms.any((p) => 
        p == Platform.macos || p == Platform.windows || p == Platform.linux)) {
      final desktopConfig = CrossPlatformTemplates.generateDesktopConfig();
      await FileUtils.writeFile(
        FileUtils.join(corePath, 'config', 'desktop_config.dart'),
        desktopConfig,
      );
    }

    if (config.platforms.contains(Platform.android) || 
        config.platforms.contains(Platform.ios)) {
      final mobileConfig = CrossPlatformTemplates.generateMobileConfig();
      await FileUtils.writeFile(
        FileUtils.join(corePath, 'config', 'mobile_config.dart'),
        mobileConfig,
      );
    }
  }
}
