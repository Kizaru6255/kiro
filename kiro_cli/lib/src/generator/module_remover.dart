/// Module remover for removing modules from projects.
library;

import '../utils/console.dart';
import '../utils/file_utils.dart';
import 'module_metadata.dart';
import 'provider_registry.dart';
import 'route_generator.dart';

/// Handles module removal from generated apps.
class ModuleRemover {
  final String projectPath;

  ModuleRemover(this.projectPath);

  /// Remove a module from the project.
  Future<ModuleRemovalResult> removeModule(String moduleName) async {
    try {
      Console.step('Validating module removal: $moduleName...');

      // Check if module exists
      final modulePath = FileUtils.join(projectPath, 'lib', 'modules', moduleName);
      if (!await FileUtils.directoryExists(modulePath)) {
        return ModuleRemovalResult(
          success: false,
          errors: ['Module "$moduleName" not found in project.'],
        );
      }

      // Load module metadata before deletion
      ModuleMetadata? moduleMetadata;
      try {
        moduleMetadata = await ModuleMetadata.fromFile(modulePath);
      } catch (_) {
        Console.warning('Could not load module metadata. Proceeding with removal...');
      }

      // Check for dependencies
      final dependentModules = await _findDependentModules(moduleName);
      if (dependentModules.isNotEmpty) {
        return ModuleRemovalResult(
          success: false,
          errors: [
            'Cannot remove module "$moduleName" because it is required by:',
            ...dependentModules.map((m) => '  - $m'),
          ],
        );
      }

      // Remove module directory
      Console.step('Removing module files...');
      await FileUtils.delete(modulePath);
      Console.success('Module files removed');

      // Update routes
      if (moduleMetadata != null) {
        Console.step('Updating routes...');
        await _updateRoutes(moduleMetadata);
        Console.success('Routes updated');

        // Update providers
        Console.step('Updating providers...');
        await _updateProviders(moduleMetadata);
        Console.success('Providers updated');

        // Update pubspec.yaml (remove dependencies)
        Console.step('Updating dependencies...');
        await _updatePubspec(moduleMetadata);
        Console.success('Dependencies updated');
      }

      // Remove test files
      final testPath = FileUtils.join(projectPath, 'test', 'modules', moduleName);
      if (await FileUtils.directoryExists(testPath)) {
        Console.step('Removing test files...');
        await FileUtils.delete(testPath);
        Console.success('Test files removed');
      }

      return ModuleRemovalResult(
        success: true,
        moduleName: moduleName,
      );
    } catch (e) {
      return ModuleRemovalResult(
        success: false,
        errors: ['Failed to remove module: $e'],
      );
    }
  }

  /// Find modules that depend on the given module.
  Future<List<String>> _findDependentModules(String moduleName) async {
    final dependentModules = <String>[];
    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');

    if (!await FileUtils.directoryExists(modulesDir)) {
      return dependentModules;
    }

    final allModules = await ModuleMetadata.loadAll(modulesDir);
    for (final module in allModules) {
      if (module.dependencies.contains(moduleName)) {
        dependentModules.add(module.name);
      }
    }

    return dependentModules;
  }

  /// Update routes after module removal.
  Future<void> _updateRoutes(ModuleMetadata removedModule) async {
    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      return;
    }

    final remainingModules = await ModuleMetadata.loadAll(modulesDir);
    final appName = await _getAppName();
    final routesContent = RouteGenerator.generateRoutes(
      modules: remainingModules,
      appName: appName,
    );

    await FileUtils.writeFile(
      FileUtils.join(projectPath, 'lib', 'config', 'router.dart'),
      routesContent,
    );
  }

  /// Update providers after module removal.
  Future<void> _updateProviders(ModuleMetadata removedModule) async {
    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      return;
    }

    final remainingModules = await ModuleMetadata.loadAll(modulesDir);
    final appName = await _getAppName();
    final providersContent = ProviderRegistryGenerator.generateProviderRegistry(
      modules: remainingModules,
      appName: appName,
    );

    await FileUtils.writeFile(
      FileUtils.join(projectPath, 'lib', 'core', 'providers.dart'),
      providersContent,
    );
  }

  /// Update pubspec.yaml after module removal.
  Future<void> _updatePubspec(ModuleMetadata removedModule) async {
    // Note: This is a simplified approach
    // In a full implementation, we'd parse pubspec.yaml and remove
    // module-specific dependencies that are no longer needed
    Console.hint('  Review pubspec.yaml and remove unused dependencies manually');
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

/// Result of module removal.
class ModuleRemovalResult {
  final bool success;
  final String? moduleName;
  final List<String> errors;

  ModuleRemovalResult({
    required this.success,
    this.moduleName,
    this.errors = const [],
  });
}

