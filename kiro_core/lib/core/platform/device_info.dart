/// Device information service.
///
/// Provides device and app information for analytics,
/// debugging, and feature detection.
library;

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Device information model.
class DeviceData {
  /// Platform name (android, ios, web, etc.)
  final String platform;

  /// Operating system version.
  final String osVersion;

  /// SDK version (Android API level).
  final String sdkVersion;

  /// Device manufacturer.
  final String manufacturer;

  /// Device model name.
  final String model;

  /// Unique device identifier.
  final String deviceId;

  /// Whether running on a physical device.
  final bool isPhysicalDevice;

  /// App version (e.g., "1.0.0").
  final String appVersion;

  /// Build number (e.g., "1").
  final String buildNumber;

  /// Package name / bundle identifier.
  final String packageName;

  /// App name.
  final String appName;

  const DeviceData({
    required this.platform,
    required this.osVersion,
    required this.sdkVersion,
    required this.manufacturer,
    required this.model,
    required this.deviceId,
    required this.isPhysicalDevice,
    required this.appVersion,
    required this.buildNumber,
    required this.packageName,
    required this.appName,
  });

  /// Full version string (e.g., "1.0.0+1").
  String get fullVersion => '$appVersion+$buildNumber';

  /// Platform and version string (e.g., "Android 13").
  String get platformVersion => '$platform $osVersion';

  /// Device description (e.g., "Samsung Galaxy S21").
  String get deviceDescription => '$manufacturer $model';

  /// Convert to map for analytics/logging.
  Map<String, dynamic> toJson() => {
        'platform': platform,
        'osVersion': osVersion,
        'sdkVersion': sdkVersion,
        'manufacturer': manufacturer,
        'model': model,
        'deviceId': deviceId,
        'isPhysicalDevice': isPhysicalDevice,
        'appVersion': appVersion,
        'buildNumber': buildNumber,
        'packageName': packageName,
        'appName': appName,
      };

  @override
  String toString() => 'DeviceData($deviceDescription, $platformVersion, v$fullVersion)';
}

/// Service for accessing device and app information.
///
/// Example:
/// ```dart
/// final deviceInfo = DeviceInfoService();
/// await deviceInfo.init();
///
/// print('Device: ${deviceInfo.deviceData.deviceDescription}');
/// print('App version: ${deviceInfo.appVersion}');
/// ```
class DeviceInfoService {
  DeviceInfoPlugin? _deviceInfoPlugin;
  PackageInfo? _packageInfo;
  DeviceData? _deviceData;
  bool _initialized = false;

  /// Whether the service is initialized.
  bool get isInitialized => _initialized;

  /// Cached device data.
  DeviceData? get deviceData => _deviceData;

  /// App version.
  String get appVersion => _packageInfo?.version ?? 'unknown';

  /// Build number.
  String get buildNumber => _packageInfo?.buildNumber ?? 'unknown';

  /// Full version string.
  String get fullVersion => '$appVersion+$buildNumber';

  /// Package name.
  String get packageName => _packageInfo?.packageName ?? 'unknown';

  /// App name.
  String get appName => _packageInfo?.appName ?? 'unknown';

  /// Initialize the service.
  Future<void> init() async {
    if (_initialized) return;

    _deviceInfoPlugin = DeviceInfoPlugin();
    _packageInfo = await PackageInfo.fromPlatform();
    _deviceData = await _loadDeviceData();
    _initialized = true;
  }

  /// Get device data (initializes if needed).
  Future<DeviceData> getDeviceData() async {
    if (!_initialized) {
      await init();
    }
    return _deviceData!;
  }

  Future<DeviceData> _loadDeviceData() async {
    if (Platform.isAndroid) {
      return _loadAndroidData();
    } else if (Platform.isIOS) {
      return _loadIosData();
    } else if (Platform.isMacOS) {
      return _loadMacOsData();
    } else if (Platform.isWindows) {
      return _loadWindowsData();
    } else if (Platform.isLinux) {
      return _loadLinuxData();
    }

    return DeviceData(
      platform: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      sdkVersion: 'unknown',
      manufacturer: 'unknown',
      model: 'unknown',
      deviceId: 'unknown',
      isPhysicalDevice: true,
      appVersion: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
      packageName: _packageInfo!.packageName,
      appName: _packageInfo!.appName,
    );
  }

  Future<DeviceData> _loadAndroidData() async {
    final info = await _deviceInfoPlugin!.androidInfo;
    return DeviceData(
      platform: 'Android',
      osVersion: info.version.release,
      sdkVersion: info.version.sdkInt.toString(),
      manufacturer: info.manufacturer,
      model: info.model,
      deviceId: info.id,
      isPhysicalDevice: info.isPhysicalDevice,
      appVersion: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
      packageName: _packageInfo!.packageName,
      appName: _packageInfo!.appName,
    );
  }

  Future<DeviceData> _loadIosData() async {
    final info = await _deviceInfoPlugin!.iosInfo;
    return DeviceData(
      platform: 'iOS',
      osVersion: info.systemVersion,
      sdkVersion: info.systemVersion,
      manufacturer: 'Apple',
      model: info.model,
      deviceId: info.identifierForVendor ?? 'unknown',
      isPhysicalDevice: info.isPhysicalDevice,
      appVersion: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
      packageName: _packageInfo!.packageName,
      appName: _packageInfo!.appName,
    );
  }

  Future<DeviceData> _loadMacOsData() async {
    final info = await _deviceInfoPlugin!.macOsInfo;
    return DeviceData(
      platform: 'macOS',
      osVersion: info.osRelease,
      sdkVersion: info.osRelease,
      manufacturer: 'Apple',
      model: info.model,
      deviceId: info.systemGUID ?? 'unknown',
      isPhysicalDevice: true,
      appVersion: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
      packageName: _packageInfo!.packageName,
      appName: _packageInfo!.appName,
    );
  }

  Future<DeviceData> _loadWindowsData() async {
    final info = await _deviceInfoPlugin!.windowsInfo;
    return DeviceData(
      platform: 'Windows',
      osVersion: '${info.majorVersion}.${info.minorVersion}',
      sdkVersion: info.buildNumber.toString(),
      manufacturer: 'Microsoft',
      model: info.productName,
      deviceId: info.deviceId,
      isPhysicalDevice: true,
      appVersion: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
      packageName: _packageInfo!.packageName,
      appName: _packageInfo!.appName,
    );
  }

  Future<DeviceData> _loadLinuxData() async {
    final info = await _deviceInfoPlugin!.linuxInfo;
    return DeviceData(
      platform: 'Linux',
      osVersion: info.version ?? 'unknown',
      sdkVersion: info.versionId ?? 'unknown',
      manufacturer: 'Linux',
      model: info.prettyName,
      deviceId: info.machineId ?? 'unknown',
      isPhysicalDevice: true,
      appVersion: _packageInfo!.version,
      buildNumber: _packageInfo!.buildNumber,
      packageName: _packageInfo!.packageName,
      appName: _packageInfo!.appName,
    );
  }

  /// Check if running on a physical device.
  Future<bool> isPhysicalDevice() async {
    final data = await getDeviceData();
    return data.isPhysicalDevice;
  }

  /// Check if running on Android.
  bool get isAndroid => Platform.isAndroid;

  /// Check if running on iOS.
  bool get isIOS => Platform.isIOS;

  /// Check if running on mobile (Android or iOS).
  bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Check if running on desktop.
  bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}

