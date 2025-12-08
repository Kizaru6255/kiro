/// Network connectivity monitoring service.
///
/// Provides real-time network connectivity status
/// with stream-based updates.
library;

import 'dart:async' show Completer, StreamController, StreamSubscription, TimeoutException;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../errors/errors.dart' show NoInternetException;

/// Network connectivity status.
enum ConnectivityStatus {
  /// Device is connected to the internet.
  connected,

  /// Device is disconnected from the internet.
  disconnected,

  /// Checking connectivity status.
  checking,
}

/// Type of network connection.
enum ConnectionType {
  /// Connected via WiFi.
  wifi,

  /// Connected via mobile data.
  mobile,

  /// Connected via ethernet.
  ethernet,

  /// Connected via VPN.
  vpn,

  /// Connected via Bluetooth.
  bluetooth,

  /// No connection.
  none,

  /// Unknown connection type.
  unknown,
}

/// Connectivity change event.
class ConnectivityEvent {
  /// Current connectivity status.
  final ConnectivityStatus status;

  /// Current connection type.
  final ConnectionType connectionType;

  /// Previous status (for change detection).
  final ConnectivityStatus? previousStatus;

  /// Timestamp of the event.
  final DateTime timestamp;

  const ConnectivityEvent({
    required this.status,
    required this.connectionType,
    this.previousStatus,
    required this.timestamp,
  });

  /// Whether this is a connection event.
  bool get isConnected => status == ConnectivityStatus.connected;

  /// Whether this is a disconnection event.
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  /// Whether the status changed.
  bool get statusChanged => previousStatus != null && previousStatus != status;

  @override
  String toString() =>
      'ConnectivityEvent($status, $connectionType, changed: $statusChanged)';
}

/// Service for monitoring network connectivity.
///
/// Features:
/// - Real-time connectivity monitoring
/// - Stream-based status updates
/// - Internet reachability check
/// - Connection type detection
///
/// Example:
/// ```dart
/// final connectivity = ConnectivityManager();
/// await connectivity.init();
///
/// // Check current status
/// if (connectivity.isConnected) {
///   await fetchData();
/// }
///
/// // Listen to changes
/// connectivity.onStatusChanged.listen((event) {
///   if (event.isDisconnected) {
///     showOfflineMessage();
///   }
/// });
/// ```
class ConnectivityManager {
  final Connectivity _connectivity;
  final StreamController<ConnectivityEvent> _statusController;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityStatus _currentStatus = ConnectivityStatus.checking;
  ConnectionType _connectionType = ConnectionType.none;
  bool _initialized = false;

  /// Create a connectivity manager.
  ConnectivityManager()
      : _connectivity = Connectivity(),
        _statusController = StreamController<ConnectivityEvent>.broadcast();

  /// Whether the manager is initialized.
  bool get isInitialized => _initialized;

  /// Current connectivity status.
  ConnectivityStatus get status => _currentStatus;

  /// Current connection type.
  ConnectionType get connectionType => _connectionType;

  /// Whether currently connected.
  bool get isConnected => _currentStatus == ConnectivityStatus.connected;

  /// Whether currently disconnected.
  bool get isDisconnected => _currentStatus == ConnectivityStatus.disconnected;

  /// Stream of connectivity events.
  Stream<ConnectivityEvent> get onStatusChanged => _statusController.stream;

  /// Initialize the connectivity manager.
  Future<void> init() async {
    if (_initialized) return;

    await _checkConnectivity();

    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );

    _initialized = true;
  }

  /// Dispose resources.
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }

  /// Manually check connectivity.
  Future<bool> checkConnectivity() async {
    await _checkConnectivity();
    return isConnected;
  }

  /// Check if we can actually reach the internet.
  ///
  /// This performs a DNS lookup to verify connectivity,
  /// not just network interface availability.
  Future<bool> hasInternetAccess({
    String host = 'google.com',
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (!isConnected) return false;

    try {
      final result = await InternetAddress.lookup(host).timeout(timeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  /// Wait for connectivity.
  ///
  /// Returns immediately if already connected,
  /// otherwise waits for a connection.
  Future<void> waitForConnectivity({Duration? timeout}) async {
    if (isConnected) return;

    final completer = Completer<void>();
    StreamSubscription<ConnectivityEvent>? subscription;

    subscription = onStatusChanged.listen((event) {
      if (event.isConnected) {
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
          completer.completeError(
            TimeoutException('Connectivity timeout', timeout),
          );
        }
      });
    }

    return completer.future;
  }

  Future<void> _checkConnectivity() async {
    final previousStatus = _currentStatus;
    _currentStatus = ConnectivityStatus.checking;

    final results = await _connectivity.checkConnectivity();
    _handleConnectivityChange(results, previousStatus: previousStatus);
  }

  void _handleConnectivityChange(
    List<ConnectivityResult> results, {
    ConnectivityStatus? previousStatus,
  }) {
    previousStatus ??= _currentStatus;

    final result = results.firstOrNull ?? ConnectivityResult.none;

    _connectionType = _mapConnectionType(result);

    final newStatus = result == ConnectivityResult.none
        ? ConnectivityStatus.disconnected
        : ConnectivityStatus.connected;

    if (newStatus != _currentStatus || previousStatus != _currentStatus) {
      _currentStatus = newStatus;

      _statusController.add(ConnectivityEvent(
        status: _currentStatus,
        connectionType: _connectionType,
        previousStatus: previousStatus,
        timestamp: DateTime.now(),
      ));
    }
  }

  ConnectionType _mapConnectionType(ConnectivityResult result) {
    return switch (result) {
      ConnectivityResult.wifi => ConnectionType.wifi,
      ConnectivityResult.mobile => ConnectionType.mobile,
      ConnectivityResult.ethernet => ConnectionType.ethernet,
      ConnectivityResult.vpn => ConnectionType.vpn,
      ConnectivityResult.bluetooth => ConnectionType.bluetooth,
      ConnectivityResult.none => ConnectionType.none,
      _ => ConnectionType.unknown,
    };
  }
}

/// Mixin for widgets/classes that need connectivity awareness.
///
/// Example:
/// ```dart
/// class MyService with ConnectivityAware {
///   Future<void> fetchData() async {
///     await requireConnectivity();
///     // Now we're connected
///     await api.fetch();
///   }
/// }
/// ```
mixin ConnectivityAware {
  ConnectivityManager get connectivityManager;

  /// Whether currently connected.
  bool get isConnected => connectivityManager.isConnected;

  /// Require connectivity before proceeding.
  ///
  /// Throws if not connected and [throwIfDisconnected] is true.
  Future<void> requireConnectivity({
    bool throwIfDisconnected = true,
    Duration? waitTimeout,
  }) async {
    if (connectivityManager.isConnected) return;

    if (waitTimeout != null) {
      try {
        await connectivityManager.waitForConnectivity(timeout: waitTimeout);
        return;
      } catch (_) {
        if (throwIfDisconnected) rethrow;
      }
    }

    if (throwIfDisconnected) {
      throw const NoInternetException();
    }
  }
}


