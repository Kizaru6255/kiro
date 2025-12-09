/// Kiro CLI - Generate production-ready Flutter applications.
///
/// This CLI tool allows developers to:
/// - Create new Flutter apps with Kiro architecture
/// - Add modules to existing apps
/// - Check system requirements
///
/// ## Quick Start
///
/// ```bash
/// # Create a new app
/// kiro create app
///
/// # Add a module
/// kiro add module auth
///
/// # Check environment
/// kiro doctor
/// ```
library kiro_cli;

export 'src/cli_runner.dart';
export 'src/commands/commands.dart';
export 'src/config/config.dart';
export 'src/generator/generator.dart';
export 'src/utils/utils.dart';
