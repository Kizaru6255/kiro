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
  String? kiroCorePath, // Deprecated - kept for compatibility
}) {
  final dependencies = StringBuffer();
  final addedDeps = <String>{};
  
  // Helper to add dependency only if not already added
  void addDep(String name, String version) {
    if (!addedDeps.contains(name)) {
      dependencies.writeln('  $name: $version');
      addedDeps.add(name);
    }
  }
  
  // Core dependencies
  dependencies.writeln('  # Core');
  dependencies.writeln('  flutter:');
  dependencies.writeln('    sdk: flutter');
  dependencies.writeln();
  
  // State management
  dependencies.writeln('  # State Management');
  switch (stateManagement) {
    case 'riverpod':
      addDep('flutter_riverpod', '^2.4.9');
      addDep('riverpod_annotation', '^2.3.3');
      break;
    case 'bloc':
      addDep('flutter_bloc', '^8.1.3');
      addDep('bloc', '^8.1.2');
      addDep('equatable', '^2.0.5');
      break;
    case 'provider':
      addDep('provider', '^6.1.1');
      break;
  }
  dependencies.writeln();
  
  // Routing
  dependencies.writeln('  # Routing');
  addDep('go_router', '^14.2.0');
  dependencies.writeln();
  
  // Network & Storage dependencies (replacing kiro_core)
  dependencies.writeln('  # Network & Storage');
  addDep('dio', '^5.4.0');
  addDep('flutter_secure_storage', '^9.0.0');
  addDep('shared_preferences', '^2.2.2');
  dependencies.writeln();
  
  // Firebase (if enabled)
  if (useFirebase) {
    dependencies.writeln('  # Firebase');
    addDep('firebase_core', '^2.24.2');
  }
  
  // Module-specific dependencies
  if (modules.contains('auth')) {
    dependencies.writeln();
    dependencies.writeln('  # Auth Module');
    if (useFirebase) {
      addDep('firebase_auth', '^4.16.0');
    }
    addDep('google_sign_in', '^6.2.1');
  }
  
  if (modules.contains('chat')) {
    dependencies.writeln();
    dependencies.writeln('  # Chat Module');
    if (useFirebase) {
      addDep('cloud_firestore', '^4.13.6');
      addDep('firebase_storage', '^11.5.6');
    }
    addDep('cached_network_image', '^3.3.0');
  }
  
  if (modules.contains('notifications')) {
    dependencies.writeln();
    dependencies.writeln('  # Notifications Module');
    if (useFirebase) {
      addDep('firebase_messaging', '^14.7.9');
    }
    addDep('flutter_local_notifications', '^17.0.0');
  }
  
  if (modules.contains('payments')) {
    dependencies.writeln();
    dependencies.writeln('  # Payments Module');
    dependencies.writeln('  # razorpay_flutter: ^1.3.6  # Uncomment and configure');
  }
  
  if (modules.contains('tracking')) {
    dependencies.writeln();
    dependencies.writeln('  # Tracking/Maps Module');
    addDep('google_maps_flutter', '^2.5.3');
    addDep('geolocator', '^11.0.0');
  }
  
  if (modules.contains('booking')) {
    dependencies.writeln();
    dependencies.writeln('  # Booking Module');
    addDep('table_calendar', '^3.0.9');
  }
  
  if (modules.contains('profile')) {
    dependencies.writeln();
    dependencies.writeln('  # Profile Module');
    addDep('image_picker', '^1.0.5');
    addDep('cached_network_image', '^3.3.0'); // Will be skipped if already added by chat module
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

