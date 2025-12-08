/// Date and time formatting utilities.
library;

import 'package:intl/intl.dart';

/// Date/time formatter with locale support.
///
/// Example:
/// ```dart
/// final formatter = DateTimeFormatter(locale: 'en_US');
///
/// print(formatter.formatDate(DateTime.now())); // Dec 8, 2024
/// print(formatter.formatTime(DateTime.now())); // 2:30 PM
/// print(formatter.formatRelative(DateTime.now().subtract(Duration(hours: 2)))); // 2 hours ago
/// ```
class DateTimeFormatter {
  /// Current locale code.
  final String locale;

  /// Create a formatter.
  DateTimeFormatter({this.locale = 'en_US'});

  // ===== Date Formatting =====

  /// Format as short date (e.g., 12/8/24).
  String formatDateShort(DateTime date) {
    return DateFormat.yMd(locale).format(date);
  }

  /// Format as medium date (e.g., Dec 8, 2024).
  String formatDate(DateTime date) {
    return DateFormat.yMMMd(locale).format(date);
  }

  /// Format as long date (e.g., December 8, 2024).
  String formatDateLong(DateTime date) {
    return DateFormat.yMMMMd(locale).format(date);
  }

  /// Format as full date with day (e.g., Sunday, December 8, 2024).
  String formatDateFull(DateTime date) {
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }

  /// Format day and month only (e.g., Dec 8).
  String formatDayMonth(DateTime date) {
    return DateFormat.MMMd(locale).format(date);
  }

  /// Format month and year (e.g., December 2024).
  String formatMonthYear(DateTime date) {
    return DateFormat.yMMMM(locale).format(date);
  }

  /// Format weekday (e.g., Sunday).
  String formatWeekday(DateTime date) {
    return DateFormat.EEEE(locale).format(date);
  }

  /// Format short weekday (e.g., Sun).
  String formatWeekdayShort(DateTime date) {
    return DateFormat.E(locale).format(date);
  }

  // ===== Time Formatting =====

  /// Format time (e.g., 2:30 PM).
  String formatTime(DateTime time) {
    return DateFormat.jm(locale).format(time);
  }

  /// Format time with seconds (e.g., 2:30:45 PM).
  String formatTimeWithSeconds(DateTime time) {
    return DateFormat.jms(locale).format(time);
  }

  /// Format 24-hour time (e.g., 14:30).
  String formatTime24h(DateTime time) {
    return DateFormat.Hm(locale).format(time);
  }

  /// Format hour only (e.g., 2 PM).
  String formatHour(DateTime time) {
    return DateFormat.j(locale).format(time);
  }

  // ===== Date + Time =====

  /// Format date and time (e.g., Dec 8, 2024 2:30 PM).
  String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  /// Format short date and time (e.g., 12/8/24 2:30 PM).
  String formatDateTimeShort(DateTime dateTime) {
    return '${formatDateShort(dateTime)} ${formatTime(dateTime)}';
  }

  // ===== Relative Time =====

