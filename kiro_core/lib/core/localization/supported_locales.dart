/// Supported locales and language definitions.
library;

import 'dart:ui';

/// Supported language definition.
class SupportedLanguage {
  /// Locale code.
  final Locale locale;

  /// Display name in the language.
  final String nativeName;

  /// English name.
  final String englishName;

  /// Flag emoji.
  final String flag;

  /// Text direction.
  final TextDirection textDirection;

  const SupportedLanguage({
    required this.locale,
    required this.nativeName,
    required this.englishName,
    required this.flag,
    this.textDirection = TextDirection.ltr,
  });

  /// Language code (e.g., 'en').
  String get languageCode => locale.languageCode;

  /// Country code (e.g., 'US').
  String? get countryCode => locale.countryCode;

  /// Full locale code (e.g., 'en_US').
  String get code => countryCode != null
      ? '${languageCode}_$countryCode'
      : languageCode;

  /// Whether this is an RTL language.
  bool get isRTL => textDirection == TextDirection.rtl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportedLanguage &&
          runtimeType == other.runtimeType &&
          locale == other.locale;

  @override
  int get hashCode => locale.hashCode;

  @override
  String toString() => 'SupportedLanguage($code, $nativeName)';
}

/// Common supported languages.
class KiroLocales {
  KiroLocales._();

  /// English (US).
  static const english = SupportedLanguage(
    locale: Locale('en', 'US'),
    nativeName: 'English',
    englishName: 'English',
    flag: '🇺🇸',
  );

  /// English (UK).
  static const englishUK = SupportedLanguage(
    locale: Locale('en', 'GB'),
    nativeName: 'English',
    englishName: 'English (UK)',
    flag: '🇬🇧',
  );

  /// Spanish.
  static const spanish = SupportedLanguage(
    locale: Locale('es', 'ES'),
    nativeName: 'Español',
    englishName: 'Spanish',
    flag: '🇪🇸',
  );

  /// French.
  static const french = SupportedLanguage(
    locale: Locale('fr', 'FR'),
    nativeName: 'Français',
    englishName: 'French',
    flag: '🇫🇷',
  );

  /// German.
  static const german = SupportedLanguage(
    locale: Locale('de', 'DE'),
    nativeName: 'Deutsch',
    englishName: 'German',
    flag: '🇩🇪',
  );

  /// Italian.
  static const italian = SupportedLanguage(
    locale: Locale('it', 'IT'),
    nativeName: 'Italiano',
    englishName: 'Italian',
    flag: '🇮🇹',
  );

  /// Portuguese (Brazil).
  static const portuguese = SupportedLanguage(
    locale: Locale('pt', 'BR'),
    nativeName: 'Português',
    englishName: 'Portuguese',
    flag: '🇧🇷',
  );

  /// Russian.
  static const russian = SupportedLanguage(
    locale: Locale('ru', 'RU'),
    nativeName: 'Русский',
    englishName: 'Russian',
    flag: '🇷🇺',
  );

  /// Chinese (Simplified).
  static const chinese = SupportedLanguage(
    locale: Locale('zh', 'CN'),
    nativeName: '中文',
    englishName: 'Chinese',
    flag: '🇨🇳',
  );

  /// Japanese.
  static const japanese = SupportedLanguage(
    locale: Locale('ja', 'JP'),
    nativeName: '日本語',
    englishName: 'Japanese',
    flag: '🇯🇵',
  );

  /// Korean.
  static const korean = SupportedLanguage(
    locale: Locale('ko', 'KR'),
    nativeName: '한국어',
    englishName: 'Korean',
    flag: '🇰🇷',
  );

  /// Hindi.
  static const hindi = SupportedLanguage(
    locale: Locale('hi', 'IN'),
    nativeName: 'हिन्दी',
    englishName: 'Hindi',
    flag: '🇮🇳',
  );

  /// Marathi.
  static const marathi = SupportedLanguage(
    locale: Locale('mr', 'IN'),
    nativeName: 'मराठी',
    englishName: 'Marathi',
    flag: '🇮🇳',
  );

  /// Arabic.
  static const arabic = SupportedLanguage(
    locale: Locale('ar', 'SA'),
    nativeName: 'العربية',
    englishName: 'Arabic',
    flag: '🇸🇦',
    textDirection: TextDirection.rtl,
  );

  /// Hebrew.
  static const hebrew = SupportedLanguage(
    locale: Locale('he', 'IL'),
    nativeName: 'עברית',
    englishName: 'Hebrew',
    flag: '🇮🇱',
    textDirection: TextDirection.rtl,
  );

  /// Turkish.
  static const turkish = SupportedLanguage(
    locale: Locale('tr', 'TR'),
    nativeName: 'Türkçe',
    englishName: 'Turkish',
    flag: '🇹🇷',
  );

  /// Dutch.
  static const dutch = SupportedLanguage(
    locale: Locale('nl', 'NL'),
    nativeName: 'Nederlands',
    englishName: 'Dutch',
    flag: '🇳🇱',
  );

  /// Polish.
  static const polish = SupportedLanguage(
    locale: Locale('pl', 'PL'),
    nativeName: 'Polski',
    englishName: 'Polish',
    flag: '🇵🇱',
  );

  /// Thai.
  static const thai = SupportedLanguage(
    locale: Locale('th', 'TH'),
    nativeName: 'ไทย',
    englishName: 'Thai',
    flag: '🇹🇭',
  );

  /// Vietnamese.
  static const vietnamese = SupportedLanguage(
    locale: Locale('vi', 'VN'),
    nativeName: 'Tiếng Việt',
    englishName: 'Vietnamese',
    flag: '🇻🇳',
  );

  /// Indonesian.
  static const indonesian = SupportedLanguage(
    locale: Locale('id', 'ID'),
    nativeName: 'Bahasa Indonesia',
    englishName: 'Indonesian',
    flag: '🇮🇩',
  );

  /// All supported languages.
  static const List<SupportedLanguage> all = [
    english,
    englishUK,
    spanish,
    french,
    german,
    italian,
    portuguese,
    russian,
    chinese,
    japanese,
    korean,
    hindi,
    marathi,
    arabic,
    hebrew,
    turkish,
    dutch,
    polish,
    thai,
    vietnamese,
    indonesian,
  ];

  /// RTL languages.
  static List<SupportedLanguage> get rtlLanguages =>
      all.where((lang) => lang.isRTL).toList();

  /// Get language by code.
  static SupportedLanguage? byCode(String code) {
    try {
      return all.firstWhere(
        (lang) =>
            lang.code == code ||
            lang.languageCode == code,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get language by locale.
  static SupportedLanguage? byLocale(Locale locale) {
    try {
      // Try exact match first
      return all.firstWhere(
        (lang) => lang.locale == locale,
        orElse: () => all.firstWhere(
          (lang) => lang.languageCode == locale.languageCode,
        ),
      );
    } catch (_) {
      return null;
    }
  }
}

