/// CLI runner for Kiro.
library;

import 'package:args/command_runner.dart';

import 'commands/commands.dart';
import 'utils/console.dart';

/// Kiro CLI runner.
class KiroCliRunner extends CommandRunner<int> {
  KiroCliRunner()
      : super(
          'kiro',
          'Kiro - Modular Flutter App Generator\n\n'
              'Generate production-ready Flutter applications with modular architecture.',
        ) {
    // Add commands
    addCommand(CreateCommand());
    addCommand(AddCommand());
    addCommand(DoctorCommand());

    // Global flags
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Print version information.',
      )
      ..addFlag(
        'verbose',
        negatable: false,
        help: 'Enable verbose output.',
      );
  }

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);

      // Handle --version
      if (argResults['version'] == true) {
        Console.writeLine('Kiro CLI v0.1.0');
        return 0;
      }

      // No command provided - show help
      if (argResults.command == null) {
        Console.banner();
        printUsage();
        return 0;
      }

      return await runCommand(argResults) ?? 0;
    } on UsageException catch (e) {
      Console.error(e.message);
      Console.blank();
      Console.writeLine(e.usage);
      return 64; // Exit code for command line usage error
    } catch (e) {
      Console.error('An unexpected error occurred: $e');
      return 1;
    }
  }

  @override
  void printUsage() {
    Console.writeLine(description);
    Console.blank();
    Console.writeLine('Usage: kiro <command> [arguments]');
    Console.blank();
    Console.writeLine('Available commands:');
    for (final command in commands.values) {
      Console.writeLine('  ${command.name.padRight(15)} ${command.description}');
    }
    Console.blank();
    Console.writeLine('Run "kiro <command> --help" for more information about a command.');
    Console.blank();
    Console.writeLine('Examples:');
    Console.writeLine('  kiro create app           Create a new Kiro app interactively');
    Console.writeLine('  kiro create app -n MyApp  Create a new app with name');
    Console.writeLine('  kiro add module auth      Add auth module to current project');
    Console.writeLine('  kiro doctor               Check your development environment');
  }
}

/// Run the Kiro CLI.
Future<int> runKiroCli(List<String> args) async {
  final runner = KiroCliRunner();
  return await runner.run(args);
}

