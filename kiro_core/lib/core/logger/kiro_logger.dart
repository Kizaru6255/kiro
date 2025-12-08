/// Kiro Logger - A flexible logging system for Kiro applications.
library;

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as pkg_logger;

import 'log_level.dart';

/// Main logger interface for Kiro applications.
///
/// Provides a consistent logging API with support for:
/// - Multiple log levels
/// - Structured logging with tags
/// - Pretty printing in debug mode
/// - Minimal output in release mode
///
/// Example:
/// ```dart
/// final logger = KiroLogger(tag: 'AuthService');
///
/// logger.debug('Attempting login');
/// logger.info('User logged in', data: {'userId': user.id});
/// logger.error('Login failed', error: e, stackTrace: st);
/// ```
class KiroLogger {
  /// Tag for this logger instance.
  final String tag;

  /// Minimum log level (messages below this level are ignored).
  final LogLevel minLevel;

  /// Whether to include timestamps in output.
  final bool showTimestamp;

  /// Whether to use pretty printing (colors, formatting).
  final bool prettyPrint;

  /// Internal logger instance.
  late final pkg_logger.Logger _logger;

  /// Singleton instance for global logging.
  static KiroLogger? _instance;

  /// Get the global logger instance.
  static KiroLogger get instance {
    _instance ??= KiroLogger(tag: 'Kiro');
    return _instance!;
  }

  /// Initialize the global logger with custom settings.
  static void initialize({
    String tag = 'Kiro',
    LogLevel minLevel = LogLevel.debug,
    bool showTimestamp = true,
    bool prettyPrint = true,
  }) {
    _instance = KiroLogger(
      tag: tag,
      minLevel: minLevel,
      showTimestamp: showTimestamp,
      prettyPrint: prettyPrint,
    );
  }

