/// Test skeleton generator for modules.
library;

import '../utils/file_utils.dart';
import 'module_metadata.dart';

/// Generates test skeletons for modules.
class TestGenerator {
  final String projectPath;

  TestGenerator(this.projectPath);

  /// Generate test skeletons for a module.
  Future<void> generateTestSkeletons(ModuleMetadata module) async {
    final testPath = FileUtils.join(projectPath, 'test', 'modules', module.name);

    // Domain tests
    await _generateDomainTests(testPath, module);

    // Data tests
    await _generateDataTests(testPath, module);

    // Presentation tests
    await _generatePresentationTests(testPath, module);
  }

  /// Generate domain layer tests.
  Future<void> _generateDomainTests(String testPath, ModuleMetadata module) async {
    final domainPath = FileUtils.join(testPath, 'domain');
    await FileUtils.ensureDirectory(domainPath);

    // Use case tests
    final usecasesPath = FileUtils.join(domainPath, 'usecases');
    await FileUtils.ensureDirectory(usecasesPath);

    // Generate placeholder use case test
    final usecaseTestContent = '''
/// ${module.displayName} use case tests.
library;

import 'package:flutter_test/flutter_test.dart';

// TODO: Import use cases
// import 'package:${module.name}/${module.name}.dart';

void main() {
  group('${module.displayName} Use Cases', () {
    // TODO: Add use case tests
    test('should be implemented', () {
      expect(true, isTrue);
    });
  });
}
''';

    await FileUtils.writeFile(
      FileUtils.join(usecasesPath, '${module.name}_usecase_test.dart'),
      usecaseTestContent,
    );
  }

  /// Generate data layer tests.
  Future<void> _generateDataTests(String testPath, ModuleMetadata module) async {
    final dataPath = FileUtils.join(testPath, 'data');
    await FileUtils.ensureDirectory(dataPath);

    // Repository tests
    final reposPath = FileUtils.join(dataPath, 'repositories');
    await FileUtils.ensureDirectory(reposPath);

    final repoTestContent = '''
/// ${module.displayName} repository tests.
library;

import 'package:flutter_test/flutter_test.dart';

// TODO: Import repository
// import 'package:${module.name}/${module.name}.dart';

void main() {
  group('${module.displayName} Repository', () {
    // TODO: Add repository tests
    test('should be implemented', () {
      expect(true, isTrue);
    });
  });
}
''';

    await FileUtils.writeFile(
      FileUtils.join(reposPath, '${module.name}_repository_test.dart'),
      repoTestContent,
    );
  }

  /// Generate presentation layer tests.
  Future<void> _generatePresentationTests(
    String testPath,
    ModuleMetadata module,
  ) async {
    final presentationPath = FileUtils.join(testPath, 'presentation');
    await FileUtils.ensureDirectory(presentationPath);

    // Provider tests
    final providersPath = FileUtils.join(presentationPath, 'providers');
    await FileUtils.ensureDirectory(providersPath);

    for (final provider in module.providers) {
      final providerTestContent = '''
/// ${provider.name} tests.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Import provider
// import 'package:${module.name}/presentation/providers/${_toSnakeCase(provider.name)}.dart';

void main() {
  group('${provider.name}', () {
    // TODO: Add provider tests
    test('should be implemented', () {
      expect(true, isTrue);
    });
  });
}
''';

      await FileUtils.writeFile(
        FileUtils.join(providersPath, '${_toSnakeCase(provider.name)}_test.dart'),
        providerTestContent,
      );
    }
  }

  static String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'^_'), '')
        .toLowerCase();
  }
}


