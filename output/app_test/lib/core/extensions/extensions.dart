/// Useful extensions.
library;

import 'package:flutter/material.dart';

/// String extensions.
extension StringX on String {
  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Check if string is valid email.
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  /// Check if string is valid phone.
  bool get isPhone {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(replaceAll(RegExp(r'[\s-]'), ''));
  }
}

/// Context extensions.
extension ContextX on BuildContext {
  /// Get theme.
  ThemeData get theme => Theme.of(this);
  
  /// Get text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Get color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Get screen size.
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Get screen width.
  double get screenWidth => screenSize.width;
  
  /// Get screen height.
  double get screenHeight => screenSize.height;
  
  /// Show snackbar.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}
