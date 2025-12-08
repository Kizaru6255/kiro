/// Kiro Core - The foundation package for Kiro-powered Flutter applications.
///
/// This package provides core infrastructure including:
/// - **Errors** - Exception classes and Result type for error handling
/// - **Logger** - Flexible logging system
/// - **Utils** - Validators, extensions, and utilities
/// - **Storage** - Local data persistence (PrefStorage, SecureStorage, Cache)
/// - **Network** - HTTP client and API services (DioClient, Interceptors)
/// - **Platform** - Device info, connectivity, and lifecycle monitoring
/// - **Permissions** - Runtime permission handling
/// - **Theme** - Dynamic theming system
/// - **Localization** - Multi-language support with date/number formatting
/// - **Routing** - Type-safe routing with guards and transitions
///
/// ## Quick Start
///
/// ```dart
/// import 'package:kiro_core/kiro_core.dart';
///
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize storage
///   final prefStorage = PrefStorage();
///   await prefStorage.init();
///
///   // Initialize device info & connectivity
///   final deviceInfo = DeviceInfoService();
///   final connectivity = ConnectivityManager();
///   await deviceInfo.init();
///   await connectivity.init();
///
///   // Initialize network
///   DioClient.initialize(
///     config: DioClientConfig(baseUrl: 'https://api.example.com'),
///   );
///
///   // Setup theme
///   final themeManager = ThemeManager(
///     config: ThemeConfig(primaryColor: Colors.indigo),
///   );
///
///   // Setup localization
///   final localeManager = LocaleManager(
///     supportedLocales: [KiroLocales.english, KiroLocales.spanish],
///     defaultLocale: KiroLocales.english,
///     storage: prefStorage,
///   );
///   await localeManager.init();
///
///   // Initialize logger
///   KiroLogger.initialize(tag: 'MyApp');
///   logger.info('App started on ${deviceInfo.deviceData?.deviceDescription}');
///
///   runApp(const MyApp());
/// }
/// ```
///
/// ## Error Handling
///
/// Kiro Core provides two approaches to error handling:
///
/// ### 1. Exception-based (traditional)
/// ```dart
/// try {
///   await api.fetch();
/// } on NetworkException catch (e) {
///   handleError(e);
/// }
/// ```
///
/// ### 2. Result-based (functional)
/// ```dart
/// final result = await repository.getUser();
/// result.fold(
///   onSuccess: (user) => showUser(user),
///   onFailure: (failure) => showError(failure.message),
/// );
/// ```
///
/// ## Theme & Localization
///
/// ```dart
/// MaterialApp(
///   theme: themeManager.lightTheme,
///   darkTheme: themeManager.darkTheme,
///   themeMode: themeManager.themeMode,
///   locale: localeManager.currentLocale,
///   supportedLocales: localeManager.supportedFlutterLocales,
/// );
///
/// // Toggle theme
/// themeManager.toggleMode();
///
/// // Change language
/// await localeManager.setLocale(KiroLocales.spanish.locale);
/// ```
///
/// ## Routing with Guards
///
/// ```dart
/// final router = AppRouter(
///   initialRoute: AppRoutes.home,
///   guards: [AuthGuard(authService)],
///   routes: [...],
/// );
///
/// MaterialApp.router(routerConfig: router.config);
/// ```
library kiro_core;

// Errors
export 'core/errors/errors.dart';

// Logger
export 'core/logger/logger.dart';

// Utils
export 'core/utils/utils.dart';

// Storage
export 'core/storage/storage.dart';

// Network
export 'core/network/network.dart';

// Platform (Device Info, Connectivity, Lifecycle)
export 'core/platform/platform.dart';

// Permissions
export 'core/permissions/permissions.dart';

// Theme
export 'core/theme/theme.dart';

// Localization
export 'core/localization/localization.dart';

// Routing
export 'core/routing/routing.dart';
