/// Utilities module for Kiro Core.
///
/// Provides:
/// - [Validators] - Input validation functions
/// - Extension methods for common types
/// - [Debouncer] and [Throttler] - Rate limiting utilities
/// - [Retry] - Retry with backoff
///
/// Example:
/// ```dart
/// // Validation
/// final error = Validators.email('test@example.com');
///
/// // Extensions
/// 'hello world'.titleCase; // 'Hello World'
/// DateTime.now().isToday; // true
/// [1, 2, 3].firstOrNull; // 1
///
/// // Debouncing
/// final debouncer = Debouncer();
/// debouncer.run(() => search(query));
/// ```
library;

export 'debouncer.dart';
export 'extensions.dart';
export 'validators.dart';

