/// Doctor command for checking environment.
library;

import '../generator/architecture_validator.dart';
import '../generator/version_manager.dart';
import '../utils/console.dart';
import '../utils/file_utils.dart';
import '../utils/process_utils.dart';
import 'base_command.dart';

/// Command to check environment and dependencies.
class DoctorCommand extends BaseCommand {
  @override
  final String name = 'doctor';

  @override
  final String description = 'Check your environment and dependencies for Kiro development.';

  DoctorCommand() {
    argParser
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Path to the project (default: current directory)',
        defaultsTo: '.',
      )
      ..addFlag(
        'architecture',
        abbr: 'a',
        help: 'Check Clean Architecture compliance',
        defaultsTo: false,
      )
      ..addFlag(
        'versions',
        abbr: 'v',
        help: 'Check module versions and compatibility',
        defaultsTo: false,
      );
  }

  @override
  Future<int> execute() async {
    Console.banner();
    Console.header('Kiro Doctor');
    Console.info('Checking your development environment...');
    Console.blank();

    var allGood = true;

    // Check Flutter
    Console.step('Checking Flutter...');
    final flutterVersion = await ProcessUtils.getFlutterVersion();
    if (flutterVersion != null) {
      Console.success('Flutter $flutterVersion');
    } else {
      Console.error('Flutter not found');
      Console.hint('  Install Flutter: https://flutter.dev/docs/get-started/install');
      allGood = false;
    }

    // Check Dart
    Console.step('Checking Dart...');
    final dartVersion = await ProcessUtils.getDartVersion();
    if (dartVersion != null) {
      Console.success('Dart $dartVersion');
    } else {
      Console.error('Dart not found');
      Console.hint('  Dart should be included with Flutter');
      allGood = false;
    }

    // Check Git
    Console.step('Checking Git...');
    final hasGit = await ProcessUtils.hasGit();
    if (hasGit) {
      Console.success('Git installed');
    } else {
      Console.warning('Git not found');
      Console.hint('  Install Git: https://git-scm.com/downloads');
      Console.hint('  Git is optional but recommended for version control');
    }

    // Check Flutter doctor
    Console.blank();
    Console.step('Running Flutter doctor...');
    Console.blank();
    
    final flutterDoctor = await ProcessUtils.flutter(['doctor', '--verbose']);
    
    // Parse Flutter doctor output for issues
    final lines = flutterDoctor.stdout.split('\n');
    var hasAndroid = false;
    var hasIos = false;
    var hasChrome = false;
    
    for (final line in lines) {
      if (line.contains('[✓]') || line.contains('[√]')) {
        if (line.toLowerCase().contains('android')) hasAndroid = true;
        if (line.toLowerCase().contains('xcode')) hasIos = true;
        if (line.toLowerCase().contains('chrome')) hasChrome = true;
      }
    }

    Console.subheader('Platform Support');
    if (hasAndroid) {
      Console.success('Android development ready');
    } else {
      Console.warning('Android toolchain needs setup');
      Console.hint('  Run "flutter doctor" for details');
    }

    if (hasIos) {
      Console.success('iOS development ready');
    } else {
      Console.warning('iOS toolchain not available');
      Console.hint('  Xcode is required for iOS development (macOS only)');
    }

    if (hasChrome) {
      Console.success('Web development ready');
    } else {
      Console.warning('Chrome not found');
      Console.hint('  Install Chrome for web development');
    }

    // Architecture validation (if project path provided)
    final projectPath = argResults!['project'] as String;
    final absolutePath = FileUtils.absolute(projectPath);
    final checkArchitecture = argResults!['architecture'] as bool;
    final checkVersions = argResults!['versions'] as bool;

    if (checkArchitecture || checkVersions) {
      final pubspecPath = FileUtils.join(absolutePath, 'pubspec.yaml');
      if (await FileUtils.fileExists(pubspecPath)) {
        Console.blank();
        Console.divider();
        Console.blank();

        // Architecture validation
        if (checkArchitecture) {
          await _checkArchitecture(absolutePath);
        }

        // Version checking
        if (checkVersions) {
          await _checkVersions(absolutePath);
        }
      } else {
        Console.warning('Not a Flutter project. Skipping project-specific checks.');
      }
    }

    // Summary
    Console.blank();
    Console.divider();
    Console.blank();

    if (allGood) {
      Console.success('All checks passed! You\'re ready to use Kiro.');
    } else {
      Console.warning('Some issues were found. Please resolve them before proceeding.');
    }

    Console.blank();
    Console.info('Quick start:');
    Console.numberedItem(1, 'kiro create app');
    Console.numberedItem(2, 'cd your_app_name');
    Console.numberedItem(3, 'flutter run');
    Console.blank();
    Console.info('Additional checks:');
    Console.numberedItem(1, 'kiro doctor --architecture  # Check Clean Architecture');
    Console.numberedItem(2, 'kiro doctor --versions      # Check module versions');
    Console.blank();

    return allGood ? 0 : 1;
  }

  /// Check architecture compliance.
  Future<void> _checkArchitecture(String projectPath) async {
    Console.header('Architecture Validation');
    Console.step('Checking Clean Architecture compliance...');
    Console.blank();

    final result = await ArchitectureValidator.validateProject(projectPath);

    if (result.valid) {
      Console.success('Architecture is compliant!');
    } else {
      Console.error('Found ${result.violations.length} architecture violation(s):');
      Console.blank();

      for (final violation in result.violations) {
        Console.error('  • ${violation.toString()}');
      }

      Console.blank();
      Console.info('How to fix:');
      Console.numberedItem(1, 'Ensure each module has domain/, data/, presentation/ layers');
      Console.numberedItem(2, 'Presentation should only import from Domain');
      Console.numberedItem(3, 'Domain should not import from Data or Presentation');
      Console.numberedItem(4, 'Data can import from Domain');
    }

    if (result.warnings.isNotEmpty) {
      Console.blank();
      Console.warning('Warnings:');
      for (final warning in result.warnings) {
        Console.warning('  • $warning');
      }
    }
  }

  /// Check module versions.
  Future<void> _checkVersions(String projectPath) async {
    Console.header('Version Compatibility');
    Console.step('Checking module versions...');
    Console.blank();

    // Find Kiro root
    final kiroRoot = await _findKiroRoot(projectPath);
    if (kiroRoot == null) {
      Console.warning('Could not find Kiro root. Skipping version checks.');
      return;
    }

    final outdatedModules = await VersionManager.detectOutdatedModules(
      projectPath: projectPath,
      kiroRoot: kiroRoot,
    );

    if (outdatedModules.isEmpty) {
      Console.success('All modules are up to date!');
    } else {
      Console.warning('Found ${outdatedModules.length} outdated module(s):');
      Console.blank();

      for (final module in outdatedModules) {
        Console.warning(
          '  • ${module.name}: ${module.currentVersion} → ${module.latestVersion}',
        );
        Console.hint('    Run: kiro update module ${module.name}');
      }

      Console.blank();
    }
  }

  /// Find Kiro root directory.
  Future<String?> _findKiroRoot(String projectPath) async {
    var current = projectPath;
    var previous = '';

    while (current != previous) {
      final modulesPath = FileUtils.join(current, 'modules');
      if (await FileUtils.directoryExists(modulesPath)) {
        return current;
      }
      previous = current;
      current = FileUtils.normalize(FileUtils.join(current, '..'));
    }

    return null;
  }
}

