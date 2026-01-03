/// Dependency validator for module dependencies.
library;

import 'module_metadata.dart';

/// Validates module dependencies.
class DependencyValidator {
  /// Validate that all module dependencies are satisfied.
  static ValidationResult validateDependencies({
    required List<ModuleMetadata> existingModules,
    required ModuleMetadata newModule,
    required List<String> coreDependencies,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check module dependencies
    for (final dep in newModule.dependencies) {
      // Skip core dependencies (they're handled separately)
      if (coreDependencies.contains(dep)) {
        continue;
      }

      // Check if dependency module exists
      final dependencyModule = existingModules.firstWhere(
        (m) => m.name == dep,
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

      if (dependencyModule.name.isEmpty) {
        errors.add(
          'Dependency "$dep" not found. Required by module "${newModule.name}".',
        );
      }
    }

    // Check for circular dependencies
    final circularCheck = _checkCircularDependencies(
      existingModules: existingModules,
      newModule: newModule,
    );
    if (circularCheck.isNotEmpty) {
      errors.addAll(circularCheck);
    }

    // Check layer dependencies (presentation → domain → data → core)
    final layerErrors = _validateLayerDependencies(newModule);
    if (layerErrors.isNotEmpty) {
      warnings.addAll(layerErrors);
    }

    if (errors.isNotEmpty) {
      return ValidationResult(
        success: false,
        errors: errors,
        warnings: warnings,
      );
    }

    return ValidationResult(
      success: true,
      errors: [],
      warnings: warnings,
    );
  }

  /// Check for circular dependencies.
  static List<String> _checkCircularDependencies({
    required List<ModuleMetadata> existingModules,
    required ModuleMetadata newModule,
  }) {
    final errors = <String>[];

    // Build dependency graph
    final allModules = [...existingModules, newModule];
    final visited = <String>{};
    final recursionStack = <String>{};

    bool hasCycle(String moduleName) {
      if (recursionStack.contains(moduleName)) {
        return true;
      }
      if (visited.contains(moduleName)) {
        return false;
      }

      visited.add(moduleName);
      recursionStack.add(moduleName);

      final module = allModules.firstWhere(
        (m) => m.name == moduleName,
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

      if (module.name.isNotEmpty) {
        for (final dep in module.dependencies) {
          if (hasCycle(dep)) {
            errors.add(
              'Circular dependency detected: $moduleName → $dep',
            );
            return true;
          }
        }
      }

      recursionStack.remove(moduleName);
      return false;
    }

    hasCycle(newModule.name);

    return errors;
  }

  /// Validate layer dependencies (Clean Architecture rules).
  static List<String> _validateLayerDependencies(ModuleMetadata module) {
    final warnings = <String>[];

    // This is a simplified check - in a real implementation,
    // we would parse Dart files and check imports
    // For now, we just warn about potential violations

    // Rule: Presentation can only depend on Domain
    // Rule: Domain cannot depend on Data or Presentation
    // Rule: Data can depend on Domain

    // Note: This would require AST parsing for full validation
    // For now, we'll rely on the developer following conventions

    return warnings;
  }

  /// Get all transitive dependencies for a module.
  static Set<String> getTransitiveDependencies({
    required List<ModuleMetadata> allModules,
    required String moduleName,
  }) {
    final dependencies = <String>{};
    final visited = <String>{};

    void collectDeps(String name) {
      if (visited.contains(name)) {
        return;
      }
      visited.add(name);

      final module = allModules.firstWhere(
        (m) => m.name == name,
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

      if (module.name.isNotEmpty) {
        for (final dep in module.dependencies) {
          dependencies.add(dep);
          collectDeps(dep);
        }
      }
    }

    collectDeps(moduleName);
    return dependencies;
  }
}

/// Validation result.
class ValidationResult {
  final bool success;
  final List<String> errors;
  final List<String> warnings;

  ValidationResult({
    required this.success,
    this.errors = const [],
    this.warnings = const [],
  });
}

