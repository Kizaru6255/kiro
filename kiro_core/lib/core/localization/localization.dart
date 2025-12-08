/// Localization module for Kiro Core.
///
/// Provides:
/// - [LocaleManager] - Manage app locale and language switching
/// - [SupportedLanguage] - Language definitions
/// - [KiroLocales] - Predefined common locales
/// - [DateTimeFormatter] - Locale-aware date/time formatting
/// - [NumberFormatter] - Locale-aware number/currency formatting
///
/// ## Quick Start
///
/// ```dart
/// // Setup locale manager
/// final localeManager = LocaleManager(
///   supportedLocales: [
///     KiroLocales.english,
///     KiroLocales.spanish,
///     KiroLocales.hindi,
///   ],
///   defaultLocale: KiroLocales.english,
///   storage: prefStorage,
/// );
///
/// await localeManager.init();
///
/// // Use in MaterialApp
/// MaterialApp(
///   locale: localeManager.currentLocale,
///   supportedLocales: localeManager.supportedFlutterLocales,
///   localeResolutionCallback: localeManager.resolveLocale,
/// );
///
/// // Change language
/// await localeManager.setLocale(KiroLocales.spanish.locale);
///
/// // Format dates
/// final dateFormatter = DateTimeFormatter(locale: localeManager.languageCode);
/// print(dateFormatter.formatDate(DateTime.now())); // Dec 8, 2024
/// print(dateFormatter.formatRelative(someDate)); // 2 hours ago
///
/// // Format numbers
/// final numberFormatter = NumberFormatter(locale: localeManager.languageCode);
/// print(numberFormatter.formatCurrency(1234.56)); // $1,234.56
/// print(numberFormatter.formatCompact(1500000)); // 1.5M
/// ```
library;

export 'date_time_formatter.dart';
export 'locale_manager.dart';
export 'number_formatter.dart';
export 'supported_locales.dart';

