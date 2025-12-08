/// Locale manager for handling app localization.
library;

import 'dart:ui';

import 'package:flutter/material.dart';

import '../storage/storage.dart';
import 'supported_locales.dart';

/// Locale change callback.
typedef LocaleChangeCallback = void Function(Locale locale);

/// Manager for app localization.
///
/// Features:
/// - Locale switching
/// - Persistence of language preference
/// - RTL support detection
/// - System locale detection
///
/// Example:
/// ```dart
/// final localeManager = LocaleManager(
///   supportedLocales: [KiroLocales.english, KiroLocales.spanish],
///   defaultLocale: KiroLocales.english,
///   storage: prefStorage,
/// );
///
/// await localeManager.init();
///
/// // Change locale
/// await localeManager.setLocale(KiroLocales.spanish.locale);
///
/// // Use in MaterialApp
/// MaterialApp(
///   locale: localeManager.currentLocale,
///   supportedLocales: localeManager.supportedFlutterLocales,
/// );
/// ```
class LocaleManager extends ChangeNotifier {
  /// Supported languages for this app.
  final List<SupportedLanguage> supportedLocales;

  /// Default/fallback language.
  final SupportedLanguage defaultLocale;

  /// Storage for persisting preference.
  final StorageService? storage;

  /// Storage key for locale preference.
  final String storageKey;

  /// Current selected language.
  SupportedLanguage _currentLanguage;

  /// Whether manager is initialized.
  bool _initialized = false;

  /// Listeners for locale changes.
  final List<LocaleChangeCallback> _listeners = [];

  /// Create a locale manager.
  LocaleManager({
    required this.supportedLocales,
    required this.defaultLocale,
    this.storage,
    this.storageKey = 'app_locale',
  }) : _currentLanguage = defaultLocale {
    assert(supportedLocales.isNotEmpty);
    assert(supportedLocales.contains(defaultLocale));
  }

  /// Whether manager is initialized.
  bool get isInitialized => _initialized;

  /// Current locale.
  Locale get currentLocale => _currentLanguage.locale;

  /// Current language.
  SupportedLanguage get currentLanguage => _currentLanguage;

  /// Current language code.
  String get languageCode => _currentLanguage.languageCode;

  /// Whether current language is RTL.
  bool get isRTL => _currentLanguage.isRTL;

  /// Current text direction.
  TextDirection get textDirection => _currentLanguage.textDirection;

  /// Flutter-compatible list of supported locales.
  List<Locale> get supportedFlutterLocales =>
      supportedLocales.map((l) => l.locale).toList();

  /// Initialize the manager.
  Future<void> init() async {
    if (_initialized) return;

    // Try to load saved preference
    if (storage != null) {
      final savedCode = await storage!.getString(storageKey);
      if (savedCode != null) {
        final language = _findLanguage(savedCode);
        if (language != null) {
          _currentLanguage = language;
        }
      }
    }

    _initialized = true;
  }

  /// Set locale by Locale object.
  Future<void> setLocale(Locale locale) async {
    final language = _findLanguageByLocale(locale);
    if (language != null) {
      await setLanguage(language);
    }
  }

  /// Set locale by language code.
  Future<void> setLocaleByCode(String code) async {
    final language = _findLanguage(code);
    if (language != null) {
      await setLanguage(language);
    }
  }

  /// Set language.
  Future<void> setLanguage(SupportedLanguage language) async {
    if (!supportedLocales.contains(language)) {
      return;
    }

    if (_currentLanguage == language) {
      return;
    }

    _currentLanguage = language;

    // Persist preference
    if (storage != null) {
      await storage!.setString(storageKey, language.code);
    }

    // Notify listeners
    for (final listener in _listeners) {
      listener(currentLocale);
    }

    notifyListeners();
  }

  /// Reset to default locale.
  Future<void> resetToDefault() async {
    await setLanguage(defaultLocale);
  }

  /// Use system locale if supported.
  Future<void> useSystemLocale() async {
    final systemLocale = PlatformDispatcher.instance.locale;
    final language = _findLanguageByLocale(systemLocale);

    if (language != null) {
      await setLanguage(language);
    } else {
      await setLanguage(defaultLocale);
    }
  }

  /// Check if a locale is supported.
  bool isSupported(Locale locale) {
    return _findLanguageByLocale(locale) != null;
  }

  /// Add locale change listener.
  void addListener2(LocaleChangeCallback callback) {
    _listeners.add(callback);
  }

  /// Remove locale change listener.
  void removeListener2(LocaleChangeCallback callback) {
    _listeners.remove(callback);
  }

  /// Resolve locale from system preferences.
  ///
  /// Use this as the localeResolutionCallback in MaterialApp.
  Locale? resolveLocale(
    List<Locale>? locales,
    Iterable<Locale> supportedLocales,
  ) {
    if (locales == null || locales.isEmpty) {
      return defaultLocale.locale;
    }

    // Return saved preference if initialized
    if (_initialized) {
      return currentLocale;
    }

    // Try to match system locales
    for (final locale in locales) {
      final language = _findLanguageByLocale(locale);
      if (language != null) {
        return language.locale;
      }
    }

    return defaultLocale.locale;
  }

  SupportedLanguage? _findLanguage(String code) {
    try {
      return supportedLocales.firstWhere(
        (lang) => lang.code == code || lang.languageCode == code,
      );
    } catch (_) {
      return null;
    }
  }

  SupportedLanguage? _findLanguageByLocale(Locale locale) {
    try {
      // Try exact match first
      return supportedLocales.firstWhere(
        (lang) => lang.locale == locale,
        orElse: () => supportedLocales.firstWhere(
          (lang) => lang.languageCode == locale.languageCode,
        ),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Locale-aware widget builder.
///
/// Rebuilds when locale changes.
class LocaleBuilder extends StatelessWidget {
  /// Locale manager.
  final LocaleManager localeManager;

  /// Builder function.
  final Widget Function(BuildContext context, Locale locale) builder;

  const LocaleBuilder({
    super.key,
    required this.localeManager,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeManager,
      builder: (context, child) => builder(context, localeManager.currentLocale),
    );
  }
}

