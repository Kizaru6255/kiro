/// Logger module for Kiro Core.
///
/// Provides a flexible logging system with:
/// - Multiple log levels
/// - Pretty printing in debug mode
/// - Network request/response logging
/// - Performance timing
///
/// Example:
/// ```dart
/// // Use global logger
/// logger.info('App started');
/// logger.error('Operation failed', error: e, stackTrace: st);
///
/// // Create tagged logger
/// final authLogger = KiroLogger(tag: 'Auth');
/// authLogger.debug('Login attempt');
///
/// // Time an operation
/// await logger.timed('fetchUsers', () => api.getUsers());
/// ```
library;

export 'kiro_logger.dart';
export 'log_level.dart';

