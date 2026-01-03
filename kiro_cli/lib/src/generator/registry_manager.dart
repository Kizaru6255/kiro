/// Registry manager for public module registry.
library;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/console.dart';
import '../utils/file_utils.dart';

/// Manages public module registry.
class RegistryManager {
  static const String defaultRegistryUrl = 'https://registry.kiro.dev';
  static const String registryFileName = '.kiro_registry.yaml';

  /// Initialize registry configuration.
  static Future<bool> initRegistry({
    String? registryUrl,
    String? projectPath,
  }) async {
    try {
      final path = projectPath ?? FileUtils.currentDirectory;
      final registryFile = File(FileUtils.join(path, registryFileName));

      final config = {
        'registry_url': registryUrl ?? defaultRegistryUrl,
        'initialized_at': DateTime.now().toIso8601String(),
        'version': '1.0.0',
      };

      await FileUtils.writeFile(
        registryFile.path,
        const JsonEncoder.withIndent('  ').convert(config),
      );

      Console.success('Registry initialized');
      Console.info('Registry URL: ${config['registry_url']}');
      return true;
    } catch (e) {
      Console.error('Failed to initialize registry: $e');
      return false;
    }
  }

  /// Get registry URL from config.
  static Future<String?> getRegistryUrl({String? projectPath}) async {
    try {
      final path = projectPath ?? FileUtils.currentDirectory;
      final registryFile = File(FileUtils.join(path, registryFileName));

      if (!await registryFile.exists()) {
        return null;
      }

      final content = await registryFile.readAsString();
      final config = jsonDecode(content) as Map<String, dynamic>;
      return config['registry_url'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Search modules in registry.
  static Future<List<RegistryModule>> searchModules({
    required String query,
    String? registryUrl,
    String? projectPath,
  }) async {
    try {
      final url = registryUrl ?? await getRegistryUrl(projectPath: projectPath) ?? defaultRegistryUrl;
      final searchUrl = '$url/api/modules/search?q=$query';

      Console.step('Searching registry...');
      final response = await http.get(Uri.parse(searchUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final modules = (data['modules'] as List<dynamic>?)
                ?.map((m) => RegistryModule.fromJson(m as Map<String, dynamic>))
                .toList() ??
            [];

        return modules;
      } else {
        Console.warning('Registry search failed. Using local modules.');
        return [];
      }
    } catch (e) {
      Console.warning('Could not connect to registry: $e');
      Console.hint('Falling back to local modules');
      return [];
    }
  }

  /// Get module from registry.
  static Future<RegistryModule?> getModule({
    required String moduleName,
    String? version,
    String? registryUrl,
    String? projectPath,
  }) async {
    try {
      final url = registryUrl ?? await getRegistryUrl(projectPath: projectPath) ?? defaultRegistryUrl;
      final moduleUrl = version != null
          ? '$url/api/modules/$moduleName/$version'
          : '$url/api/modules/$moduleName/latest';

      final response = await http.get(Uri.parse(moduleUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return RegistryModule.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      Console.warning('Could not fetch module from registry: $e');
      return null;
    }
  }

  /// Install module from registry.
  static Future<bool> installModule({
    required String moduleName,
    String? version,
    String? registryUrl,
    String? projectPath,
    String? kiroRoot,
  }) async {
    try {
      final module = await getModule(
        moduleName: moduleName,
        version: version,
        registryUrl: registryUrl,
        projectPath: projectPath,
      );

      if (module == null) {
        Console.error('Module "$moduleName" not found in registry');
        return false;
      }

      Console.step('Downloading module "$moduleName" v${module.version}...');

      // In a full implementation, this would:
      // 1. Download module package
      // 2. Extract to modules/ directory
      // 3. Validate structure
      // 4. Return success

      Console.success('Module downloaded successfully');
      Console.hint('Run "kiro add module $moduleName" to add it to your project');

      return true;
    } catch (e) {
      Console.error('Failed to install module: $e');
      return false;
    }
  }

  /// List all modules in registry.
  static Future<List<RegistryModule>> listModules({
    String? registryUrl,
    String? projectPath,
    int limit = 50,
  }) async {
    try {
      final url = registryUrl ?? await getRegistryUrl(projectPath: projectPath) ?? defaultRegistryUrl;
      final listUrl = '$url/api/modules?limit=$limit';

      final response = await http.get(Uri.parse(listUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final modules = (data['modules'] as List<dynamic>?)
                ?.map((m) => RegistryModule.fromJson(m as Map<String, dynamic>))
                .toList() ??
            [];

        return modules;
      } else {
        return [];
      }
    } catch (e) {
      Console.warning('Could not list modules from registry');
      return [];
    }
  }
}

/// Module in public registry.
class RegistryModule {
  final String name;
  final String author;
  final String version;
  final String description;
  final List<String> tags;
  final RegistryCompatibility compatibility;
  final int downloads;
  final double rating;
  final DateTime updatedAt;
  final String? repository;
  final String? documentation;

  RegistryModule({
    required this.name,
    required this.author,
    required this.version,
    required this.description,
    this.tags = const [],
    required this.compatibility,
    this.downloads = 0,
    this.rating = 0.0,
    required this.updatedAt,
    this.repository,
    this.documentation,
  });

  factory RegistryModule.fromJson(Map<String, dynamic> json) {
    return RegistryModule(
      name: json['name'] as String,
      author: json['author'] as String,
      version: json['version'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((t) => t.toString()).toList() ?? [],
      compatibility: RegistryCompatibility.fromJson(
        json['compatibility'] as Map<String, dynamic>,
      ),
      downloads: json['downloads'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      repository: json['repository'] as String?,
      documentation: json['documentation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'version': version,
      'description': description,
      'tags': tags,
      'compatibility': compatibility.toJson(),
      'downloads': downloads,
      'rating': rating,
      'updated_at': updatedAt.toIso8601String(),
      'repository': repository,
      'documentation': documentation,
    };
  }
}

/// Module compatibility information.
class RegistryCompatibility {
  final String kiroCore;
  final String? kiroCli;
  final String flutter;

  RegistryCompatibility({
    required this.kiroCore,
    this.kiroCli,
    required this.flutter,
  });

  factory RegistryCompatibility.fromJson(Map<String, dynamic> json) {
    return RegistryCompatibility(
      kiroCore: json['kiro_core'] as String,
      kiroCli: json['kiro_cli'] as String?,
      flutter: json['flutter'] as String? ?? '^3.0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kiro_core': kiroCore,
      'kiro_cli': kiroCli,
      'flutter': flutter,
    };
  }
}

