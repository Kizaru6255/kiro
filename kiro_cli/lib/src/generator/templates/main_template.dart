/// Main.dart template.
library;

/// Generate main.dart content.
String generateMain({
  required String appName,
  required String stateManagement,
  required String primaryColor,
  required bool useFirebase,
}) {
  final imports = StringBuffer();
  final initialization = StringBuffer();
  final wrapper = StringBuffer();
  
  imports.writeln("import 'package:flutter/material.dart';");
  imports.writeln("import 'package:flutter/foundation.dart';");
  
  // State management imports (Riverpod only)
  imports.writeln("import 'package:flutter_riverpod/flutter_riverpod.dart';");
  
  // Firebase import
  if (useFirebase) {
    imports.writeln("import 'package:firebase_core/firebase_core.dart';");
    imports.writeln("import 'firebase_options.dart';");
  }
  
  // App imports
  imports.writeln();
  imports.writeln("import 'core/core.dart';");
  imports.writeln("import 'config/app_config.dart';");
  imports.writeln("import 'config/router.dart';");
  imports.writeln("import 'config/theme.dart';");
  
  // Initialization
  initialization.writeln('  WidgetsFlutterBinding.ensureInitialized();');
  initialization.writeln();
  
  if (useFirebase) {
    initialization.writeln('  // Initialize Firebase (with error handling)');
    initialization.writeln('  try {');
    initialization.writeln('    await Firebase.initializeApp(');
    initialization.writeln('      options: DefaultFirebaseOptions.currentPlatform,');
    initialization.writeln('    );');
    initialization.writeln('  } catch (e) {');
    initialization.writeln('    // Firebase not configured yet - this is expected for placeholder values');
    initialization.writeln('    debugPrint(\'Firebase initialization failed: \$e\');');
    initialization.writeln('    debugPrint(\'Please configure Firebase by running: flutterfire configure\');');
    initialization.writeln('    // Continue without Firebase - app will work but Firebase features won\'t');
    initialization.writeln('  }');
    initialization.writeln();
  }
  
  initialization.writeln('  // Initialize services');
  initialization.writeln('  await AppConfig.initialize();');
  
  // Wrapper (Riverpod ProviderScope)
  wrapper.writeln('  runApp(');
  wrapper.writeln('    const ProviderScope(');
  wrapper.writeln('      child: ${_toPascalCase(appName)}App(),');
  wrapper.writeln('    ),');
  wrapper.writeln('  );');

  return '''
$imports

Future<void> main() async {
$initialization

$wrapper
}

/// Main application widget.
class ${_toPascalCase(appName)}App extends StatelessWidget {
  const ${_toPascalCase(appName)}App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '$appName',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      
      // Routing
      routerConfig: appRouter,
      
      // Localization
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
''';
}

String _toPascalCase(String input) {
  return input
      .split(RegExp(r'[\s_-]+'))
      .map((word) => word.isEmpty 
          ? '' 
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join();
}

/// Generate firebase_options.dart placeholder.
String generateFirebaseOptions({required String appName}) => '''
/// Firebase configuration options.
///
/// NOTE: This is a placeholder file. To generate the actual Firebase options:
///   1. Install FlutterFire CLI: dart pub global activate flutterfire_cli
///   2. Run: flutterfire configure
///   3. This will replace this file with the actual configuration.
library;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'YOUR_MACOS_BUNDLE_ID',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}
''';