  KiroLogger({
    this.tag = 'Kiro',
    LogLevel? minLevel,
    this.showTimestamp = true,
    this.prettyPrint = true,
  }) : minLevel = minLevel ?? (kDebugMode ? LogLevel.debug : LogLevel.info) {
    _logger = pkg_logger.Logger(
      printer: prettyPrint
          ? pkg_logger.PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              lineLength: 80,
              colors: true,
              printEmojis: true,
              dateTimeFormat: showTimestamp
                  ? pkg_logger.DateTimeFormat.onlyTimeAndSinceStart
                  : pkg_logger.DateTimeFormat.none,
            )
          : pkg_logger.SimplePrinter(
              printTime: showTimestamp,
              colors: false,
            ),
      filter: _KiroLogFilter(minLevel: this.minLevel),
    );
  }

  /// Create a child logger with a specific tag.
  KiroLogger child(String childTag) {
    return KiroLogger(
      tag: '$tag.$childTag',
      minLevel: minLevel,
      showTimestamp: showTimestamp,
      prettyPrint: prettyPrint,
    );
  }

  /// Log a trace message (most verbose).
  void trace(
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.trace, message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Log a debug message.
  void debug(
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.debug, message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Alias for debug.
  void d(String message, {dynamic data}) => debug(message, data: data);

  /// Log an info message.
  void info(
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.info, message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Alias for info.
  void i(String message, {dynamic data}) => info(message, data: data);

  /// Log a warning message.
  void warning(
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.warning, message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Alias for warning.
  void w(String message, {dynamic data, Object? error}) =>
      warning(message, data: data, error: error);

  /// Log an error message.
  void error(
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Alias for error.
  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      this.error(message, error: error, stackTrace: stackTrace);

  /// Log a fatal error message.
  void fatal(
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.fatal, message, data: data, error: error, stackTrace: stackTrace);
  }

  /// Alias for fatal.
  void f(String message, {Object? error, StackTrace? stackTrace}) =>
      fatal(message, error: error, stackTrace: stackTrace);

  /// Log a network request.
  void logRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!LogLevel.debug.shouldLog(minLevel)) return;

    final buffer = StringBuffer()
      ..writeln('┌── REQUEST ─────────────────────────')
      ..writeln('│ $method $url');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers: $headers');
    }

    if (body != null) {
      buffer.writeln('│ Body: $body');
    }

    buffer.write('└────────────────────────────────────');

    debug(buffer.toString());
  }

  /// Log a network response.
  void logResponse({
    required String method,
    required String url,
    required int statusCode,
    Duration? duration,
    dynamic body,
  }) {
    if (!LogLevel.debug.shouldLog(minLevel)) return;

    final isSuccess = statusCode >= 200 && statusCode < 300;
    final buffer = StringBuffer()
      ..writeln('┌── RESPONSE ────────────────────────')
      ..writeln('│ $method $url')
      ..writeln('│ Status: $statusCode ${isSuccess ? "✓" : "✗"}');

    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds}ms');
    }

    if (body != null) {
      final bodyStr = body.toString();
      if (bodyStr.length > 500) {
        buffer.writeln('│ Body: ${bodyStr.substring(0, 500)}...');
      } else {
        buffer.writeln('│ Body: $body');
      }
    }

    buffer.write('└────────────────────────────────────');

    if (isSuccess) {
      debug(buffer.toString());
    } else {
      warning(buffer.toString());
    }
  }

  /// Log performance timing.
  void logPerformance(String operation, Duration duration) {
    final ms = duration.inMilliseconds;
    final emoji = ms < 100
        ? '⚡'
        : ms < 500
            ? '✓'
            : '⚠️';

    debug('$emoji $operation completed in ${ms}ms');
  }

  /// Measure execution time of an async operation.
  Future<T> timed<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      return await action();
    } finally {
      stopwatch.stop();
      logPerformance(operation, stopwatch.elapsed);
    }
  }

  /// Measure execution time of a sync operation.
  T timedSync<T>(
    String operation,
    T Function() action,
  ) {
    final stopwatch = Stopwatch()..start();
    try {
      return action();
    } finally {
      stopwatch.stop();
      logPerformance(operation, stopwatch.elapsed);
    }
  }

  void _log(
    LogLevel level,
    String message, {
    dynamic data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!level.shouldLog(minLevel)) return;

    final formattedMessage = '[$tag] $message';
    final logData = data != null ? '\nData: $data' : '';

    switch (level) {
      case LogLevel.trace:
        _logger.t('$formattedMessage$logData');
      case LogLevel.debug:
        _logger.d('$formattedMessage$logData');
      case LogLevel.info:
        _logger.i('$formattedMessage$logData');
      case LogLevel.warning:
        _logger.w('$formattedMessage$logData', error: error, stackTrace: stackTrace);
      case LogLevel.error:
        _logger.e('$formattedMessage$logData', error: error, stackTrace: stackTrace);
      case LogLevel.fatal:
        _logger.f('$formattedMessage$logData', error: error, stackTrace: stackTrace);
      case LogLevel.none:
        break;
    }

    // Also log to developer console for debugging
    if (kDebugMode) {
      developer.log(
        formattedMessage,
        name: tag,
        error: error,
        stackTrace: stackTrace,
        level: _toDeveloperLevel(level),
      );
    }
  }

  int _toDeveloperLevel(LogLevel level) {
    return switch (level) {
      LogLevel.trace => 300,
      LogLevel.debug => 500,
      LogLevel.info => 800,
      LogLevel.warning => 900,
      LogLevel.error => 1000,
      LogLevel.fatal => 1200,
      LogLevel.none => 0,
    };
  }
}

/// Custom log filter for Kiro Logger.
class _KiroLogFilter extends pkg_logger.LogFilter {
  final LogLevel minLevel;

  _KiroLogFilter({required this.minLevel});

  @override
  bool shouldLog(pkg_logger.LogEvent event) {
    final eventLevel = switch (event.level) {
      pkg_logger.Level.trace => LogLevel.trace,
      pkg_logger.Level.debug => LogLevel.debug,
      pkg_logger.Level.info => LogLevel.info,
      pkg_logger.Level.warning => LogLevel.warning,
      pkg_logger.Level.error => LogLevel.error,
      pkg_logger.Level.fatal => LogLevel.fatal,
      _ => LogLevel.debug,
    };

    return eventLevel.shouldLog(minLevel);
  }
}

/// Global logger instance for convenience.
KiroLogger get logger => KiroLogger.instance;

