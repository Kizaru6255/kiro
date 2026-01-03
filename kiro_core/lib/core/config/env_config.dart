/// Environment configuration loader.
library;

import 'dart:io';

/// Environment configuration service.
class EnvConfig {
  EnvConfig._();

  static final Map<String, String> _env = {};
  static bool _initialized = false;

  /// Initialize environment configuration from .env file.
  static Future<void> initialize({String? envFile}) async {
    if (_initialized) return;

    final file = File(envFile ?? '.env');
    if (await file.exists()) {
      final content = await file.readAsString();
      for (final line in content.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

        final index = trimmed.indexOf('=');
        if (index > 0) {
          final key = trimmed.substring(0, index).trim();
          var value = trimmed.substring(index + 1).trim();
          
          // Remove quotes if present
          if (value.startsWith('"') && value.endsWith('"')) {
            value = value.substring(1, value.length - 1);
          } else if (value.startsWith("'") && value.endsWith("'")) {
            value = value.substring(1, value.length - 1);
          }
          
          _env[key] = value;
        }
      }
    }

    // Also load from environment variables (override .env)
    Platform.environment.forEach((key, value) {
      _env[key] = value;
    });

    _initialized = true;
  }

  /// Get environment variable value.
  static String? get(String key) => _env[key];

  /// Get environment variable with default value.
  static String getOrDefault(String key, String defaultValue) =>
      _env[key] ?? defaultValue;

  /// Get environment variable as integer.
  static int? getInt(String key) {
    final value = _env[key];
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Get environment variable as boolean.
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = _env[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true' || value == '1';
  }

  /// Check if environment variable exists.
  static bool has(String key) => _env.containsKey(key);

  /// Get all environment variables.
  static Map<String, String> getAll() => Map.unmodifiable(_env);
}
