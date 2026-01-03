/// Config folder templates.
library;

/// Generate app_config.dart.
String generateAppConfig({
  required String appName,
  required String primaryColor,
}) => '''
/// Application configuration.
library;

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide configuration and initialization.
class AppConfig {
  AppConfig._();
  
  static bool _initialized = false;
  static Dio? _dio;
  static SharedPreferences? _prefs;
  
  /// Whether the app is initialized.
  static bool get isInitialized => _initialized;
  
  /// Dio instance for network requests.
  static Dio get dio {
    if (_dio == null) {
      throw StateError('AppConfig not initialized. Call AppConfig.initialize() first.');
    }
    return _dio!;
  }
  
  /// SharedPreferences instance.
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('AppConfig not initialized. Call AppConfig.initialize() first.');
    }
    return _prefs!;
  }
  
  /// API base URL.
  /// TODO: Update this with your actual API base URL.
  static const String apiBaseUrl = 'https://api.example.com';
  
  /// Initialize app services.
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize Dio for network requests
    _dio = Dio(BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add logging interceptor in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio!.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
    
    _initialized = true;
  }
  
  /// App name.
  static const String appName = '$appName';
  
  /// Primary color.
  static const int primaryColorValue = ${_parseColor(primaryColor)};
}
''';

/// Generate theme.dart.
String generateTheme({required String primaryColor}) {
  final colorValue = _parseColor(primaryColor);
  
  return '''
/// App theme configuration.
library;

import 'package:flutter/material.dart';

/// App theme definitions.
class AppTheme {
  AppTheme._();
  
  /// Primary color.
  static const Color primaryColor = Color($colorValue);
  
  /// Light theme.
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  /// Dark theme.
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
''';
}

/// Generate router.dart.
String generateRouter({
  required String stateManagement,
  required List<String> modules,
}) {
  final routes = StringBuffer();
  final imports = StringBuffer();
  
  // Base imports
  imports.writeln("import 'package:flutter/material.dart';");
  imports.writeln("import 'package:go_router/go_router.dart';");
  imports.writeln();
  imports.writeln("import '../features/home/home_screen.dart';");
  
  // Module imports and routes
  if (modules.contains('auth')) {
    imports.writeln("import '../modules/auth/screens/login_screen.dart';");
    imports.writeln("import '../modules/auth/screens/signup_screen.dart';");
    imports.writeln("import '../modules/auth/screens/forgot_password_screen.dart';");
    imports.writeln("import '../modules/auth/screens/verify_otp_screen.dart';");
    
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.login,');
    routes.writeln('      name: \'login\',');
    routes.writeln('      builder: (context, state) => const LoginScreen(),');
    routes.writeln('    ),');
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.signup,');
    routes.writeln('      name: \'signup\',');
    routes.writeln('      builder: (context, state) => const SignupScreen(),');
    routes.writeln('    ),');
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.forgotPassword,');
    routes.writeln('      name: \'forgotPassword\',');
    routes.writeln('      builder: (context, state) => const ForgotPasswordScreen(),');
    routes.writeln('    ),');
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.verifyOtp,');
    routes.writeln('      name: \'verifyOtp\',');
    routes.writeln('      builder: (context, state) {');
    routes.writeln('        final phoneNumber = state.uri.queryParameters[\'phone\'] ?? \'\';');
    routes.writeln('        return VerifyOtpScreen(phoneNumber: phoneNumber);');
    routes.writeln('      },');
    routes.writeln('    ),');
  }
  
  if (modules.contains('profile')) {
    imports.writeln("import '../modules/profile/screens/profile_screen.dart';");
    
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.profile,');
    routes.writeln('      name: \'profile\',');
    routes.writeln('      builder: (context, state) => const ProfileScreen(),');
    routes.writeln('    ),');
  }
  
  if (modules.contains('wallet')) {
    imports.writeln("import '../modules/wallet/screens/wallet_screen.dart';");
    
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.wallet,');
    routes.writeln('      name: \'wallet\',');
    routes.writeln('      builder: (context, state) => const WalletScreen(),');
    routes.writeln('    ),');
  }
  
  if (modules.contains('booking')) {
    imports.writeln("import '../modules/booking/screens/create_booking_screen.dart';");
    
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.createBooking,');
    routes.writeln('      name: \'createBooking\',');
    routes.writeln('      builder: (context, state) => const CreateBookingScreen(),');
    routes.writeln('    ),');
  }
  
  if (modules.contains('notifications')) {
    imports.writeln("import '../modules/notifications/screens/notifications_screen.dart';");
    
    routes.writeln('    GoRoute(');
    routes.writeln('      path: AppRoutes.notifications,');
    routes.writeln('      name: \'notifications\',');
    routes.writeln('      builder: (context, state) => const NotificationsScreen(),');
    routes.writeln('    ),');
  }
  
  // Build route constants
  final routeConstants = StringBuffer();
  routeConstants.writeln('  static const String home = \'/\';');
  if (modules.contains('auth')) {
    routeConstants.writeln('  static const String login = \'/login\';');
    routeConstants.writeln('  static const String signup = \'/signup\';');
    routeConstants.writeln('  static const String forgotPassword = \'/forgot-password\';');
    routeConstants.writeln('  static const String verifyOtp = \'/verify-otp\';');
  }
  if (modules.contains('profile')) {
    routeConstants.writeln('  static const String profile = \'/profile\';');
  }
  if (modules.contains('wallet')) {
    routeConstants.writeln('  static const String wallet = \'/wallet\';');
  }
  if (modules.contains('booking')) {
    routeConstants.writeln('  static const String createBooking = \'/create-booking\';');
  }
  if (modules.contains('notifications')) {
    routeConstants.writeln('  static const String notifications = \'/notifications\';');
  }
  routeConstants.writeln('  static const String settings = \'/settings\';');
  
  return '''
/// App router configuration.
library;

$imports
/// App routes.
class AppRoutes {
  AppRoutes._();
  
$routeConstants
}

/// App router.
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
$routes
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Page not found: \${state.uri.path}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
''';
}

String _parseColor(String hex) {
  var color = hex.replaceFirst('#', '');
  if (color.length == 6) {
    color = 'FF$color';
  }
  return '0x$color';
}