  /// Format as relative time (e.g., "2 hours ago", "in 3 days").
  String formatRelative(DateTime dateTime, {DateTime? relativeTo}) {
    final now = relativeTo ?? DateTime.now();
    final difference = now.difference(dateTime);
    final isPast = difference.isNegative == false;
    final absDiff = difference.abs();

    if (absDiff.inSeconds < 60) {
      return isPast ? 'just now' : 'in a moment';
    }

    if (absDiff.inMinutes < 60) {
      final minutes = absDiff.inMinutes;
      if (isPast) {
        return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
      } else {
        return minutes == 1 ? 'in 1 minute' : 'in $minutes minutes';
      }
    }

    if (absDiff.inHours < 24) {
      final hours = absDiff.inHours;
      if (isPast) {
        return hours == 1 ? '1 hour ago' : '$hours hours ago';
      } else {
        return hours == 1 ? 'in 1 hour' : 'in $hours hours';
      }
    }

    if (absDiff.inDays < 7) {
      final days = absDiff.inDays;
      if (days == 1) {
        return isPast ? 'yesterday' : 'tomorrow';
      }
      if (isPast) {
        return '$days days ago';
      } else {
        return 'in $days days';
      }
    }

    if (absDiff.inDays < 30) {
      final weeks = (absDiff.inDays / 7).floor();
      if (isPast) {
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else {
        return weeks == 1 ? 'in 1 week' : 'in $weeks weeks';
      }
    }

    if (absDiff.inDays < 365) {
      final months = (absDiff.inDays / 30).floor();
      if (isPast) {
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        return months == 1 ? 'in 1 month' : 'in $months months';
      }
    }

    final years = (absDiff.inDays / 365).floor();
    if (isPast) {
      return years == 1 ? '1 year ago' : '$years years ago';
    } else {
      return years == 1 ? 'in 1 year' : 'in $years years';
    }
  }

  /// Smart format based on distance from now.
  ///
  /// - Today: Time only (2:30 PM)
  /// - Yesterday/Tomorrow: "Yesterday" / "Tomorrow" + time
  /// - This week: Day name + time (Sunday 2:30 PM)
  /// - This year: Date without year (Dec 8)
  /// - Other: Full date
  String formatSmart(DateTime dateTime, {DateTime? relativeTo}) {
    final now = relativeTo ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = date.difference(today).inDays;

    if (difference == 0) {
      // Today - show time only
      return formatTime(dateTime);
    }

    if (difference == -1) {
      return 'Yesterday ${formatTime(dateTime)}';
    }

    if (difference == 1) {
      return 'Tomorrow ${formatTime(dateTime)}';
    }

    if (difference > -7 && difference < 7) {
      // This week
      return '${formatWeekday(dateTime)} ${formatTime(dateTime)}';
    }

    if (dateTime.year == now.year) {
      // This year - no year needed
      return formatDayMonth(dateTime);
    }

    // Full date for older dates
    return formatDate(dateTime);
  }

  // ===== Custom Patterns =====

  /// Format with custom pattern.
  String format(DateTime dateTime, String pattern) {
    return DateFormat(pattern, locale).format(dateTime);
  }

  /// Parse date from string.
  DateTime? parse(String dateString, String pattern) {
    try {
      return DateFormat(pattern, locale).parse(dateString);
    } catch (_) {
      return null;
    }
  }

  // ===== Duration Formatting =====

  /// Format duration (e.g., "2h 30m").
  String formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    }

    if (duration.inMinutes < 60) {
      final seconds = duration.inSeconds % 60;
      if (seconds == 0) {
        return '${duration.inMinutes}m';
      }
      return '${duration.inMinutes}m ${seconds}s';
    }

    if (duration.inHours < 24) {
      final minutes = duration.inMinutes % 60;
      if (minutes == 0) {
        return '${duration.inHours}h';
      }
      return '${duration.inHours}h ${minutes}m';
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    if (hours == 0) {
      return '${days}d';
    }
    return '${days}d ${hours}h';
  }

  /// Format duration as words (e.g., "2 hours 30 minutes").
  String formatDurationWords(Duration duration) {
    final parts = <String>[];

    if (duration.inDays > 0) {
      parts.add('${duration.inDays} ${duration.inDays == 1 ? 'day' : 'days'}');
    }

    final hours = duration.inHours % 24;
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }

    final minutes = duration.inMinutes % 60;
    if (minutes > 0 && duration.inHours < 24) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    final seconds = duration.inSeconds % 60;
    if (seconds > 0 && duration.inMinutes < 60) {
      parts.add('$seconds ${seconds == 1 ? 'second' : 'seconds'}');
    }

    if (parts.isEmpty) {
      return '0 seconds';
    }

    return parts.join(' ');
  }
}

