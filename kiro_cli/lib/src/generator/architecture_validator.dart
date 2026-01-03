/// Architecture validator for Clean Architecture compliance.
library;

import 'dart:io';

import '../utils/file_utils.dart';

/// Validates Clean Architecture compliance.
class ArchitectureValidator {
  /// Validate project architecture.
  static Future<ArchitectureValidationResult> validateProject(String projectPath) async {
    final violations = <ArchitectureViolation>[];
    final warnings = <String>[];

    final modulesDir = FileUtils.join(projectPath, 'lib', 'modules');
    if (!await FileUtils.directoryExists(modulesDir)) {
      return ArchitectureValidationResult(
        valid: true,
        violations: [],
        warnings: ['No modules found in project'],
      );
    }

    // Check each module
    final modules = await _listModules(modulesDir);
    for (final module in modules) {
      final modulePath = FileUtils.join(modulesDir, module);
      final moduleViolations = await _validateModule(modulePath);
      violations.addAll(moduleViolations);
    }

    // Check for cross-module violations
    final crossModuleViolations = await _checkCrossModuleViolations(modulesDir);
    violations.addAll(crossModuleViolations);

    return ArchitectureValidationResult(
      valid: violations.isEmpty,
      violations: violations,
      warnings: warnings,
    );
  }

  /// Validate a single module.
  static Future<List<ArchitectureViolation>> _validateModule(String modulePath) async {
    final violations = <ArchitectureViolation>[];

    // Check layer structure
    final domainPath = FileUtils.join(modulePath, 'lib', 'domain');
    final dataPath = FileUtils.join(modulePath, 'lib', 'data');
    final presentationPath = FileUtils.join(modulePath, 'lib', 'presentation');

    if (!await FileUtils.directoryExists(domainPath)) {
      violations.add(ArchitectureViolation(
        type: ViolationType.missingLayer,
        module: _getModuleName(modulePath),
        layer: 'domain',
        message: 'Missing domain layer',
      ));
    }

    if (!await FileUtils.directoryExists(dataPath)) {
      violations.add(ArchitectureViolation(
        type: ViolationType.missingLayer,
        module: _getModuleName(modulePath),
        layer: 'data',
        message: 'Missing data layer',
      ));
    }

    if (!await FileUtils.directoryExists(presentationPath)) {
      violations.add(ArchitectureViolation(
        type: ViolationType.missingLayer,
        module: _getModuleName(modulePath),
        layer: 'presentation',
        message: 'Missing presentation layer',
      ));
    }

    // Check for import violations (simplified - full implementation would parse Dart files)
    final importViolations = await _checkImportViolations(modulePath);
    violations.addAll(importViolations);

    return violations;
  }

  /// Check for import violations.
  static Future<List<ArchitectureViolation>> _checkImportViolations(String modulePath) async {
    final violations = <ArchitectureViolation>[];
    final moduleName = _getModuleName(modulePath);

    // Check presentation layer imports
    final presentationPath = FileUtils.join(modulePath, 'lib', 'presentation');
    if (await FileUtils.directoryExists(presentationPath)) {
      final presentationFiles = await _listDartFiles(presentationPath);
      for (final file in presentationFiles) {
        final content = await FileUtils.readFile(file);
        
        // Check for presentation → data imports
        if (content.contains("import '../data/") || 
            content.contains("import '../../data/")) {
          violations.add(ArchitectureViolation(
            type: ViolationType.layerViolation,
            module: moduleName,
            layer: 'presentation',
            message: 'Presentation layer should not import from data layer',
            file: file,
          ));
        }
      }
    }

    // Check domain layer imports
    final domainPath = FileUtils.join(modulePath, 'lib', 'domain');
    if (await FileUtils.directoryExists(domainPath)) {
      final domainFiles = await _listDartFiles(domainPath);
      for (final file in domainFiles) {
        final content = await FileUtils.readFile(file);
        
        // Check for domain → data or domain → presentation imports
        if (content.contains("import '../data/") || 
            content.contains("import '../presentation/") ||
            content.contains("import '../../data/") ||
            content.contains("import '../../presentation/")) {
          violations.add(ArchitectureViolation(
            type: ViolationType.layerViolation,
            module: moduleName,
            layer: 'domain',
            message: 'Domain layer should not import from data or presentation layers',
            file: file,
          ));
        }
      }
    }

    return violations;
  }

  /// Check for cross-module violations.
  static Future<List<ArchitectureViolation>> _checkCrossModuleViolations(String modulesDir) async {
    final violations = <ArchitectureViolation>[];
    
    // In a full implementation, we'd check for:
    // - Direct imports between modules (should use dependency injection)
    // - Circular dependencies
    // - Shared code that should be in a common module
    
    return violations;
  }

  /// List all modules in directory.
  static Future<List<String>> _listModules(String modulesDir) async {
    final modules = <String>[];
    final dir = Directory(modulesDir);

    if (!await dir.exists()) {
      return modules;
    }

    await for (final entity in dir.list()) {
      if (entity is Directory) {
        modules.add(entity.path);
      }
    }

    return modules;
  }

  /// List all Dart files in directory recursively.
  static Future<List<String>> _listDartFiles(String dirPath) async {
    final files = <String>[];
    final dir = Directory(dirPath);

    if (!await dir.exists()) {
      return files;
    }

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        // Skip generated files
        if (!entity.path.contains('.freezed.dart') &&
            !entity.path.contains('.g.dart')) {
          files.add(entity.path);
        }
      }
    }

    return files;
  }

  /// Get module name from path.
  static String _getModuleName(String modulePath) {
    return modulePath.split('/').last;
  }
}

/// Architecture validation result.
class ArchitectureValidationResult {
  final bool valid;
  final List<ArchitectureViolation> violations;
  final List<String> warnings;

  ArchitectureValidationResult({
    required this.valid,
    this.violations = const [],
    this.warnings = const [],
  });
}

/// Architecture violation.
class ArchitectureViolation {
  final ViolationType type;
  final String module;
  final String layer;
  final String message;
  final String? file;

  ArchitectureViolation({
    required this.type,
    required this.module,
    required this.layer,
    required this.message,
    this.file,
  });

  @override
  String toString() {
    final fileInfo = file != null ? ' in $file' : '';
    return '[$type] $module/$layer: $message$fileInfo';
  }
}

/// Type of architecture violation.
enum ViolationType {
  missingLayer,
  layerViolation,
  circularDependency,
  crossModuleImport,
}

