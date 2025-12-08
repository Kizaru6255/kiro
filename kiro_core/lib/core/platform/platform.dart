/// Platform services module for Kiro Core.
///
/// Provides:
/// - [DeviceInfoService] - Device and app information
/// - [ConnectivityManager] - Network connectivity monitoring
/// - [AppLifecycleObserver] - App lifecycle events
///
/// ## Quick Start
///
/// ```dart
/// // Device info
/// final deviceInfo = DeviceInfoService();
/// await deviceInfo.init();
/// print('Running on: ${deviceInfo.deviceData?.deviceDescription}');
///
/// // Connectivity
/// final connectivity = ConnectivityManager();
/// await connectivity.init();
/// if (connectivity.isConnected) {
///   await fetchData();
/// }
///
/// // Lifecycle
/// final lifecycle = AppLifecycleObserver();
/// lifecycle.init();
/// lifecycle.onResume = () => refreshData();
/// ```
library;

export 'app_lifecycle.dart';
export 'connectivity_manager.dart';
export 'device_info.dart';

