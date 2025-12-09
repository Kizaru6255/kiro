/// Pubspec.yaml template.
library;

/// Generate pubspec.yaml content.
String generatePubspec({
  required String appName,
  required String packageName,
  required String description,
  required String stateManagement,
  required List<String> modules,
  required bool useFirebase,
  String? kiroCorePath,
}) {
  final dependencies = StringBuffer();
  
  // Core dependencies
  dependencies.writeln('  # Core');
  dependencies.writeln('  flutter:');
  dependencies.writeln('    sdk: flutter');
  dependencies.writeln();
  
  // State management
  dependencies.writeln('  # State Management');
  switch (stateManagement) {
    case 'riverpod':
      dependencies.writeln('  flutter_riverpod: ^2.4.9');
      dependencies.writeln('  riverpod_annotation: ^2.3.3');
      break;
    case 'bloc':
      dependencies.writeln('  flutter_bloc: ^8.1.3');
      dependencies.writeln('  bloc: ^8.1.2');
      dependencies.writeln('  equatable: ^2.0.5');
      break;
    case 'provider':
      dependencies.writeln('  provider: ^6.1.1');
      break;
  }
  dependencies.writeln();
  
  // Routing
  dependencies.writeln('  # Routing');
  dependencies.writeln('  go_router: ^14.2.0');
  dependencies.writeln();
  
  // Networking
  dependencies.writeln('  # Networking');
  dependencies.writeln('  dio: ^5.4.0');
  dependencies.writeln();
  
  // Storage
  dependencies.writeln('  # Storage');
  dependencies.writeln('  shared_preferences: ^2.2.2');
  dependencies.writeln('  flutter_secure_storage: ^9.0.0');
  dependencies.writeln();
  
  // Utils
  dependencies.writeln('  # Utilities');
  dependencies.writeln('  intl: ^0.19.0');
  dependencies.writeln('  logger: ^2.0.2+1');
  dependencies.writeln('  connectivity_plus: ^6.0.3');
  dependencies.writeln();
  
  // Kiro Core (required for modules)
  if (modules.isNotEmpty && kiroCorePath != null) {
    dependencies.writeln('  # Kiro Core');
    dependencies.writeln('  kiro_core:');
    dependencies.writeln('    path: $kiroCorePath');
    dependencies.writeln();
  }
  
  // Firebase (if enabled)
  if (useFirebase) {
    dependencies.writeln('  # Firebase');
    dependencies.writeln('  firebase_core: ^2.24.2');
  }
  
  // Module-specific dependencies
  if (modules.contains('auth')) {
    dependencies.writeln();
    dependencies.writeln('  # Auth Module');
    if (useFirebase) {
      dependencies.writeln('  firebase_auth: ^4.16.0');
    }
    dependencies.writeln('  google_sign_in: ^6.2.1');
  }
  
  if (modules.contains('chat')) {
    dependencies.writeln();
    dependencies.writeln('  # Chat Module');
    if (useFirebase) {
      dependencies.writeln('  cloud_firestore: ^4.13.6');
      dependencies.writeln('  firebase_storage: ^11.5.6');
    }
    dependencies.writeln('  cached_network_image: ^3.3.0');
  }
  
  if (modules.contains('notifications')) {
    dependencies.writeln();
    dependencies.writeln('  # Notifications Module');
    if (useFirebase) {
      dependencies.writeln('  firebase_messaging: ^14.7.9');
    }
    dependencies.writeln('  flutter_local_notifications: ^17.0.0');
  }
  
  if (modules.contains('payments')) {
    dependencies.writeln();
    dependencies.writeln('  # Payments Module');
    dependencies.writeln('  # razorpay_flutter: ^1.3.6  # Uncomment and configure');
  }
  
  if (modules.contains('tracking')) {
    dependencies.writeln();
    dependencies.writeln('  # Tracking/Maps Module');
    dependencies.writeln('  google_maps_flutter: ^2.5.3');
    dependencies.writeln('  geolocator: ^11.0.0');
  }
  
  if (modules.contains('booking')) {
    dependencies.writeln();
    dependencies.writeln('  # Booking Module');
    dependencies.writeln('  table_calendar: ^3.0.9');
  }
  
  if (modules.contains('profile')) {
    dependencies.writeln();
    dependencies.writeln('  # Profile Module');
    dependencies.writeln('  image_picker: ^1.0.5');
    dependencies.writeln('  cached_network_image: ^3.3.0');
  }

  // Dev dependencies
  final devDependencies = StringBuffer();
  devDependencies.writeln('  flutter_test:');
  devDependencies.writeln('    sdk: flutter');
  devDependencies.writeln();
  devDependencies.writeln('  flutter_lints: ^3.0.1');
  devDependencies.writeln('  build_runner: ^2.4.8');
  
  switch (stateManagement) {
    case 'riverpod':
      devDependencies.writeln('  riverpod_generator: ^2.3.9');
      break;
  }
  
  devDependencies.writeln('  freezed: ^2.4.6');
  devDependencies.writeln('  freezed_annotation: ^2.4.1');
  devDependencies.writeln('  json_serializable: ^6.7.1');
  devDependencies.writeln('  json_annotation: ^4.8.1');

  // Extract and validate package name from full package name (e.g., "com.example.new" -> "new_app")
  // The packageName already has the validated version from AppConfig._toValidPackageName
  final packageNameOnly = packageName.contains('.') 
      ? packageName.split('.').last 
      : packageName;
  
  return '''
name: $packageNameOnly
description: $description
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
$dependencies

dev_dependencies:
$devDependencies

flutter:
  uses-material-design: true
  
  # assets:
  #   - assets/images/
  #   - assets/icons/
  
  # fonts:
  #   - family: CustomFont
  #     fonts:
  #       - asset: assets/fonts/CustomFont-Regular.ttf
''';
}

