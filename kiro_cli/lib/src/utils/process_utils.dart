/// Process execution utilities.
library;

import 'dart:io';

/// Result of a process execution.
class ProcessResult {
  /// Exit code.
  final int exitCode;

  /// Standard output.
  final String stdout;

  /// Standard error.
  final String stderr;

  const ProcessResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  /// Whether the process completed successfully.
  bool get success => exitCode == 0;

  /// Combined output (stdout + stderr).
  String get output => '$stdout$stderr';
}

/// Process execution utilities.
class ProcessUtils {
  ProcessUtils._();

  /// Run a command and wait for it to complete.
  static Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool runInShell = false,
  }) async {
    final result = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );

    return ProcessResult(
      exitCode: result.exitCode,
      stdout: result.stdout.toString(),
      stderr: result.stderr.toString(),
    );
  }

  /// Run Flutter command.
  static Future<ProcessResult> flutter(
    List<String> arguments, {
    String? workingDirectory,
  }) async {
    return run('flutter', arguments, workingDirectory: workingDirectory);
  }

  /// Run Dart command.
  static Future<ProcessResult> dart(
    List<String> arguments, {
    String? workingDirectory,
  }) async {
    return run('dart', arguments, workingDirectory: workingDirectory);
  }

  /// Run pub get.
  static Future<ProcessResult> pubGet({String? workingDirectory}) async {
    return flutter(['pub', 'get'], workingDirectory: workingDirectory);
  }

  /// Run build_runner to generate code.
  static Future<ProcessResult> buildRunner({
    String? workingDirectory,
    bool deleteConflictingOutputs = true,
  }) async {
    final args = ['run', 'build_runner', 'build'];
    if (deleteConflictingOutputs) {
      args.add('--delete-conflicting-outputs');
    }
    return dart(args, workingDirectory: workingDirectory);
  }

  /// Check if a command is available.
  static Future<bool> hasCommand(String command) async {
    try {
      final result = await run('which', [command]);
      return result.success;
    } catch (_) {
      // Try Windows where command
      try {
        final result = await run('where', [command], runInShell: true);
        return result.success;
      } catch (_) {
        return false;
      }
    }
  }

  /// Get Flutter version.
  static Future<String?> getFlutterVersion() async {
    try {
      final result = await flutter(['--version']);
      if (result.success) {
        final match = RegExp(r'Flutter (\d+\.\d+\.\d+)').firstMatch(result.stdout);
        return match?.group(1);
      }
    } catch (_) {}
    return null;
  }

  /// Get Dart version.
  static Future<String?> getDartVersion() async {
    try {
      final result = await dart(['--version']);
      if (result.success || result.stderr.contains('Dart SDK')) {
        final output = result.success ? result.stdout : result.stderr;
        final match = RegExp(r'Dart SDK version: (\d+\.\d+\.\d+)').firstMatch(output);
        return match?.group(1);
      }
    } catch (_) {}
    return null;
  }

  /// Check if Flutter is installed.
  static Future<bool> hasFlutter() async {
    return await hasCommand('flutter');
  }

  /// Check if Git is installed.
  static Future<bool> hasGit() async {
    return await hasCommand('git');
  }

  /// Initialize Git repository.
  static Future<ProcessResult> gitInit({String? workingDirectory}) async {
    return run('git', ['init'], workingDirectory: workingDirectory);
  }

  /// Create Flutter project.
  static Future<ProcessResult> createFlutterProject(
    String name, {
    String? workingDirectory,
    String? org,
    String? description,
    List<String>? platforms,
  }) async {
    final args = ['create', name];

    if (org != null) {
      args.addAll(['--org', org]);
    }

    if (description != null) {
      args.addAll(['--description', description]);
    }

    if (platforms != null && platforms.isNotEmpty) {
      args.addAll(['--platforms', platforms.join(',')]);
    }

    return flutter(args, workingDirectory: workingDirectory);
  }
}

