/// App configuration model for project generation.
library;

/// Available modules.
enum KiroModule {
  auth('Auth', 'User authentication (email, phone, social login)'),
  wallet('Wallet', 'Digital wallet with transactions'),
  chat('Chat', 'Real-time messaging'),
  booking('Booking', 'Appointment/reservation system'),
  payments('Payments', 'Payment gateway integrations'),
  notifications('Notifications', 'Push notifications (FCM)'),
  tracking('Tracking', 'GPS tracking and maps'),
  profile('Profile', 'User profile management');

  const KiroModule(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Available platforms.
enum Platform {
  android('Android'),
  ios('iOS'),
  web('Web'),
  macos('macOS'),
  windows('Windows'),
  linux('Linux');

  const Platform(this.displayName);

  final String displayName;
}

/// State management options.
/// 
/// NOTE: Currently only Riverpod is supported.
/// Other state management solutions may be added in future versions.
enum StateManagement {
  riverpod('Riverpod', 'Compile-safe, testable state management');

  const StateManagement(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Authentication types.
enum AuthType {
  email('Email & Password'),
  phone('Phone OTP'),
  google('Google Sign-In'),
  apple('Apple Sign-In'),
  facebook('Facebook Login');

  const AuthType(this.displayName);

  final String displayName;
}

/// App configuration for project generation.
class AppConfig {
  /// App name (display name).
  final String appName;

  /// Package name (e.g., com.example.myapp).
  final String packageName;

  /// App description.
  final String description;

  /// Organization name.
  final String organization;

  /// Target platforms.
  final List<Platform> platforms;

  /// Selected modules.
  final List<KiroModule> modules;

  /// State management choice.
  final StateManagement stateManagement;

  /// Authentication types (if auth module selected).
  final List<AuthType> authTypes;

  /// Primary color (hex).
  final String primaryColor;

  /// Secondary color (hex).
  final String? secondaryColor;

  /// Supported locales.
  final List<String> locales;

  /// Default locale.
  final String defaultLocale;

  /// Use Firebase.
  final bool useFirebase;

  /// Initialize Git repository.
  final bool initGit;

  /// Output directory.
  final String outputDirectory;

  /// Include splash screen.
  final bool includeSplash;

  /// Include onboarding screens.
  final bool includeOnboarding;

  /// Bottom navigation tabs (module names).
  final List<String> bottomNavTabs;

  const AppConfig({
    required this.appName,
    required this.packageName,
    required this.description,
    required this.organization,
    required this.platforms,
    required this.modules,
    required this.stateManagement,
    this.authTypes = const [],
    required this.primaryColor,
    this.secondaryColor,
    this.locales = const ['en'],
    this.defaultLocale = 'en',
    this.useFirebase = false,
    this.initGit = true,
    required this.outputDirectory,
    this.includeSplash = false,
    this.includeOnboarding = false,
    this.bottomNavTabs = const [],
  });

  /// Create default config.
  factory AppConfig.defaults({
    required String appName,
    required String outputDirectory,
  }) {
    final packageName = _generatePackageName(appName);
    return AppConfig(
      appName: appName,
      packageName: packageName,
      description: 'A new Flutter application powered by Kiro.',
      organization: 'com.example',
      platforms: [Platform.android, Platform.ios],
      modules: [],
      stateManagement: StateManagement.riverpod,
      primaryColor: '#6366F1',
      outputDirectory: outputDirectory,
      includeSplash: false,
      includeOnboarding: false,
      bottomNavTabs: [],
    );
  }

  /// Convert to JSON for config file.
  Map<String, dynamic> toJson() => {
        'app_name': appName,
        'package_name': packageName,
        'description': description,
        'organization': organization,
        'platforms': platforms.map((p) => p.name).toList(),
        'modules': modules.map((m) => m.name).toList(),
        'state_management': stateManagement.name,
        'auth_types': authTypes.map((a) => a.name).toList(),
        'primary_color': primaryColor,
        if (secondaryColor != null) 'secondary_color': secondaryColor,
        'locales': locales,
        'default_locale': defaultLocale,
        'use_firebase': useFirebase,
        'init_git': initGit,
        'output_directory': outputDirectory,
        'include_splash': includeSplash,
        'include_onboarding': includeOnboarding,
        'bottom_nav_tabs': bottomNavTabs,
      };

  /// Create from JSON.
  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['app_name'] as String,
      packageName: json['package_name'] as String,
      description: json['description'] as String? ?? '',
      organization: json['organization'] as String? ?? 'com.example',
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((p) => Platform.values.firstWhere((e) => e.name == p))
              .toList() ??
          [Platform.android, Platform.ios],
      modules: (json['modules'] as List<dynamic>?)
              ?.map((m) => KiroModule.values.firstWhere((e) => e.name == m))
              .toList() ??
          [],
      stateManagement: StateManagement.values.firstWhere(
        (e) => e.name == json['state_management'],
        orElse: () => StateManagement.riverpod,
      ),
      authTypes: (json['auth_types'] as List<dynamic>?)
              ?.map((a) => AuthType.values.firstWhere((e) => e.name == a))
              .toList() ??
          [],
      primaryColor: json['primary_color'] as String? ?? '#6366F1',
      secondaryColor: json['secondary_color'] as String?,
      locales: (json['locales'] as List<dynamic>?)?.cast<String>() ?? ['en'],
      defaultLocale: json['default_locale'] as String? ?? 'en',
      useFirebase: json['use_firebase'] as bool? ?? false,
      initGit: json['init_git'] as bool? ?? true,
      outputDirectory: json['output_directory'] as String,
      includeSplash: json['include_splash'] as bool? ?? false,
      includeOnboarding: json['include_onboarding'] as bool? ?? false,
      bottomNavTabs: (json['bottom_nav_tabs'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Copy with modifications.
  AppConfig copyWith({
    String? appName,
    String? packageName,
    String? description,
    String? organization,
    List<Platform>? platforms,
    List<KiroModule>? modules,
    StateManagement? stateManagement,
    List<AuthType>? authTypes,
    String? primaryColor,
    String? secondaryColor,
    List<String>? locales,
    String? defaultLocale,
    bool? useFirebase,
    bool? initGit,
    String? outputDirectory,
    bool? includeSplash,
    bool? includeOnboarding,
    List<String>? bottomNavTabs,
  }) {
    return AppConfig(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      description: description ?? this.description,
      organization: organization ?? this.organization,
      platforms: platforms ?? this.platforms,
      modules: modules ?? this.modules,
      stateManagement: stateManagement ?? this.stateManagement,
      authTypes: authTypes ?? this.authTypes,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      locales: locales ?? this.locales,
      defaultLocale: defaultLocale ?? this.defaultLocale,
      useFirebase: useFirebase ?? this.useFirebase,
      initGit: initGit ?? this.initGit,
      outputDirectory: outputDirectory ?? this.outputDirectory,
      includeSplash: includeSplash ?? this.includeSplash,
      includeOnboarding: includeOnboarding ?? this.includeOnboarding,
      bottomNavTabs: bottomNavTabs ?? this.bottomNavTabs,
    );
  }

  /// Get project directory name.
  String get projectDirName => _toValidPackageName(appName);

  /// Get full project path.
  String get projectPath => '$outputDirectory/$projectDirName';

  /// Has auth module.
  bool get hasAuth => modules.contains(KiroModule.auth);

  /// Has payments module.
  bool get hasPayments => modules.contains(KiroModule.payments);

  /// Has notifications module.
  bool get hasNotifications => modules.contains(KiroModule.notifications);

  /// Generate validated package name (public for use in commands).
  static String generatePackageName(String appName, String organization) {
    final sanitized = _toValidPackageName(appName);
    return '$organization.$sanitized';
  }

  static String _generatePackageName(String appName) {
    final sanitized = _toValidPackageName(appName);
    return 'com.example.$sanitized';
  }

  /// Convert app name to valid Dart package name.
  static String _toValidPackageName(String input) {
    var sanitized = _toSnakeCase(input);
    
    // Check if it's a Dart reserved word
    if (_isDartReservedWord(sanitized)) {
      // Append '_app' to make it valid
      sanitized = '${sanitized}_app';
    }
    
    // Ensure it's not empty
    if (sanitized.isEmpty) {
      sanitized = 'my_app';
    }
    
    return sanitized;
  }

  /// Check if a word is a Dart reserved word.
  static bool _isDartReservedWord(String word) {
    const reservedWords = {
      'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch',
      'class', 'const', 'continue', 'covariant', 'default', 'deferred', 'do',
      'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
      'factory', 'false', 'final', 'finally', 'for', 'function', 'get', 'hide',
      'if', 'implements', 'import', 'in', 'interface', 'is', 'library', 'mixin',
      'new', 'null', 'of', 'on', 'operator', 'part', 'required', 'rethrow',
      'return', 'set', 'show', 'static', 'super', 'switch', 'sync', 'this',
      'throw', 'true', 'try', 'typedef', 'var', 'void', 'while', 'with', 'yield',
    };
    return reservedWords.contains(word.toLowerCase());
  }

  static String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '')
        .replaceAll(RegExp(r'_+'), '_')
        .toLowerCase();
  }
}

