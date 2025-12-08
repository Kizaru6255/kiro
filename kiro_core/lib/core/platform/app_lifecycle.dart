/// App lifecycle observer.
///
/// Monitors app state changes (foreground, background, etc.)
/// and provides callbacks for lifecycle events.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';

/// App lifecycle state.
enum AppState {
  /// App is in the foreground and visible.
  foreground,

  /// App is in the background.
  background,

  /// App is inactive (e.g., during a phone call).
  inactive,

  /// App is detached (about to be terminated).
  detached,

  /// App state is unknown.
  unknown,
}

/// App lifecycle event.
class AppLifecycleEvent {
  /// Current app state.
  final AppState state;

  /// Previous app state.
  final AppState? previousState;

  /// Timestamp of the event.
  final DateTime timestamp;

  const AppLifecycleEvent({
    required this.state,
    this.previousState,
    required this.timestamp,
  });

  /// Whether app moved to foreground.
  bool get didResume =>
      previousState == AppState.background && state == AppState.foreground;

  /// Whether app moved to background.
  bool get didPause =>
      previousState == AppState.foreground && state == AppState.background;

  @override
  String toString() => 'AppLifecycleEvent($state, from: $previousState)';
}

/// Observer for app lifecycle events.
///
/// Features:
/// - Monitors foreground/background transitions
/// - Stream-based event notifications
/// - Callbacks for specific events
/// - Duration tracking for background time
///
/// Example:
/// ```dart
/// final lifecycle = AppLifecycleObserver();
/// lifecycle.init();
///
/// // Listen to events
/// lifecycle.onStateChanged.listen((event) {
///   if (event.didResume) {
///     refreshData();
///   }
/// });
///
/// // Use callbacks
/// lifecycle.onResume = () => refreshData();
/// lifecycle.onPause = () => saveState();
/// ```
class AppLifecycleObserver with WidgetsBindingObserver {
  final StreamController<AppLifecycleEvent> _stateController;

  AppState _currentState = AppState.unknown;
  AppState? _previousState;
  DateTime? _backgroundTime;
  bool _initialized = false;

  /// Callback when app resumes.
  VoidCallback? onResume;

  /// Callback when app pauses.
  VoidCallback? onPause;

  /// Callback when app becomes inactive.
  VoidCallback? onInactive;

  /// Callback when app detaches.
  VoidCallback? onDetached;

  /// Create an app lifecycle observer.
  AppLifecycleObserver()
      : _stateController = StreamController<AppLifecycleEvent>.broadcast();

  /// Whether the observer is initialized.
  bool get isInitialized => _initialized;

  /// Current app state.
  AppState get currentState => _currentState;

  /// Whether app is in foreground.
  bool get isInForeground => _currentState == AppState.foreground;

  /// Whether app is in background.
  bool get isInBackground => _currentState == AppState.background;

  /// Time spent in background (if currently backgrounded).
  Duration? get backgroundDuration {
    if (_backgroundTime == null || !isInBackground) return null;
    return DateTime.now().difference(_backgroundTime!);
  }

  /// Stream of lifecycle events.
  Stream<AppLifecycleEvent> get onStateChanged => _stateController.stream;

  /// Initialize the observer.
  void init() {
    if (_initialized) return;

    WidgetsBinding.instance.addObserver(this);
    _currentState = AppState.foreground;
    _initialized = true;
  }

  /// Dispose the observer.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateController.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _previousState = _currentState;
    _currentState = _mapState(state);

    // Track background time
    if (_currentState == AppState.background) {
      _backgroundTime = DateTime.now();
    } else if (_currentState == AppState.foreground) {
      _backgroundTime = null;
    }

    // Emit event
    _stateController.add(AppLifecycleEvent(
      state: _currentState,
      previousState: _previousState,
      timestamp: DateTime.now(),
    ));

    // Call callbacks
    switch (_currentState) {
      case AppState.foreground:
        onResume?.call();
        break;
      case AppState.background:
        onPause?.call();
        break;
      case AppState.inactive:
        onInactive?.call();
        break;
      case AppState.detached:
        onDetached?.call();
        break;
      case AppState.unknown:
        break;
    }
  }

  AppState _mapState(AppLifecycleState state) {
    return switch (state) {
      AppLifecycleState.resumed => AppState.foreground,
      AppLifecycleState.paused => AppState.background,
      AppLifecycleState.inactive => AppState.inactive,
      AppLifecycleState.detached => AppState.detached,
      AppLifecycleState.hidden => AppState.background,
    };
  }

  /// Wait for app to resume.
  Future<void> waitForResume({Duration? timeout}) async {
    if (isInForeground) return;

    final completer = Completer<void>();
    StreamSubscription<AppLifecycleEvent>? subscription;

    subscription = onStateChanged.listen((event) {
      if (event.state == AppState.foreground) {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Future.delayed(timeout, () {
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Resume timeout', timeout));
        }
      });
    }

    return completer.future;
  }

  /// Execute callback when app resumes.
  void doOnResume(VoidCallback callback) {
    if (isInForeground) {
      callback();
    } else {
      late StreamSubscription<AppLifecycleEvent> subscription;
      subscription = onStateChanged.listen((event) {
        if (event.state == AppState.foreground) {
          subscription.cancel();
          callback();
        }
      });
    }
  }
}

