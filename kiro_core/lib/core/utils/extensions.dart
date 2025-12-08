/// Extension methods for common Dart types.
library;

// ============================================================
// String Extensions
// ============================================================

/// Extension methods on [String].
extension StringExtension on String {
  /// Check if string is a valid email.
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number.
  bool get isPhone {
    final cleaned = replaceAll(RegExp(r'[^\d+]'), '');
    return RegExp(r'^\+?\d{10,15}$').hasMatch(cleaned);
  }

  /// Check if string is a valid URL.
  bool get isUrl {
    final uri = Uri.tryParse(this);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// Check if string is numeric.
  bool get isNumeric => double.tryParse(this) != null;

  /// Check if string is alphanumeric.
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Check if string contains only letters.
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert to camelCase.
  String get toCamelCase {
    if (isEmpty) return this;
    final words = _splitWords();
    if (words.isEmpty) return this;
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join();
  }

  /// Convert to PascalCase.
  String get toPascalCase {
    if (isEmpty) return this;
    return _splitWords().map((w) => w.capitalize).join();
  }

  /// Convert to snake_case.
  String get toSnakeCase {
    if (isEmpty) return this;
    return _splitWords().map((w) => w.toLowerCase()).join('_');
  }

  /// Convert to kebab-case.
  String get toKebabCase {
    if (isEmpty) return this;
    return _splitWords().map((w) => w.toLowerCase()).join('-');
  }

  /// Convert to CONSTANT_CASE.
  String get toConstantCase {
    if (isEmpty) return this;
    return _splitWords().map((w) => w.toUpperCase()).join('_');
  }

  /// Split string into words (handles camelCase, snake_case, etc.).
  List<String> _splitWords() {
    // Handle camelCase and PascalCase
    var result = replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    // Handle consecutive capitals followed by lowercase
    result = result.replaceAllMapped(
      RegExp(r'([A-Z]+)([A-Z][a-z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    // Split on spaces, underscores, and hyphens
    return result.split(RegExp(r'[\s_\-]+')).where((w) => w.isNotEmpty).toList();
  }

  /// Truncate string to max length with ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Remove all whitespace.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Collapse multiple whitespace to single space.
  String get collapseWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Reverse the string.
  String get reversed => split('').reversed.join();

  /// Check if string is blank (empty or only whitespace).
  bool get isBlank => trim().isEmpty;

  /// Check if string is not blank.
  bool get isNotBlank => !isBlank;

  /// Convert to int or null.
  int? toIntOrNull() => int.tryParse(this);

  /// Convert to double or null.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Convert to DateTime or null.
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);

  /// Get initials (e.g., "John Doe" -> "JD").
  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
    }
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  /// Mask string (e.g., for phone numbers, emails).
  String mask({int visibleStart = 2, int visibleEnd = 2, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;
    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final masked = maskChar * (length - visibleStart - visibleEnd);
    return '$start$masked$end';
  }

  /// Mask email (e.g., "john@example.com" -> "jo***@example.com").
  String get maskedEmail {
    final parts = split('@');
    if (parts.length != 2) return this;
    final local = parts[0];
    final domain = parts[1];
    final maskedLocal = local.mask(visibleStart: 2, visibleEnd: 0);
    return '$maskedLocal@$domain';
  }

  /// Mask phone (e.g., "+1234567890" -> "+12*****890").
  String get maskedPhone {
    if (length < 6) return this;
    return mask(visibleStart: 3, visibleEnd: 3);
  }
}

/// Extension methods on nullable [String].
extension NullableStringExtension on String? {
  /// Check if null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Check if null or blank.
  bool get isNullOrBlank => this == null || this!.isBlank;

  /// Check if not null and not blank.
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Get value or default.
  String orEmpty() => this ?? '';

  /// Get value or default.
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}

// ============================================================
// DateTime Extensions
// ============================================================

/// Extension methods on [DateTime].
extension DateTimeExtension on DateTime {
  /// Check if date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is in this week.
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  /// Check if date is in this month.
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is in this year.
  bool get isThisYear => year == DateTime.now().year;

  /// Get start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of month.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get start of year.
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Get end of year.
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Add days.
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days.
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add months.
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }
    final maxDay = DateTime(newYear, newMonth + 1, 0).day;
    return DateTime(newYear, newMonth, day > maxDay ? maxDay : day);
  }

  /// Get age in years.
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Format as relative time (e.g., "2 hours ago").
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return 'in the future';
    }

    if (difference.inSeconds < 60) {
      return 'just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }

    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }

  /// Check if same day as another date.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Days between two dates.
  int daysBetween(DateTime other) {
    return startOfDay.difference(other.startOfDay).inDays.abs();
  }
}

// ============================================================
// Iterable Extensions
// ============================================================

