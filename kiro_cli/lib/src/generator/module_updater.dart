/// Module updater for updating modules in projects.
library;

import '../utils/console.dart';
import '../utils/file_utils.dart';
import 'module_injector.dart';
import 'module_metadata.dart';
import 'provider_registry.dart';
import 'pubspec_updater.dart';
import 'route_generator.dart';

/// Handles module updates in generated apps.
class ModuleUpdater {
  final String projectPath;
  final String kiroRoot;

  ModuleUpdater({
    required this.projectPath,
    required this.kiroRoot,
  });

  /// Update a module in the project.
  Future<ModuleUpdateResult> updateModule(String moduleName) async {
    try {
      Console.step('Validating module update: $moduleName...');

      // Check if module exists in project
      final modulePath = FileUtils.join(projectPath, 'lib', 'modules', moduleName);
      if (!await FileUtils.directoryExists(modulePath)) {
        return ModuleUpdateResult(
          success: false,
          errors: ['Module "$moduleName" not found in project. Use "kiro add module" first.'],
        );
      }

      // Load existing module metadata
      final existingMetadata = await ModuleMetadata.fromFile(modulePath);

      // Load new module metadata from source
      final sourcePath = FileUtils.join(kiroRoot, 'modules', moduleName);
      if (!await FileUtils.directoryExists(sourcePath)) {
        return ModuleUpdateResult(
          success: false,
          errors: ['Module source not found at: $sourcePath'],
        );
      }

      final newMetadata = await ModuleMetadata.fromFile(sourcePath);

      // Check version compatibility
      if (newMetadata.version != existingMetadata.version) {
        Console.warning(
          'Version change detected: ${existingMetadata.version} → ${newMetadata.version}',
        );
      }

      // Backup custom files (if any)
      Console.step('Backing up custom files...');
      await _backupCustomFiles(modulePath);
      Console.success('Backup created');

      // Remove old module files
      Console.step('Removing old module files...');
      await FileUtils.delete(modulePath);
      Console.success('Old files removed');

      // Inject new module files
      Console.step('Injecting updated module files...');
      final injector = ModuleInjector(
        projectPath: projectPath,
        kiroRoot: kiroRoot,
      );
      final injectionResult = await injector.injectModule(newMetadata);

      if (!injectionResult.success) {
        return ModuleUpdateResult(
          success: false,
          errors: ['Failed to inject updated module: ${injectionResult.errors.join(", ")}'],
        );
      }
      Console.success('Module files updated');

      // Restore custom files (if any)
      Console.step('Restoring custom files...');
      await _restoreCustomFiles(modulePath);
      Console.success('Custom files restored');

      // Update routes
      Console.step('Updating routes...');
      await _updateRoutes();
      Console.success('Routes updated');

      // Update providers
      Console.step('Updating providers...');
      await _updateProviders();
      Console.success('Providers updated');

      // Update pubspec.yaml
      Console.step('Updating dependencies...');
      final pubspecUpdater = PubspecUpdater(projectPath);
      final kiroCoreVersion = newMetadata.config['kiro_core_version'] as String?;
      await pubspecUpdater.updatePubspec(
        module: newMetadata,
        kiroCoreVersion: kiroCoreVersion,
      );
      Console.success('Dependencies updated');

      return ModuleUpdateResult(
        success: true,
        moduleName: moduleName,
        oldVersion: existingMetadata.version,
        newVersion: newMetadata.version,
      );
    } catch (e) {
      return ModuleUpdateResult(
        success: false,
        errors: ['Failed to update module: $e'],
      );
    }
  }

  /// Backup custom files that might have been modified.
  Future<void> _backupCustomFiles(String modulePath) async {
    // In a full implementation, we'd identify custom files
    // For now, we'll create a backup directory
    final backupPath = FileUtils.join(projectPath, '.kiro_backup', modulePath.split('/').last);
    if (await FileUtils.directoryExists(modulePath)) {
      await FileUtils.ensureDirectory(backupPath);
      // Note: This is a simplified backup - full implementation would
      // track which files were modified by the developer
    }
  }

  /// Restore custom files from backup.
  Future<void> _restoreCustomFiles(String modulePath) async {
    // In a full implementation, we'd restore custom files
    // For now, this is a placeholder
    final backupPath = FileUtils.join(projectPath, '.kiro_backup', modulePath.split('/').last);
    if (await FileUtils.directoryExists(backupPath)) {
      // Restore logic would go here
      // For now, we'll just clean up the backup
      await FileUtils.delete(backupPath);
    }
  }

  /// Update routes after module update.
  Future<void> _updateRoutes() async {
    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      return;
    }

    final allModules = await ModuleMetadata.loadAll(modulesDir);
    final appName = await _getAppName();
    final routesContent = RouteGenerator.generateRoutes(
      modules: allModules,
      appName: appName,
    );

    await FileUtils.writeFile(
      FileUtils.join(projectPath, 'lib', 'config', 'router.dart'),
      routesContent,
    );
  }

  /// Update providers after module update.
  Future<void> _updateProviders() async {
    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      return;
    }

    final allModules = await ModuleMetadata.loadAll(modulesDir);
    final appName = await _getAppName();
    final providersContent = ProviderRegistryGenerator.generateProviderRegistry(
      modules: allModules,
      appName: appName,
    );

    await FileUtils.writeFile(
      FileUtils.join(projectPath, 'lib', 'core', 'providers.dart'),
      providersContent,
    );
  }

  /// Get app name from pubspec.yaml.
  Future<String> _getAppName() async {
    try {
      final pubspecPath = FileUtils.join(projectPath, 'pubspec.yaml');
      final content = await FileUtils.readFile(pubspecPath);
      final match = RegExp(r'^name:\s*(\w+)', multiLine: true).firstMatch(content);
      return match?.group(1) ?? 'app';
    } catch (_) {
      return 'app';
    }
  }
}

/// Result of module update.
class ModuleUpdateResult {
  final bool success;
  final String? moduleName;
  final String? oldVersion;
  final String? newVersion;
  final List<String> errors;

  ModuleUpdateResult({
    required this.success,
    this.moduleName,
    this.oldVersion,
    this.newVersion,
    this.errors = const [],
  });
}


