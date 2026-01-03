/// Version manager for module version compatibility.
library;

import '../utils/file_utils.dart';
import 'module_metadata.dart';

/// Manages module versions and compatibility.
class VersionManager {
  /// Check module version compatibility.
  static Future<VersionCheckResult> checkCompatibility({
    required List<ModuleMetadata> projectModules,
    required ModuleMetadata newModule,
    required String? kiroCoreVersion,
  }) async {
    final warnings = <String>[];
    final errors = <String>[];

    // Check kiro_core version
    if (kiroCoreVersion != null) {
      final requiredCoreVersion = newModule.config['kiro_core_version'] as String?;
      if (requiredCoreVersion != null) {
        if (!_isCompatible(kiroCoreVersion, requiredCoreVersion)) {
          errors.add(
            'Module "${newModule.name}" requires kiro_core $requiredCoreVersion, '
            'but project uses $kiroCoreVersion',
          );
        }
      }
    }

    // Check CLI version
    final requiredCliVersion = newModule.config['kiro_cli_version'] as String?;
    if (requiredCliVersion != null) {
      // Note: In a full implementation, we'd check the actual CLI version
      warnings.add(
        'Module "${newModule.name}" was created with CLI $requiredCliVersion. '
        'Ensure compatibility with current CLI version.',
      );
    }

    // Check module dependencies versions
    for (final depName in newModule.dependencies) {
      final dependentModule = projectModules.firstWhere(
        (m) => m.name == depName,
        orElse: () => ModuleMetadata(
          name: '',
          displayName: '',
          version: '',
          routes: const [],
          providers: const [],
          dependencies: const [],
          config: const {},
        ),
      );

      if (dependentModule.name.isNotEmpty) {
        // Check if versions are compatible
        // In a full implementation, we'd use semantic versioning rules
        if (dependentModule.version != newModule.version) {
          warnings.add(
            'Module "${newModule.name}" may require specific version of "$depName". '
            'Current: ${dependentModule.version}, Module expects: ${newModule.version}',
          );
        }
      }
    }

    return VersionCheckResult(
      compatible: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Check if two version strings are compatible.
  static bool _isCompatible(String currentVersion, String requiredVersion) {
    // Simple compatibility check using semantic versioning
    // In a full implementation, use package:version
    
    // Remove caret and other operators
    final current = currentVersion.replaceAll(RegExp(r'[^0-9.]'), '');
    final required = requiredVersion.replaceAll(RegExp(r'[^0-9.]'), '');

    // Extract major version
    final currentMajor = _getMajorVersion(current);
    final requiredMajor = _getMajorVersion(required);

    // For now, just check major version compatibility
    // Full implementation would use semantic versioning rules
    return currentMajor >= requiredMajor;
  }

  /// Get major version number from version string.
  static int _getMajorVersion(String version) {
    final parts = version.split('.');
    if (parts.isEmpty) return 0;
    return int.tryParse(parts[0]) ?? 0;
  }

  /// Detect outdated modules in project.
  static Future<List<OutdatedModule>> detectOutdatedModules({
    required String projectPath,
    required String kiroRoot,
  }) async {
    final outdatedModules = <OutdatedModule>[];

    final projectModulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(projectModulesDir)) {
      return outdatedModules;
    }

    final projectModules = await ModuleMetadata.loadAll(projectModulesDir);
    final sourceModulesDir = FileUtils.join(kiroRoot, 'modules');
    final sourceModules = await ModuleMetadata.loadAll(sourceModulesDir);

    for (final projectModule in projectModules) {
      final sourceModule = sourceModules.firstWhere(
        (m) => m.name == projectModule.name,
        orElse: () => ModuleMetadata(
          name: '',
          displayName: '',
          version: '',
          routes: const [],
          providers: const [],
          dependencies: const [],
          config: const {},
        ),
      );

      if (sourceModule.name.isNotEmpty) {
        if (sourceModule.version != projectModule.version) {
          outdatedModules.add(OutdatedModule(
            name: projectModule.name,
            currentVersion: projectModule.version,
            latestVersion: sourceModule.version,
          ));
        }
      }
    }

    return outdatedModules;
  }

  /// Get version information for all modules.
  static Future<Map<String, String>> getModuleVersions(String modulesDir) async {
    final versions = <String, String>{};
    final modules = await ModuleMetadata.loadAll(modulesDir);

    for (final module in modules) {
      versions[module.name] = module.version;
    }

    return versions;
  }
}

/// Result of version compatibility check.
class VersionCheckResult {
  final bool compatible;
  final List<String> errors;
  final List<String> warnings;

  VersionCheckResult({
    required this.compatible,
    this.errors = const [],
    this.warnings = const [],
  });
}

/// Outdated module information.
class OutdatedModule {
  final String name;
  final String currentVersion;
  final String latestVersion;

  OutdatedModule({
    required this.name,
    required this.currentVersion,
    required this.latestVersion,
  });
}