/// Extension methods on [Iterable].
extension IterableExtension<T> on Iterable<T> {
  /// Get first element or null.
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null.
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null.
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return elementAt(index);
  }

  /// Find first element matching predicate or null.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Find last element matching predicate or null.
  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (final element in this) {
      if (test(element)) result = element;
    }
    return result;
  }

  /// Check if all elements match predicate.
  bool all(bool Function(T) test) {
    for (final element in this) {
      if (!test(element)) return false;
    }
    return true;
  }

  /// Check if no elements match predicate.
  bool none(bool Function(T) test) => !any(test);

  /// Group elements by a key.
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final result = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      (result[key] ??= []).add(element);
    }
    return result;
  }

  /// Count elements matching predicate.
  int count(bool Function(T) test) {
    var count = 0;
    for (final element in this) {
      if (test(element)) count++;
    }
    return count;
  }

  /// Get distinct elements.
  List<T> distinct() => toSet().toList();

  /// Get distinct elements by key.
  List<T> distinctBy<K>(K Function(T) keyFunction) {
    final seen = <K>{};
    final result = <T>[];
    for (final element in this) {
      final key = keyFunction(element);
      if (seen.add(key)) {
        result.add(element);
      }
    }
    return result;
  }

  /// Separate with a separator element.
  Iterable<T> separatedBy(T separator) sync* {
    var first = true;
    for (final element in this) {
      if (!first) yield separator;
      first = false;
      yield element;
    }
  }

  /// Map with index.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) transform) sync* {
    var index = 0;
    for (final element in this) {
      yield transform(index++, element);
    }
  }

  /// ForEach with index.
  void forEachIndexed(void Function(int index, T element) action) {
    var index = 0;
    for (final element in this) {
      action(index++, element);
    }
  }

  /// Chunk into lists of specified size.
  Iterable<List<T>> chunked(int size) sync* {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final chunk = <T>[iterator.current];
      for (var i = 1; i < size && iterator.moveNext(); i++) {
        chunk.add(iterator.current);
      }
      yield chunk;
    }
  }

  /// Sort by comparable property.
  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keyFunction) {
    final result = toList();
    result.sort((a, b) => keyFunction(a).compareTo(keyFunction(b)));
    return result;
  }

  /// Sort by comparable property (descending).
  List<T> sortedByDescending<K extends Comparable<K>>(K Function(T) keyFunction) {
    final result = toList();
    result.sort((a, b) => keyFunction(b).compareTo(keyFunction(a)));
    return result;
  }
}

// ============================================================
// Map Extensions
// ============================================================

/// Extension methods on [Map].
extension MapExtension<K, V> on Map<K, V> {
  /// Get value or null.
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  /// Get value or default.
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Get value or compute default.
  V getOrPut(K key, V Function() defaultValue) {
    if (containsKey(key)) return this[key] as V;
    final value = defaultValue();
    this[key] = value;
    return value;
  }

  /// Filter entries by predicate.
  Map<K, V> where(bool Function(K key, V value) test) {
    return Map.fromEntries(entries.where((e) => test(e.key, e.value)));
  }

  /// Map values.
  Map<K, R> mapValues<R>(R Function(V value) transform) {
    return map((key, value) => MapEntry(key, transform(value)));
  }

  /// Map keys.
  Map<R, V> mapKeys<R>(R Function(K key) transform) {
    return map((key, value) => MapEntry(transform(key), value));
  }

  /// Filter out null values.
  Map<K, V> whereValueNotNull() {
    return where((_, value) => value != null);
  }
}

// ============================================================
// Num Extensions
// ============================================================

/// Extension methods on [num].
extension NumExtension on num {
  /// Check if between min and max (inclusive).
  bool between(num min, num max) => this >= min && this <= max;

  /// Clamp between min and max.
  num clampTo(num min, num max) => this < min
      ? min
      : this > max
          ? max
          : this;

  /// Get duration in milliseconds.
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Get duration in seconds.
  Duration get seconds => Duration(seconds: toInt());

  /// Get duration in minutes.
  Duration get minutes => Duration(minutes: toInt());

  /// Get duration in hours.
  Duration get hours => Duration(hours: toInt());

  /// Get duration in days.
  Duration get days => Duration(days: toInt());
}

/// Extension methods on [int].
extension IntExtension on int {
  /// Convert to ordinal string (1st, 2nd, 3rd, etc.).
  String get ordinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Repeat an action n times.
  void times(void Function(int i) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }
}

/// Extension methods on [double].
extension DoubleExtension on double {
  /// Round to n decimal places.
  double roundTo(int decimals) {
    final factor = 10.0 * decimals;
    return (this * factor).round() / factor;
  }
}

// ============================================================
// Duration Extensions
// ============================================================

/// Extension methods on [Duration].
extension DurationExtension on Duration {
  /// Format as HH:MM:SS.
  String get formatted {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format as MM:SS (for shorter durations).
  String get shortFormatted {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Get human-readable string.
  String get humanReadable {
    if (inDays > 0) {
      return '$inDays ${inDays == 1 ? 'day' : 'days'}';
    }
    if (inHours > 0) {
      return '$inHours ${inHours == 1 ? 'hour' : 'hours'}';
    }
    if (inMinutes > 0) {
      return '$inMinutes ${inMinutes == 1 ? 'minute' : 'minutes'}';
    }
    return '$inSeconds ${inSeconds == 1 ? 'second' : 'seconds'}';
  }
}

// ============================================================
// Future Extensions
// ============================================================

/// Extension methods on [Future].
extension FutureExtension<T> on Future<T> {
  /// Timeout with default value.
  Future<T> timeoutWith(
    Duration duration, {
    required T Function() onTimeout,
  }) {
    return timeout(duration, onTimeout: onTimeout);
  }

  /// Ignore errors and return null.
  Future<T?> ignoreErrors() async {
    try {
      return await this;
    } catch (_) {
      return null;
    }
  }
}

