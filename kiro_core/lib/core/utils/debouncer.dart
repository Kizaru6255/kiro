/// Debounce and throttle utilities.
library;

import 'dart:async';

/// A debouncer that delays execution until after a pause in calls.
///
/// Useful for search inputs, auto-save, etc.
///
/// Example:
/// ```dart
/// final debouncer = Debouncer(delay: Duration(milliseconds: 300));
///
/// void onSearchChanged(String query) {
///   debouncer.run(() => performSearch(query));
/// }
/// ```
class Debouncer {
  /// Delay before executing the action.
  final Duration delay;

  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Run an action after the delay, canceling any pending action.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Run an async action after the delay, canceling any pending action.
  void runAsync(Future<void> Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, () => action());
  }

  /// Cancel any pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether there's a pending action.
  bool get isPending => _timer?.isActive ?? false;

  /// Dispose the debouncer.
  void dispose() {
    cancel();
  }
}

/// A throttler that limits execution to once per duration.
///
/// Useful for rate-limiting API calls, scroll events, etc.
///
/// Example:
/// ```dart
/// final throttler = Throttler(duration: Duration(seconds: 1));
///
/// void onScroll() {
///   throttler.run(() => loadMoreItems());
/// }
/// ```
class Throttler {
  /// Minimum duration between executions.
  final Duration duration;

  DateTime? _lastExecution;
  Timer? _timer;
  void Function()? _pendingAction;

  Throttler({this.duration = const Duration(seconds: 1)});

  /// Run an action, throttled to once per duration.
  ///
  /// If [trailing] is true, the action will also run after the duration
  /// if there were calls during the throttle period.
  void run(void Function() action, {bool trailing = true}) {
    final now = DateTime.now();

    if (_lastExecution == null ||
        now.difference(_lastExecution!) >= duration) {
      // Execute immediately
      _lastExecution = now;
      action();
      _pendingAction = null;
    } else if (trailing) {
      // Store for trailing execution
      _pendingAction = action;
      _scheduleTrailing();
    }
  }

  void _scheduleTrailing() {
    if (_timer?.isActive ?? false) return;

    final timeSinceLast = DateTime.now().difference(_lastExecution!);
    final remaining = duration - timeSinceLast;

    _timer = Timer(remaining, () {
      if (_pendingAction != null) {
        _lastExecution = DateTime.now();
        _pendingAction!();
        _pendingAction = null;
      }
    });
  }

  /// Cancel any pending trailing action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _pendingAction = null;
  }

  /// Reset the throttler.
  void reset() {
    cancel();
    _lastExecution = null;
  }

  /// Dispose the throttler.
  void dispose() {
    cancel();
  }
}

/// Rate limiter for API calls.
///
/// Limits the number of calls within a time window.
///
/// Example:
/// ```dart
/// final limiter = RateLimiter(
///   maxCalls: 10,
///   window: Duration(minutes: 1),
/// );
///
/// Future<void> callApi() async {
///   if (!limiter.tryAcquire()) {
///     throw RateLimitException('Too many requests');
///   }
///   await api.call();
/// }
/// ```
class RateLimiter {
  /// Maximum number of calls allowed in the window.
  final int maxCalls;

  /// Time window for rate limiting.
  final Duration window;

  final List<DateTime> _calls = [];

  RateLimiter({
    required this.maxCalls,
    required this.window,
  });

  /// Try to acquire a permit.
  ///
  /// Returns true if under rate limit, false if limit exceeded.
  bool tryAcquire() {
    _cleanupOldCalls();

    if (_calls.length >= maxCalls) {
      return false;
    }

    _calls.add(DateTime.now());
    return true;
  }

  /// Wait until a permit is available.
  Future<void> acquire() async {
    while (!tryAcquire()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Get remaining permits.
  int get remaining {
    _cleanupOldCalls();
    return maxCalls - _calls.length;
  }

  /// Get time until next permit is available.
  Duration? get timeUntilNextPermit {
    if (remaining > 0) return null;
    if (_calls.isEmpty) return null;

    final oldestCall = _calls.first;
    final resetTime = oldestCall.add(window);
    final now = DateTime.now();

    if (resetTime.isBefore(now)) return null;
    return resetTime.difference(now);
  }

  void _cleanupOldCalls() {
    final cutoff = DateTime.now().subtract(window);
    _calls.removeWhere((call) => call.isBefore(cutoff));
  }

  /// Reset the rate limiter.
  void reset() {
    _calls.clear();
  }
}

/// Retry utility with exponential backoff.
///
/// Example:
/// ```dart
/// final result = await Retry.exponential(
///   () => api.fetch(),
///   maxAttempts: 3,
///   initialDelay: Duration(seconds: 1),
/// );
/// ```
class Retry {
  Retry._();

  /// Retry with exponential backoff.
  static Future<T> exponential<T>(
    Future<T> Function() action, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double multiplier = 2.0,
    Duration? maxDelay,
    bool Function(Object error)? shouldRetry,
  }) async {
    var attempt = 0;
    var delay = initialDelay;

    while (true) {
      attempt++;
      try {
        return await action();
      } catch (e) {
        if (attempt >= maxAttempts) rethrow;
        if (shouldRetry != null && !shouldRetry(e)) rethrow;

        await Future.delayed(delay);

        delay = Duration(
          milliseconds: (delay.inMilliseconds * multiplier).round(),
        );
        if (maxDelay != null && delay > maxDelay) {
          delay = maxDelay;
        }
      }
    }
  }

  /// Retry with fixed delay.
  static Future<T> fixed<T>(
    Future<T> Function() action, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(Object error)? shouldRetry,
  }) async {
    var attempt = 0;

    while (true) {
      attempt++;
      try {
        return await action();
      } catch (e) {
        if (attempt >= maxAttempts) rethrow;
        if (shouldRetry != null && !shouldRetry(e)) rethrow;

        await Future.delayed(delay);
      }
    }
  }

  /// Retry with custom delays.
  static Future<T> withDelays<T>(
    Future<T> Function() action, {
    required List<Duration> delays,
    bool Function(Object error)? shouldRetry,
  }) async {
    var attempt = 0;

    while (true) {
      try {
        return await action();
      } catch (e) {
        if (attempt >= delays.length) rethrow;
        if (shouldRetry != null && !shouldRetry(e)) rethrow;

        await Future.delayed(delays[attempt]);
        attempt++;
      }
    }
  }
}

