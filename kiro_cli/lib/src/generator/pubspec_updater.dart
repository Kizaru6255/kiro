/// Pubspec.yaml updater for adding module dependencies.
library;

import 'package:yaml/yaml.dart';

import '../utils/console.dart';
import '../utils/file_utils.dart';
import 'module_metadata.dart';

/// Updates pubspec.yaml with module dependencies.
class PubspecUpdater {
  final String projectPath;

  PubspecUpdater(this.projectPath);

  /// Update pubspec.yaml with module dependencies.
  Future<bool> updatePubspec({
    required ModuleMetadata module,
    required String? kiroCoreVersion,
  }) async {
    try {
      final pubspecPath = FileUtils.join(projectPath, 'pubspec.yaml');
      if (!await FileUtils.fileExists(pubspecPath)) {
        Console.error('pubspec.yaml not found');
        return false;
      }

      var content = await FileUtils.readFile(pubspecPath);

      // Parse YAML
      final yaml = loadYaml(content) as Map<Object?, Object?>;
      final dependencies = (yaml['dependencies'] as Map<Object?, Object?>?) ?? <Object?, Object?>{};

      // Add kiro_core if not present
      if (kiroCoreVersion != null && !dependencies.containsKey('kiro_core')) {
        dependencies['kiro_core'] = kiroCoreVersion;
        Console.success('  Added dependency: kiro_core $kiroCoreVersion');
      }

      // Add module-specific dependencies from module.yaml
      // Note: module.config['dependencies'] contains package dependencies
      // We need to check the actual module.yaml structure
      // For now, we'll use a simple approach and add common dependencies
      final moduleDeps = _getModuleDependencies(module);
      for (final dep in moduleDeps) {
        if (!dependencies.containsKey(dep.name)) {
          dependencies[dep.name] = dep.version;
          Console.success('  Added dependency: ${dep.name} ${dep.version}');
        }
      }

      // Write updated pubspec.yaml
      final updatedContent = _writeYamlDependencies(content, yaml, dependencies);
      await FileUtils.writeFile(pubspecPath, updatedContent);

      return true;
    } catch (e) {
      Console.error('Failed to update pubspec.yaml: $e');
      return false;
    }
  }

  /// Get module dependencies from metadata.
  List<_Dependency> _getModuleDependencies(ModuleMetadata module) {
    final deps = <_Dependency>[];

    // ModuleMetadata.dependencies contains module dependencies (other modules)
    // Package dependencies are in module.yaml under 'dependencies' key
    // We need to read the module.yaml file directly to get package dependencies
    // For now, we'll use a simple mapping based on module name
    // In a full implementation, we'd parse the module.yaml file again
    
    // Common dependencies by module (this should ideally come from module.yaml)
    final modulePackageDeps = <String, Map<String, String>>{
      'auth': {
        'firebase_auth': '^4.16.0',
        'google_sign_in': '^6.2.1',
        'flutter_secure_storage': '^9.0.0',
      },
      'chat': {
        'cloud_firestore': '^5.0.0',
        'firebase_storage': '^12.0.0',
      },
      'notifications': {
        'firebase_messaging': '^15.0.0',
        'flutter_local_notifications': '^17.0.0',
      },
      'tracking': {
        'google_maps_flutter': '^2.8.0',
        'geolocator': '^13.0.0',
      },
      'payments': {
        'razorpay_flutter': '^1.3.0',
      },
      'booking': {
        'table_calendar': '^3.0.9',
        'intl': '^0.19.0',
      },
      'profile': {
        'image_picker': '^1.1.0',
        'cached_network_image': '^3.3.1',
      },
    };

    final packageDeps = modulePackageDeps[module.name];
    if (packageDeps != null) {
      for (final entry in packageDeps.entries) {
        deps.add(_Dependency(name: entry.key, version: entry.value));
      }
    }

    return deps;
  }

  /// Write dependencies back to pubspec.yaml content.
  String _writeYamlDependencies(
    String original,
    Map<Object?, Object?> yaml,
    Map<Object?, Object?> dependencies,
  ) {
    // Simple approach: use regex to replace dependencies section
    final depsPattern = RegExp(
      r'dependencies:\s*\n((?:\s+[^:]+:[^\n]+\n?)*)',
      multiLine: true,
    );

    final newDepsContent = dependencies.entries
        .map((e) => '  ${e.key}: ${e.value}')
        .join('\n');

    if (depsPattern.hasMatch(original)) {
      return original.replaceFirst(
        depsPattern,
        'dependencies:\n$newDepsContent\n',
      );
    } else {
      // Insert after name or version
      final insertPattern = RegExp(r'^(name:\s*\w+\n|version:\s*[\d.]+\n)');
      if (insertPattern.hasMatch(original)) {
        return original.replaceFirst(
          insertPattern,
          '${insertPattern.firstMatch(original)!.group(0)}dependencies:\n$newDepsContent\n\n',
        );
      }
      // Fallback: add at the end before dev_dependencies
      return original.replaceFirst(
        RegExp(r'\ndev_dependencies:'),
        '\ndependencies:\n$newDepsContent\n\ndev_dependencies:',
      );
    }
  }
}

/// Dependency model.
class _Dependency {
  final String name;
  final String version;

  _Dependency({required this.name, required this.version});
}

/// Parsed pubspec dependencies.
class PubspecDependencies {
  final Map<String, String> dependencies;
  final Map<String, String> devDependencies;

  PubspecDependencies({
    required this.dependencies,
    required this.devDependencies,
  });
}

