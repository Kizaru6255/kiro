/// Module metadata parser and model.
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

import '../utils/file_utils.dart';

/// Module route definition.
class ModuleRoute {
  final String path;
  final String name;
  final String screen;
  final bool requiresAuth;

  const ModuleRoute({
    required this.path,
    required this.name,
    required this.screen,
    this.requiresAuth = false,
  });

  factory ModuleRoute.fromYaml(Map<Object?, Object?> yaml) {
    // Handle both 'screen' and 'builder' fields (builder is used in module.yaml)
    final screenName = (yaml['screen'] ?? yaml['builder']) as String;
    return ModuleRoute(
      path: yaml['path'] as String,
      name: yaml['name'] as String,
      screen: screenName,
      requiresAuth: yaml['requires_auth'] as bool? ?? false,
    );
  }
}

/// Module provider definition.
class ModuleProvider {
  final String name;
  final String? path;

  const ModuleProvider({
    required this.name,
    this.path,
  });

  factory ModuleProvider.fromYaml(Object? yaml) {
    if (yaml is String) {
      return ModuleProvider(name: yaml);
    } else if (yaml is Map) {
      return ModuleProvider(
        name: yaml['name'] as String,
        path: yaml['path'] as String?,
      );
    }
    throw ArgumentError('Invalid provider format: $yaml');
  }
}

/// Module metadata from module.yaml.
class ModuleMetadata {
  final String name;
  final String displayName;
  final String version;
  final List<ModuleRoute> routes;
  final List<ModuleProvider> providers;
  final List<String> dependencies;
  final Map<String, dynamic> config;

  const ModuleMetadata({
    required this.name,
    required this.displayName,
    required this.version,
    required this.routes,
    required this.providers,
    required this.dependencies,
    required this.config,
  });

  /// Load module metadata from module.yaml file.
  static Future<ModuleMetadata> fromFile(String modulePath) async {
    final yamlFile = File(FileUtils.join(modulePath, 'module.yaml'));
    if (!await yamlFile.exists()) {
      throw FileSystemException(
        'module.yaml not found',
        modulePath,
      );
    }

    final content = await yamlFile.readAsString();
    final yaml = loadYaml(content) as Map<Object?, Object?>;

    return ModuleMetadata(
      name: yaml['name'] as String? ?? '',
      displayName: yaml['display_name'] as String? ?? yaml['name'] as String? ?? '',
      version: yaml['version'] as String? ?? '1.0.0',
      routes: (yaml['routes'] as List<Object?>?)
              ?.map((r) => ModuleRoute.fromYaml(r as Map<Object?, Object?>))
              .toList() ??
          [],
      providers: (yaml['providers'] as List<Object?>?)
              ?.map((p) => ModuleProvider.fromYaml(p))
              .toList() ??
          [],
      dependencies: (yaml['dependencies'] as List<Object?>?)
              ?.map((d) => d.toString())
              .toList() ??
          [],
      config: (yaml['config'] as Map<Object?, Object?>?)
              ?.map((k, v) => MapEntry(k.toString(), v)) ??
          {},
    );
  }

  /// Load metadata for all modules in a directory.
  static Future<List<ModuleMetadata>> loadAll(String modulesDir) async {
    final modules = <ModuleMetadata>[];
    final dir = Directory(modulesDir);

    if (!await dir.exists()) {
      return modules;
    }

    await for (final entity in dir.list()) {
      if (entity is Directory) {
        try {
          final metadata = await ModuleMetadata.fromFile(entity.path);
          modules.add(metadata);
        } catch (e) {
          // Skip modules without valid module.yaml
          continue;
        }
      }
    }

    return modules;
  }
}

