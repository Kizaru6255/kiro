/// Doctor command for checking environment.
library;

import '../utils/console.dart';
import '../utils/process_utils.dart';
import 'base_command.dart';

/// Command to check environment and dependencies.
class DoctorCommand extends BaseCommand {
  @override
  final String name = 'doctor';

  @override
  final String description = 'Check your environment and dependencies for Kiro development.';

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

    return allGood ? 0 : 1;
  }
}

