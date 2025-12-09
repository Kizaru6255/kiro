/// Base command class for Kiro CLI.
library;

import 'dart:io';

import 'package:args/command_runner.dart';

import '../utils/console.dart';

/// Base class for all Kiro commands.
abstract class BaseCommand extends Command<int> {
  /// Run the command.
  Future<int> execute();

  @override
  Future<int> run() async {
    try {
      return await execute();
    } catch (e, stackTrace) {
      Console.error('Command failed: $e');
      Console.hint(stackTrace.toString().split('\n').first);
      return 1;
    }
  }

  /// Confirm action with user.
  bool confirm(String message, {bool defaultValue = false}) {
    final defaultText = defaultValue ? 'Y/n' : 'y/N';
    Console.write('$message [$defaultText]: ');

    final input = readLine()?.trim().toLowerCase();
    if (input == null || input.isEmpty) {
      return defaultValue;
    }
    return input == 'y' || input == 'yes';
  }

  /// Prompt for input.
  String? prompt(String message, {String? defaultValue}) {
    if (defaultValue != null) {
      Console.write('$message [$defaultValue]: ');
    } else {
      Console.write('$message: ');
    }

    final input = readLine()?.trim();
    if (input == null || input.isEmpty) {
      return defaultValue;
    }
    return input;
  }

  /// Read line from stdin.
  String? readLine() {
    try {
      return stdin.readLineSync();
    } catch (_) {
      return null;
    }
  }
}
