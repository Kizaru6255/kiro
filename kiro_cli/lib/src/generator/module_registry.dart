/// Module registry for managing module sources.
library;

import '../utils/console.dart';
import 'module_metadata.dart';

/// Manages module registry and sources.
class ModuleRegistry {
  /// Load module from registry.
  static Future<ModuleMetadata?> loadFromRegistry({
    required String moduleName,
    required String registryUrl,
  }) async {
    try {
      // In a full implementation, this would:
      // 1. Fetch module metadata from registry
      // 2. Download module files
      // 3. Validate module structure
      // 4. Return module metadata

      Console.hint('Registry support coming soon. Using local modules for now.');
      return null;
    } catch (e) {
      Console.error('Failed to load from registry: $e');
      return null;
    }
  }

  /// List available modules in registry.
  static Future<List<RegistryModule>> listModules({
    required String registryUrl,
  }) async {
    try {
      // In a full implementation, this would fetch from registry API
      return [];
    } catch (e) {
      Console.error('Failed to list modules: $e');
      return [];
    }
  }

  /// Search modules in registry.
  static Future<List<RegistryModule>> searchModules({
    required String query,
    required String registryUrl,
  }) async {
    try {
      // In a full implementation, this would search registry
      return [];
    } catch (e) {
      Console.error('Failed to search modules: $e');
      return [];
    }
  }

  /// Get module info from registry.
  static Future<RegistryModuleInfo?> getModuleInfo({
    required String moduleName,
    required String registryUrl,
  }) async {
    try {
      // In a full implementation, this would fetch module details
      return null;
    } catch (e) {
      Console.error('Failed to get module info: $e');
      return null;
    }
  }
}

/// Module in registry.
class RegistryModule {
  final String name;
  final String displayName;
  final String version;
  final String description;
  final String author;
  final List<String> tags;
  final int downloads;
  final DateTime updatedAt;

  RegistryModule({
    required this.name,
    required this.displayName,
    required this.version,
    required this.description,
    required this.author,
    this.tags = const [],
    this.downloads = 0,
    required this.updatedAt,
  });
}

/// Detailed module information.
class RegistryModuleInfo extends RegistryModule {
  final String readme;
  final String license;
  final List<String> dependencies;
  final Map<String, String> versions;

  RegistryModuleInfo({
    required super.name,
    required super.displayName,
    required super.version,
    required super.description,
    required super.author,
    super.tags,
    super.downloads,
    required super.updatedAt,
    required this.readme,
    required this.license,
    this.dependencies = const [],
    this.versions = const {},
  });
}

