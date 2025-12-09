/// OTP service for phone authentication.
library;

import 'dart:math';

/// Service for generating and validating OTPs.
class OtpService {
  /// Generate a random 6-digit OTP.
  static String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Validate OTP format.
  static bool isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  /// Check if OTP is expired (based on timestamp).
  static bool isExpired(DateTime sentAt, {int expiryMinutes = 5}) {
    return DateTime.now().difference(sentAt).inMinutes > expiryMinutes;
  }
}

