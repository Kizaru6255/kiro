/// Cross-platform template enhancements.
library;

/// Generate platform-specific configurations.
class CrossPlatformTemplates {
  /// Generate web-specific configuration.
  static String generateWebConfig() {
    return '''
// Web-specific configuration
class WebConfig {
  static const bool isWeb = true;
  
  // Web-specific settings
  static const String baseUrl = 'https://api.example.com';
  static const bool enableServiceWorker = true;
}
''';
  }

  /// Generate desktop-specific configuration.
  static String generateDesktopConfig() {
    return '''
// Desktop-specific configuration
class DesktopConfig {
  static const bool isDesktop = true;
  
  // Desktop-specific settings
  static const bool enableWindowManagement = true;
  static const Size defaultWindowSize = Size(1200, 800);
}
''';
  }

  /// Generate mobile-specific configuration.
  static String generateMobileConfig() {
    return '''
// Mobile-specific configuration
class MobileConfig {
  static const bool isMobile = true;
  
  // Mobile-specific settings
  static const bool enableBiometrics = true;
  static const bool enablePushNotifications = true;
}
''';
  }

  /// Generate platform detection utility.
  static String generatePlatformDetector() {
    return '''
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform detection utility.
class PlatformDetector {
  PlatformDetector._();

  /// Check if running on web.
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (Android/iOS).
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if running on desktop (macOS/Windows/Linux).
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  /// Check if running on Android.
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Check if running on iOS.
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Check if running on macOS.
  static bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  /// Check if running on Windows.
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// Check if running on Linux.
  static bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }
}
''';
  }
}


