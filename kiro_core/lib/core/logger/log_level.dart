/// Log levels for Kiro Logger.
library;

/// Defines the severity levels for log messages.
///
/// Levels are ordered from most verbose (trace) to least verbose (fatal).
enum LogLevel {
  /// Most verbose level. For detailed debugging information.
  trace(0, 'TRACE'),

  /// Debug information for development.
  debug(1, 'DEBUG'),

  /// General information about app operation.
  info(2, 'INFO'),

  /// Warning messages for potential issues.
  warning(3, 'WARN'),

  /// Error messages for failures.
  error(4, 'ERROR'),

  /// Critical errors that may cause app failure.
  fatal(5, 'FATAL'),

  /// No logging.
  none(6, 'NONE');

  const LogLevel(this.value, this.label);

  /// Numeric value for comparison.
  final int value;

  /// Display name for the level.
  final String label;

  /// Whether this level should be logged given a minimum level.
  bool shouldLog(LogLevel minLevel) => value >= minLevel.value;
}

