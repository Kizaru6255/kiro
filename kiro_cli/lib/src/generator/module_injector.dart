/// Module injector for copying and injecting modules into projects.
library;

import 'dart:io';

import '../utils/console.dart';
import '../utils/file_utils.dart';
import 'module_metadata.dart';
import 'placeholder_engine.dart';

/// Handles module injection into generated apps.
class ModuleInjector {
  final String projectPath;
  final String kiroRoot;

  ModuleInjector({
    required this.projectPath,
    required this.kiroRoot,
  });

  /// Inject a module into the project.
  Future<ModuleInjectionResult> injectModule(ModuleMetadata module) async {
    try {
      Console.step('Validating module: ${module.displayName}...');
      
      // Validate module structure
      final validationResult = await _validateModuleStructure(module);
      if (!validationResult.success) {
        return ModuleInjectionResult(
          success: false,
          errors: validationResult.errors,
        );
      }
      Console.success('Module validation passed');

      // Copy module files
      Console.step('Copying module files...');
      await _copyModuleFiles(module);
      Console.success('Module files copied');

      // Replace placeholders
      Console.step('Processing placeholders...');
      await _processPlaceholders(module);
      Console.success('Placeholders processed');

      return ModuleInjectionResult(
        success: true,
        module: module,
      );
    } catch (e) {
      return ModuleInjectionResult(
        success: false,
        errors: ['Failed to inject module: $e'],
      );
    }
  }

  /// Validate module structure and dependencies.
  Future<ModuleValidationResult> _validateModuleStructure(ModuleMetadata module) async {
    final errors = <String>[];

    // Check if module directory exists
    final moduleDir = FileUtils.join(kiroRoot, 'modules', module.name);
    if (!await FileUtils.directoryExists(moduleDir)) {
      errors.add('Module directory not found: $moduleDir');
      return ModuleValidationResult(success: false, errors: errors);
    }

    // Check if module.yaml exists
    final moduleYamlPath = FileUtils.join(moduleDir, 'module.yaml');
    if (!await FileUtils.fileExists(moduleYamlPath)) {
      errors.add('module.yaml not found in module directory');
      return ModuleValidationResult(success: false, errors: errors);
    }

    // Check if lib directory exists
    final libDir = FileUtils.join(moduleDir, 'lib');
    if (!await FileUtils.directoryExists(libDir)) {
      errors.add('lib/ directory not found in module');
      return ModuleValidationResult(success: false, errors: errors);
    }

    // Validate Clean Architecture structure
    final requiredDirs = [
      'domain',
      'data',
      'presentation',
    ];

    for (final dir in requiredDirs) {
      final dirPath = FileUtils.join(libDir, dir);
      if (!await FileUtils.directoryExists(dirPath)) {
        errors.add('Missing required directory: lib/$dir/');
      }
    }

    if (errors.isNotEmpty) {
      return ModuleValidationResult(success: false, errors: errors);
    }

    return ModuleValidationResult(success: true, errors: []);
  }

  /// Copy module files from source to destination.
  Future<void> _copyModuleFiles(ModuleMetadata module) async {
    final sourcePath = FileUtils.join(kiroRoot, 'modules', module.name);
    final destPath = FileUtils.join(projectPath, 'lib', 'modules', module.name);

    // Create destination directory
    await FileUtils.ensureDirectory(destPath);

    // Copy lib directory recursively
    final sourceLib = FileUtils.join(sourcePath, 'lib');
    final destLib = FileUtils.join(destPath, 'lib');

    await _copyDirectoryRecursive(sourceLib, destLib);

    // Copy pubspec.yaml if exists
    final sourcePubspec = FileUtils.join(sourcePath, 'pubspec.yaml');
    if (await FileUtils.fileExists(sourcePubspec)) {
      final destPubspec = FileUtils.join(destPath, 'pubspec.yaml');
      await FileUtils.copyFile(sourcePubspec, destPubspec);
    }

    // Copy module.yaml
    final sourceModuleYaml = FileUtils.join(sourcePath, 'module.yaml');
    if (await FileUtils.fileExists(sourceModuleYaml)) {
      final destModuleYaml = FileUtils.join(destPath, 'module.yaml');
      await FileUtils.copyFile(sourceModuleYaml, destModuleYaml);
    }

    // Copy README.md if exists
    final sourceReadme = FileUtils.join(sourcePath, 'README.md');
    if (await FileUtils.fileExists(sourceReadme)) {
      final destReadme = FileUtils.join(destPath, 'README.md');
      await FileUtils.copyFile(sourceReadme, destReadme);
    }
  }

  /// Copy directory recursively.
  Future<void> _copyDirectoryRecursive(String source, String dest) async {
    final sourceDir = Directory(source);
    if (!await sourceDir.exists()) {
      return;
    }

    await FileUtils.ensureDirectory(dest);

    await for (final entity in sourceDir.list(recursive: false)) {
      final relativePath = entity.path.replaceFirst('$source/', '');
      final destPath = FileUtils.join(dest, relativePath);

      if (entity is File) {
        // Skip generated files
        if (entity.path.contains('.freezed.dart') ||
            entity.path.contains('.g.dart') ||
            entity.path.contains('.g.part')) {
          continue;
        }
        await FileUtils.copyFile(entity.path, destPath);
      } else if (entity is Directory) {
        await _copyDirectoryRecursive(entity.path, destPath);
      }
    }
  }

  /// Process placeholders in copied files.
  Future<void> _processPlaceholders(ModuleMetadata module) async {
    final modulePath = FileUtils.join(projectPath, 'lib', 'modules', module.name);
    final libPath = FileUtils.join(modulePath, 'lib');

    if (!await FileUtils.directoryExists(libPath)) {
      return;
    }

    await _processPlaceholdersInDirectory(libPath, module);
  }

  /// Process placeholders recursively in directory.
  Future<void> _processPlaceholdersInDirectory(
    String dirPath,
    ModuleMetadata module,
  ) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      return;
    }

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        var content = await entity.readAsString();
        content = PlaceholderEngine.replacePlaceholders(
          content,
          {
            '__MODULE_NAME__': module.name,
            '__MODULE_DISPLAY_NAME__': module.displayName,
            '__MODULE_VERSION__': module.version,
          },
        );
        await entity.writeAsString(content);
      }
    }
  }
}

/// Result of module injection.
class ModuleInjectionResult {
  final bool success;
  final ModuleMetadata? module;
  final List<String> errors;

  ModuleInjectionResult({
    required this.success,
    this.module,
    this.errors = const [],
  });
}

/// Module validation result.
class ModuleValidationResult {
  final bool success;
  final List<String> errors;

  ModuleValidationResult({
    required this.success,
    this.errors = const [],
  });
}

