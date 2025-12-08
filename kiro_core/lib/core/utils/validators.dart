/// Input validators for common data types.
library;

/// Collection of validation functions for common input types.
///
/// All validators return null if valid, or an error message if invalid.
///
/// Example:
/// ```dart
/// final error = Validators.email('invalid-email');
/// if (error != null) {
///   showError(error);
/// }
/// ```
abstract class Validators {
  Validators._();

  // ============================================================
  // Email Validation
  // ============================================================

  /// Validates an email address.
  ///
  /// Returns null if valid, error message if invalid.
  static String? email(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Email';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ============================================================
  // Password Validation
  // ============================================================

  /// Validates a password with configurable requirements.
  ///
  /// Default requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  static String? password(
    String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumber = true,
    bool requireSpecialChar = false,
    String? fieldName,
  }) {
    final name = fieldName ?? 'Password';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    if (value.length < minLength) {
      return '$name must be at least $minLength characters';
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return '$name must contain at least one uppercase letter';
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return '$name must contain at least one lowercase letter';
    }

    if (requireNumber && !value.contains(RegExp(r'[0-9]'))) {
      return '$name must contain at least one number';
    }

    if (requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return '$name must contain at least one special character';
    }

    return null;
  }

  /// Simple password validation (just minimum length).
  static String? simplePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Validates that two passwords match.
  static String? confirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != original) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ============================================================
  // Phone Validation
  // ============================================================

  /// Validates a phone number.
  ///
  /// Supports formats:
  /// - +1234567890
  /// - 1234567890
  /// - (123) 456-7890
  /// - 123-456-7890
  static String? phone(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Phone number';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    // Remove all non-digit characters except +
    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Must be 10-15 digits (with optional + prefix)
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates an Indian phone number.
  static String? indianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    // Indian numbers: 10 digits starting with 6-9
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Please enter a valid 10-digit mobile number';
    }

    return null;
  }

  // ============================================================
  // Name Validation
  // ============================================================

  /// Validates a name field.
  static String? name(
    String? value, {
    int minLength = 2,
    int maxLength = 100,
    String? fieldName,
  }) {
    final name = fieldName ?? 'Name';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < minLength) {
      return '$name must be at least $minLength characters';
    }

    if (trimmed.length > maxLength) {
      return '$name must be less than $maxLength characters';
    }

    // Only allow letters, spaces, hyphens, and apostrophes
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(trimmed)) {
      return '$name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // ============================================================
  // Required Field Validation
  // ============================================================

  /// Validates that a field is not empty.
  static String? required(String? value, {String? fieldName}) {
    final name = fieldName ?? 'This field';

    if (value == null || value.trim().isEmpty) {
      return '$name is required';
    }

    return null;
  }

  /// Validates minimum length.
  static String? minLength(String? value, int min, {String? fieldName}) {
    final name = fieldName ?? 'This field';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    if (value.length < min) {
      return '$name must be at least $min characters';
    }

    return null;
  }

  /// Validates maximum length.
  static String? maxLength(String? value, int max, {String? fieldName}) {
    final name = fieldName ?? 'This field';

    if (value != null && value.length > max) {
      return '$name must be less than $max characters';
    }

    return null;
  }

  // ============================================================
  // Number Validation
  // ============================================================

  /// Validates a numeric value.
  static String? number(String? value, {String? fieldName}) {
    final name = fieldName ?? 'This field';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    if (double.tryParse(value) == null) {
      return '$name must be a valid number';
    }

    return null;
  }

  /// Validates an integer value.
  static String? integer(String? value, {String? fieldName}) {
    final name = fieldName ?? 'This field';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    if (int.tryParse(value) == null) {
      return '$name must be a valid whole number';
    }

    return null;
  }

  /// Validates a positive number.
  static String? positiveNumber(String? value, {String? fieldName}) {
    final name = fieldName ?? 'This field';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$name must be a valid number';
    }

    if (number <= 0) {
      return '$name must be greater than 0';
    }

    return null;
  }

  /// Validates a number within a range.
  static String? numberRange(
    String? value, {
    double? min,
    double? max,
    String? fieldName,
  }) {
    final name = fieldName ?? 'This field';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$name must be a valid number';
    }

    if (min != null && number < min) {
      return '$name must be at least $min';
    }

    if (max != null && number > max) {
      return '$name must be at most $max';
    }

    return null;
  }

  // ============================================================
  // URL Validation
  // ============================================================

  /// Validates a URL.
  static String? url(String? value, {String? fieldName}) {
    final name = fieldName ?? 'URL';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || (!uri.hasAuthority && !uri.isAbsolute)) {
      return 'Please enter a valid URL';
    }

    if (!['http', 'https'].contains(uri.scheme)) {
      return 'URL must start with http:// or https://';
    }

    return null;
  }

  // ============================================================
  // Date Validation
  // ============================================================

  /// Validates a date string.
  static String? date(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Date';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    if (DateTime.tryParse(value) == null) {
      return 'Please enter a valid date';
    }

    return null;
  }

  /// Validates that a date is in the future.
  static String? futureDate(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Date';

    final error = date(value, fieldName: fieldName);
    if (error != null) return error;

    final dateTime = DateTime.parse(value!);
    if (dateTime.isBefore(DateTime.now())) {
      return '$name must be in the future';
    }

    return null;
  }

  /// Validates that a date is in the past.
  static String? pastDate(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Date';

    final error = date(value, fieldName: fieldName);
    if (error != null) return error;

    final dateTime = DateTime.parse(value!);
    if (dateTime.isAfter(DateTime.now())) {
      return '$name must be in the past';
    }

    return null;
  }

  // ============================================================
  // Credit Card Validation
  // ============================================================

  /// Validates a credit card number using Luhn algorithm.
  static String? creditCard(String? value, {String? fieldName}) {
    final name = fieldName ?? 'Card number';

    if (value == null || value.isEmpty) {
      return '$name is required';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Must be 13-19 digits
    if (!RegExp(r'^\d{13,19}$').hasMatch(cleaned)) {
      return 'Please enter a valid card number';
    }

    // Luhn algorithm check
    if (!_luhnCheck(cleaned)) {
      return 'Please enter a valid card number';
    }

    return null;
  }

  /// Validates card expiry (MM/YY or MM/YYYY).
  static String? cardExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    final match = RegExp(r'^(\d{2})/(\d{2}|\d{4})$').firstMatch(value);
    if (match == null) {
      return 'Use format MM/YY';
    }

    final month = int.parse(match.group(1)!);
    var year = int.parse(match.group(2)!);

    if (year < 100) {
      year += 2000;
    }

    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    final now = DateTime.now();
    final expiry = DateTime(year, month + 1, 0); // Last day of month

    if (expiry.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  /// Validates CVV.
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  // ============================================================
  // OTP Validation
  // ============================================================

  /// Validates an OTP code.
  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (!RegExp('^\\d{$length}\$').hasMatch(value)) {
      return 'OTP must be $length digits';
    }

    return null;
  }

  // ============================================================
  // Pin Validation
  // ============================================================

  /// Validates a PIN.
  static String? pin(String? value, {int length = 4}) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }

    if (!RegExp('^\\d{$length}\$').hasMatch(value)) {
      return 'PIN must be $length digits';
    }

    return null;
  }

  // ============================================================
  // Helpers
  // ============================================================

  /// Luhn algorithm for credit card validation.
  static bool _luhnCheck(String number) {
    var sum = 0;
    var alternate = false;

    for (var i = number.length - 1; i >= 0; i--) {
      var digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // ============================================================
  // Compose Validators
  // ============================================================

  /// Compose multiple validators into one.
  ///
  /// Returns the first error, or null if all pass.
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}

