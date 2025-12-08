/// Number and currency formatting utilities.
library;

import 'package:intl/intl.dart';

/// Number formatter with locale support.
///
/// Example:
/// ```dart
/// final formatter = NumberFormatter(locale: 'en_US');
///
/// print(formatter.format(1234567)); // 1,234,567
/// print(formatter.formatCurrency(1234.56)); // $1,234.56
/// print(formatter.formatCompact(1500000)); // 1.5M
/// print(formatter.formatPercent(0.156)); // 15.6%
/// ```
class NumberFormatter {
  /// Current locale code.
  final String locale;

  /// Default currency code.
  final String currencyCode;

  /// Create a formatter.
  NumberFormatter({
    this.locale = 'en_US',
    this.currencyCode = 'USD',
  });

  // ===== Basic Number Formatting =====

  /// Format number with locale-specific separators.
  String format(num number, {int? decimalDigits}) {
    if (decimalDigits != null) {
      return NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: decimalDigits,
      ).format(number);
    }
    return NumberFormat.decimalPattern(locale).format(number);
  }

  /// Format as integer (no decimals).
  String formatInteger(num number) {
    return NumberFormat('#,##0', locale).format(number.round());
  }

  /// Format with specific decimal places.
  String formatDecimal(num number, {int decimalDigits = 2}) {
    return NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    ).format(number);
  }

  // ===== Compact Formatting =====

  /// Format as compact number (e.g., 1.5K, 2.3M).
  String formatCompact(num number) {
    return NumberFormat.compact(locale: locale).format(number);
  }

  /// Format as long compact number (e.g., 1.5 thousand, 2.3 million).
  String formatCompactLong(num number) {
    return NumberFormat.compactLong(locale: locale).format(number);
  }

  /// Format with custom suffixes.
  String formatWithSuffix(num number) {
    if (number.abs() >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(1)}T';
    } else if (number.abs() >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number.abs() >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number.abs() >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    }
    return format(number);
  }

  // ===== Currency Formatting =====

  /// Format as currency.
  String formatCurrency(
    num amount, {
    String? symbol,
    String? code,
    int? decimalDigits,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      name: code ?? currencyCode,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format as simple currency (symbol + amount).
  String formatSimpleCurrency(num amount, {String? symbol}) {
    return NumberFormat.simpleCurrency(
      locale: locale,
      name: symbol,
    ).format(amount);
  }

  /// Format as currency without symbol.
  String formatCurrencyNoSymbol(num amount, {int decimalDigits = 2}) {
    return format(amount, decimalDigits: decimalDigits);
  }

  /// Format as compact currency (e.g., $1.5M).
  String formatCompactCurrency(num amount, {String? symbol}) {
    return NumberFormat.compactCurrency(
      locale: locale,
      symbol: symbol,
    ).format(amount);
  }

  // ===== Percentage Formatting =====

  /// Format as percentage (e.g., 0.156 -> 15.6%).
  String formatPercent(num value, {int decimalDigits = 1}) {
    return NumberFormat.percentPattern(locale).format(value);
  }

  /// Format as percentage with fixed decimals.
  String formatPercentFixed(num value, {int decimalDigits = 1}) {
    final percent = value * 100;
    return '${percent.toStringAsFixed(decimalDigits)}%';
  }

  // ===== Scientific Notation =====

  /// Format as scientific notation.
  String formatScientific(num number) {
    return NumberFormat.scientificPattern(locale).format(number);
  }

  // ===== Ordinal Formatting =====

  /// Format as ordinal (e.g., 1st, 2nd, 3rd).
  String formatOrdinal(int number) {
    if (locale.startsWith('en')) {
      return _formatEnglishOrdinal(number);
    }
    // Default to just the number
    return number.toString();
  }

  String _formatEnglishOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }

    return switch (number % 10) {
      1 => '${number}st',
      2 => '${number}nd',
      3 => '${number}rd',
      _ => '${number}th',
    };
  }

  // ===== File Size Formatting =====

  /// Format bytes as file size (e.g., 1.5 MB).
  String formatFileSize(int bytes, {int decimals = 1}) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

    if (bytes == 0) return '0 B';

    final i = (bytes.abs() > 0)
        ? (log(bytes.abs()) / log(1024)).floor()
        : 0;

    if (i >= suffixes.length) {
      return '${(bytes / pow(1024, suffixes.length - 1)).toStringAsFixed(decimals)} ${suffixes.last}';
    }

    final size = bytes / pow(1024, i);
    return '${size.toStringAsFixed(i == 0 ? 0 : decimals)} ${suffixes[i]}';
  }

  // ===== Parsing =====

  /// Parse number from string.
  num? parse(String text) {
    try {
      return NumberFormat.decimalPattern(locale).parse(text);
    } catch (_) {
      return null;
    }
  }

  /// Parse currency from string.
  num? parseCurrency(String text) {
    try {
      return NumberFormat.currency(locale: locale).parse(text);
    } catch (_) {
      return null;
    }
  }
}

// Math helpers
int log(num x) => x.toString().length - 1;
num pow(num x, num exponent) {
  num result = 1;
  for (var i = 0; i < exponent; i++) {
    result *= x;
  }
  return result;
}

