import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/core.dart';
import 'config/app_config.dart';
import 'config/router.dart';
import 'config/theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await AppConfig.initialize();


  runApp(
    const ProviderScope(
      child: AppTestApp(),
    ),
  );

}

/// Main application widget.
class AppTestApp extends StatelessWidget {
  const AppTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'app_test',
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
