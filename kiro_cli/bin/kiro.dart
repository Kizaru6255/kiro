#!/usr/bin/env dart

/// Kiro CLI - Generate production-ready Flutter applications.
///
/// Usage:
///   kiro create app           Create a new Flutter app
///   kiro add module <name>    Add a module to existing app
///   kiro doctor               Check development environment
///   kiro --help               Show help information
///   kiro --version            Show version
library;

import 'dart:io';

import 'package:kiro_cli/kiro_cli.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await runKiroCli(arguments);
  exit(exitCode);
}
