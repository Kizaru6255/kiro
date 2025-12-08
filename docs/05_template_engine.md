# Kiro Template Engine — Technical Specification

> **Version:** 1.0.0  
> **Last Updated:** December 2024

---

## Table of Contents

1. [Template Engine Overview](#1-template-engine-overview)
2. [Placeholder System](#2-placeholder-system)
3. [Template Structure](#3-template-structure)
4. [File Processing](#4-file-processing)
5. [Conditional Content](#5-conditional-content)
6. [Loop Constructs](#6-loop-constructs)
7. [Template Validation](#7-template-validation)
8. [Performance Considerations](#8-performance-considerations)

---

## 1. Template Engine Overview

### 1.1 Purpose

The Kiro Template Engine is responsible for:

- **Placeholder Replacement**: Converting template variables to actual values
- **Conditional Rendering**: Including/excluding content based on configuration
- **File Generation**: Creating new files from templates
- **Asset Management**: Copying and organizing project assets

### 1.2 Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TEMPLATE ENGINE ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌────────────────┐                                                        │
│   │   AppConfig    │                                                        │
│   │   (User Input) │                                                        │
│   └───────┬────────┘                                                        │
│           │                                                                  │
│           ▼                                                                  │
│   ┌────────────────┐     ┌────────────────┐     ┌────────────────┐         │
│   │   Template     │────▶│   Placeholder  │────▶│   Conditional  │         │
│   │   Loader       │     │   Replacer     │     │   Processor    │         │
│   └────────────────┘     └────────────────┘     └───────┬────────┘         │
│                                                          │                   │
│                                                          ▼                   │
│   ┌────────────────┐     ┌────────────────┐     ┌────────────────┐         │
│   │   File         │◀────│   Loop         │◀────│   Output       │         │
│   │   Writer       │     │   Processor    │     │   Generator    │         │
│   └────────────────┘     └────────────────┘     └────────────────┘         │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Processing Pipeline

```
1. Load Template Files
        ↓
2. Parse Placeholders
        ↓
3. Validate All Placeholders Have Values
        ↓
4. Process Conditionals ({{#if}}, {{#unless}})
        ↓
5. Process Loops ({{#each}})
        ↓
6. Replace Placeholders ({{placeholder}})
        ↓
7. Format Output (dartfmt, etc.)
        ↓
8. Write Files
```

---

## 2. Placeholder System

### 2.1 Placeholder Syntax

Kiro uses a Mustache-like syntax with some extensions:

```
{{PLACEHOLDER_NAME}}           # Simple replacement
{{placeholder_name}}           # Case preserved
{{PLACEHOLDER_NAME:default}}   # With default value
{{PLACEHOLDER_NAME|transform}} # With transformation
```

### 2.2 Placeholder Registry

```dart
/// placeholder_registry.dart
///
/// Central registry of all supported placeholders.

class PlaceholderRegistry {
  static final Map<String, PlaceholderDefinition> _registry = {
    // App Identity
    'APP_NAME': PlaceholderDefinition(
      name: 'APP_NAME',
      description: 'Display name of the application',
      required: true,
      example: 'My Awesome App',
      transforms: [Transform.titleCase, Transform.snakeCase, Transform.camelCase],
    ),
    'PACKAGE_NAME': PlaceholderDefinition(
      name: 'PACKAGE_NAME',
      description: 'Bundle identifier (e.g., com.example.app)',
      required: true,
      example: 'com.kiro.myapp',
      validator: PackageNameValidator(),
    ),
    'APP_DESCRIPTION': PlaceholderDefinition(
      name: 'APP_DESCRIPTION',
      description: 'Short description of the app',
      required: false,
      defaultValue: 'A Kiro-powered Flutter application',
    ),
    
    // Theme
    'PRIMARY_COLOR': PlaceholderDefinition(
      name: 'PRIMARY_COLOR',
      description: 'Primary brand color (hex)',
      required: true,
      example: '#6366F1',
      validator: ColorValidator(),
      transforms: [Transform.hexToColor, Transform.hexToInt],
    ),
    'SECONDARY_COLOR': PlaceholderDefinition(
      name: 'SECONDARY_COLOR',
      description: 'Secondary brand color (hex)',
      required: true,
      example: '#EC4899',
      validator: ColorValidator(),
    ),
    'SURFACE_COLOR': PlaceholderDefinition(
      name: 'SURFACE_COLOR',
      description: 'Surface/background color',
      required: false,
      defaultValue: '#FFFFFF',
    ),
    
    // Localization
    'DEFAULT_LOCALE': PlaceholderDefinition(
      name: 'DEFAULT_LOCALE',
      description: 'Default language code',
      required: true,
      example: 'en',
      defaultValue: 'en',
    ),
    'SUPPORTED_LOCALES': PlaceholderDefinition(
      name: 'SUPPORTED_LOCALES',
      description: 'List of supported language codes',
      required: true,
      example: "['en', 'hi', 'es']",
      isList: true,
    ),
    
    // Configuration
    'STATE_MANAGEMENT': PlaceholderDefinition(
      name: 'STATE_MANAGEMENT',
      description: 'State management solution',
      required: true,
      allowedValues: ['riverpod', 'bloc', 'provider'],
      defaultValue: 'riverpod',
    ),
    
    // Platform
    'MIN_SDK_VERSION': PlaceholderDefinition(
      name: 'MIN_SDK_VERSION',
      description: 'Minimum Android SDK version',
      required: false,
      defaultValue: '21',
    ),
    'IOS_DEPLOYMENT_TARGET': PlaceholderDefinition(
      name: 'IOS_DEPLOYMENT_TARGET',
      description: 'Minimum iOS version',
      required: false,
      defaultValue: '12.0',
    ),
    
    // Computed
    'APP_NAME_SNAKE': PlaceholderDefinition(
      name: 'APP_NAME_SNAKE',
      description: 'App name in snake_case',
      computed: true,
      computeFrom: 'APP_NAME',
      transform: Transform.snakeCase,
    ),
    'APP_NAME_CAMEL': PlaceholderDefinition(
      name: 'APP_NAME_CAMEL',
      description: 'App name in camelCase',
      computed: true,
      computeFrom: 'APP_NAME',
      transform: Transform.camelCase,
    ),
    'APP_NAME_PASCAL': PlaceholderDefinition(
      name: 'APP_NAME_PASCAL',
      description: 'App name in PascalCase',
      computed: true,
      computeFrom: 'APP_NAME',
      transform: Transform.pascalCase,
    ),
    
    // Module flags
    'MODULE_AUTH_ENABLED': PlaceholderDefinition(
      name: 'MODULE_AUTH_ENABLED',
      description: 'Whether auth module is enabled',
      isBoolean: true,
      defaultValue: 'false',
    ),
    'MODULE_WALLET_ENABLED': PlaceholderDefinition(
      name: 'MODULE_WALLET_ENABLED',
      description: 'Whether wallet module is enabled',
      isBoolean: true,
      defaultValue: 'false',
    ),
    'MODULE_CHAT_ENABLED': PlaceholderDefinition(
      name: 'MODULE_CHAT_ENABLED',
      description: 'Whether chat module is enabled',
      isBoolean: true,
      defaultValue: 'false',
    ),
    // ... more module flags
  };
  
  static PlaceholderDefinition? get(String name) => _registry[name];
  
  static List<PlaceholderDefinition> get all => _registry.values.toList();
  
  static List<PlaceholderDefinition> get required => 
    _registry.values.where((p) => p.required).toList();
  
  static bool isValid(String name) => _registry.containsKey(name);
}

class PlaceholderDefinition {
  final String name;
  final String description;
  final bool required;
  final String? example;
  final String? defaultValue;
  final List<String>? allowedValues;
  final Validator? validator;
  final List<Transform>? transforms;
  final bool isList;
  final bool isBoolean;
  final bool computed;
  final String? computeFrom;
  final Transform? transform;
  
  const PlaceholderDefinition({
    required this.name,
    required this.description,
    this.required = false,
    this.example,
    this.defaultValue,
    this.allowedValues,
    this.validator,
    this.transforms,
    this.isList = false,
    this.isBoolean = false,
    this.computed = false,
    this.computeFrom,
    this.transform,
  });
}

enum Transform {
  snakeCase,
  camelCase,
  pascalCase,
  titleCase,
  upperCase,
  lowerCase,
  kebabCase,
  hexToColor,
  hexToInt,
}
```

### 2.3 Placeholder Replacer

```dart
/// placeholder_replacer.dart
///
/// Handles placeholder detection and replacement.

class PlaceholderReplacer {
  final Map<String, dynamic> _values;
  final PlaceholderRegistry _registry;
  
  // Regex patterns
  static final RegExp _simplePattern = RegExp(r'\{\{(\w+)\}\}');
  static final RegExp _defaultPattern = RegExp(r'\{\{(\w+):([^}]*)\}\}');
  static final RegExp _transformPattern = RegExp(r'\{\{(\w+)\|(\w+)\}\}');
  
  PlaceholderReplacer({
    required Map<String, dynamic> values,
    PlaceholderRegistry? registry,
  }) : _values = values,
       _registry = registry ?? PlaceholderRegistry();
  
  /// Replace all placeholders in content
  String process(String content) {
    var result = content;
    
    // Process transforms first: {{NAME|transform}}
    result = _processTransforms(result);
    
    // Process with defaults: {{NAME:default}}
    result = _processDefaults(result);
    
    // Process simple: {{NAME}}
    result = _processSimple(result);
    
    return result;
  }
  
  String _processSimple(String content) {
    return content.replaceAllMapped(_simplePattern, (match) {
      final name = match.group(1)!;
      return _getValue(name);
    });
  }
  
  String _processDefaults(String content) {
    return content.replaceAllMapped(_defaultPattern, (match) {
      final name = match.group(1)!;
      final defaultValue = match.group(2)!;
      
      final value = _values[name];
      if (value == null || (value is String && value.isEmpty)) {
        return defaultValue;
      }
      return _formatValue(value);
    });
  }
  
  String _processTransforms(String content) {
    return content.replaceAllMapped(_transformPattern, (match) {
      final name = match.group(1)!;
      final transform = match.group(2)!;
      
      final value = _getValue(name);
      return _applyTransform(value, transform);
    });
  }
  
  String _getValue(String name) {
    // Check if it's a computed placeholder
    final definition = PlaceholderRegistry.get(name);
    if (definition?.computed == true && definition?.computeFrom != null) {
      final sourceValue = _values[definition!.computeFrom];
      if (sourceValue != null && definition.transform != null) {
        return _applyTransformEnum(sourceValue.toString(), definition.transform!);
      }
    }
    
    final value = _values[name];
    if (value == null) {
      // Check for default in registry
      final defaultValue = definition?.defaultValue;
      if (defaultValue != null) return defaultValue;
      
      // Return placeholder unchanged (or throw based on config)
      return '{{$name}}';
    }
    
    return _formatValue(value);
  }
  
  String _formatValue(dynamic value) {
    if (value is List) {
      return value.map((v) => "'$v'").join(', ');
    }
    if (value is bool) {
      return value.toString();
    }
    return value.toString();
  }
  
  String _applyTransform(String value, String transform) {
    return switch (transform.toLowerCase()) {
      'snake' || 'snakecase' => value.toSnakeCase(),
      'camel' || 'camelcase' => value.toCamelCase(),
      'pascal' || 'pascalcase' => value.toPascalCase(),
      'title' || 'titlecase' => value.toTitleCase(),
      'upper' || 'uppercase' => value.toUpperCase(),
      'lower' || 'lowercase' => value.toLowerCase(),
      'kebab' || 'kebabcase' => value.toKebabCase(),
      'color' || 'hextocolor' => _hexToFlutterColor(value),
      'int' || 'hextoint' => _hexToInt(value),
      _ => value,
    };
  }
  
  String _applyTransformEnum(String value, Transform transform) {
    return switch (transform) {
      Transform.snakeCase => value.toSnakeCase(),
      Transform.camelCase => value.toCamelCase(),
      Transform.pascalCase => value.toPascalCase(),
      Transform.titleCase => value.toTitleCase(),
      Transform.upperCase => value.toUpperCase(),
      Transform.lowerCase => value.toLowerCase(),
      Transform.kebabCase => value.toKebabCase(),
      Transform.hexToColor => _hexToFlutterColor(value),
      Transform.hexToInt => _hexToInt(value),
    };
  }
  
  String _hexToFlutterColor(String hex) {
    final cleanHex = hex.replaceFirst('#', '');
    return 'Color(0xFF$cleanHex)';
  }
  
  String _hexToInt(String hex) {
    final cleanHex = hex.replaceFirst('#', '');
    return '0xFF$cleanHex';
  }
  
  /// Validate all required placeholders have values
  List<String> validate() {
    final errors = <String>[];
    
    for (final definition in PlaceholderRegistry.required) {
      if (!_values.containsKey(definition.name) || 
          _values[definition.name] == null) {
        errors.add('Missing required placeholder: ${definition.name}');
      }
    }
    
    // Validate values against allowed values
    for (final entry in _values.entries) {
      final definition = PlaceholderRegistry.get(entry.key);
      if (definition?.allowedValues != null) {
        if (!definition!.allowedValues!.contains(entry.value)) {
          errors.add(
            'Invalid value for ${entry.key}: ${entry.value}. '
            'Allowed: ${definition.allowedValues!.join(", ")}'
          );
        }
      }
      
      // Run custom validator
      if (definition?.validator != null) {
        final error = definition!.validator!.validate(entry.value);
        if (error != null) {
          errors.add('${entry.key}: $error');
        }
      }
    }
    
    return errors;
  }
}
```

---

## 3. Template Structure

### 3.1 Base Flutter Template

```
templates/flutter_app/
│
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart
│   │   ├── app_bindings.dart
│   │   └── app_config.dart
│   │
│   ├── config/
│   │   ├── {{APP_NAME_SNAKE}}_config.dart
│   │   ├── environment.dart
│   │   └── constants.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── typography.dart
│   │
│   ├── localization/
│   │   ├── l10n/
│   │   │   ├── app_en.arb
│   │   │   └── app_{{DEFAULT_LOCALE}}.arb
│   │   └── localization.dart
│   │
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── routes.dart
│   │
│   ├── features/
│   │   └── .gitkeep
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   └── loading_overlay.dart
│   │   ├── extensions/
│   │   └── mixins/
│   │
│   ├── providers/
│   │   └── providers.dart
│   │
│   └── screens/
│       ├── splash/
│       │   └── splash_screen.dart
│       └── home/
│           └── home_screen.dart
│
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/.../MainActivity.kt
│   ├── build.gradle
│   └── settings.gradle
│
├── ios/
│   ├── Runner/
│   │   ├── Info.plist
│   │   ├── AppDelegate.swift
│   │   └── Assets.xcassets/
│   ├── Runner.xcodeproj/
│   └── Podfile
│
├── web/
│   └── index.html
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

### 3.2 Template File Examples

#### main.dart

```dart
// templates/flutter_app/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiro_core/kiro_core.dart';

import 'app/app.dart';
import 'app/app_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Kiro Core
  await KiroCore.initialize(
    config: KiroConfig(
      appName: '{{APP_NAME}}',
      environment: Environment.development,
      enableLogging: true,
    ),
  );
  
  // Initialize app bindings
  await AppBindings.initialize();
  
  runApp(
    const ProviderScope(
      child: {{APP_NAME_PASCAL}}App(),
    ),
  );
}
```

#### app.dart

```dart
// templates/flutter_app/lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{#if LOCALIZATION_ENABLED}}
import 'package:flutter_localizations/flutter_localizations.dart';
import '../localization/localization.dart';
{{/if}}
import '../routing/app_router.dart';
import '../theme/app_theme.dart';

class {{APP_NAME_PASCAL}}App extends ConsumerWidget {
  const {{APP_NAME_PASCAL}}App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(themeProvider);
    {{#if LOCALIZATION_ENABLED}}
    final locale = ref.watch(localeProvider);
    {{/if}}

    return MaterialApp.router(
      title: '{{APP_NAME}}',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.themeMode,
      
      // Routing
      routerConfig: router,
      
      {{#if LOCALIZATION_ENABLED}}
      // Localization
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      {{/if}}
    );
  }
}
```

#### pubspec.yaml

```yaml
# templates/flutter_app/pubspec.yaml

name: {{APP_NAME_SNAKE}}
description: {{APP_DESCRIPTION:A Kiro-powered Flutter application}}
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
    
  # Kiro Core
  kiro_core:
    path: ../kiro_core
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Routing
  go_router: ^13.0.1
  
  # Utilities
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  {{#if LOCALIZATION_ENABLED}}
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
  {{/if}}
  
  # UI
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  
  {{#each ADDITIONAL_DEPENDENCIES}}
  {{this.name}}: {{this.version}}
  {{/each}}

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  {{#if LOCALIZATION_ENABLED}}
  intl_utils: ^2.8.5
  {{/if}}

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    {{#if CUSTOM_FONTS}}
    - assets/fonts/
    {{/if}}
  
  {{#if CUSTOM_FONTS}}
  fonts:
    {{#each FONTS}}
    - family: {{this.family}}
      fonts:
        {{#each this.weights}}
        - asset: assets/fonts/{{../family}}-{{this.name}}.ttf
          weight: {{this.value}}
        {{/each}}
    {{/each}}
  {{/if}}
```

#### AndroidManifest.xml

```xml
<!-- templates/flutter_app/android/app/src/main/AndroidManifest.xml -->

<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    {{#if PERMISSION_INTERNET}}
    <uses-permission android:name="android.permission.INTERNET"/>
    {{/if}}
    
    {{#if PERMISSION_CAMERA}}
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-feature android:name="android.hardware.camera" android:required="false"/>
    {{/if}}
    
    {{#if PERMISSION_LOCATION}}
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    {{/if}}
    
    {{#if PERMISSION_LOCATION_ALWAYS}}
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
    {{/if}}
    
    {{#if PERMISSION_STORAGE}}
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    {{/if}}
    
    {{#if PERMISSION_NOTIFICATION}}
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    {{/if}}
    
    {{#if PERMISSION_MICROPHONE}}
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    {{/if}}
    
    {{#if PERMISSION_CONTACTS}}
    <uses-permission android:name="android.permission.READ_CONTACTS"/>
    {{/if}}
    
    {{#if PERMISSION_CALENDAR}}
    <uses-permission android:name="android.permission.READ_CALENDAR"/>
    <uses-permission android:name="android.permission.WRITE_CALENDAR"/>
    {{/if}}

    <application
        android:label="{{APP_NAME}}"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            
            {{#if DEEP_LINKS}}
            <!-- Deep Links -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data android:scheme="https" android:host="{{DEEP_LINK_HOST}}"/>
            </intent-filter>
            {{/if}}
        </activity>
        
        {{#if FIREBASE_ENABLED}}
        <!-- Firebase Messaging -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel"/>
        {{/if}}

        <meta-data
            android:name="flutterEmbedding"
            android:value="2"/>
            
        {{#if GOOGLE_MAPS_ENABLED}}
        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="{{GOOGLE_MAPS_API_KEY}}"/>
        {{/if}}
    </application>
</manifest>
```

---

## 4. File Processing

### 4.1 Template Processor

```dart
/// template_processor.dart
///
/// Main template processing engine.

class TemplateProcessor {
  final String templatePath;
  final String outputPath;
  final Map<String, dynamic> values;
  final Logger _logger;
  
  late final PlaceholderReplacer _replacer;
  late final ConditionalProcessor _conditionalProcessor;
  late final LoopProcessor _loopProcessor;
  
  TemplateProcessor({
    required this.templatePath,
    required this.outputPath,
    required this.values,
    Logger? logger,
  }) : _logger = logger ?? Logger() {
    _replacer = PlaceholderReplacer(values: values);
    _conditionalProcessor = ConditionalProcessor(values: values);
    _loopProcessor = LoopProcessor(values: values);
  }
  
  /// Process all template files
  Future<void> processAll() async {
    // Validate placeholders
    final errors = _replacer.validate();
    if (errors.isNotEmpty) {
      throw TemplateException(
        'Placeholder validation failed',
        details: errors,
      );
    }
    
    // Get all template files
    final templateDir = Directory(templatePath);
    final files = await templateDir
        .list(recursive: true)
        .where((e) => e is File)
        .cast<File>()
        .toList();
    
    _logger.info('Processing ${files.length} template files...');
    
    for (final file in files) {
      await _processFile(file);
    }
    
    _logger.success('Template processing complete');
  }
  
  Future<void> _processFile(File file) async {
    final relativePath = path.relative(file.path, from: templatePath);
    
    // Skip certain files
    if (_shouldSkip(relativePath)) {
      return;
    }
    
    // Process filename placeholders
    final outputRelativePath = _processPath(relativePath);
    final outputFilePath = path.join(outputPath, outputRelativePath);
    
    // Check if it's a binary file
    if (_isBinaryFile(relativePath)) {
      await _copyBinaryFile(file, outputFilePath);
      return;
    }
    
    // Read content
    var content = await file.readAsString();
    
    // Process conditionals
    content = _conditionalProcessor.process(content);
    
    // Process loops
    content = _loopProcessor.process(content);
    
    // Replace placeholders
    content = _replacer.process(content);
    
    // Write output
    final outputFile = File(outputFilePath);
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsString(content);
    
    _logger.debug('Processed: $relativePath -> $outputRelativePath');
  }
  
  String _processPath(String filePath) {
    // Replace placeholders in path
    var result = _replacer.process(filePath);
    
    // Handle conditional file names
    // e.g., {{#if AUTH}}auth_screen.dart{{/if}} -> auth_screen.dart or removed
    result = _conditionalProcessor.process(result);
    
    return result;
  }
  
  bool _shouldSkip(String path) {
    final skipPatterns = [
      '.git',
      '.dart_tool',
      '.packages',
      'pubspec.lock',
      '.flutter-plugins',
      '.flutter-plugins-dependencies',
    ];
    
    return skipPatterns.any((pattern) => path.contains(pattern));
  }
  
  bool _isBinaryFile(String path) {
    final binaryExtensions = [
      '.png', '.jpg', '.jpeg', '.gif', '.ico', '.webp',
      '.ttf', '.otf', '.woff', '.woff2',
      '.zip', '.tar', '.gz',
      '.pdf', '.doc', '.docx',
    ];
    
    return binaryExtensions.any((ext) => path.endsWith(ext));
  }
  
  Future<void> _copyBinaryFile(File source, String destPath) async {
    final destFile = File(destPath);
    await destFile.parent.create(recursive: true);
    await source.copy(destPath);
  }
}
```

### 4.2 File Types and Handling

| File Type | Extension | Processing |
|-----------|-----------|------------|
| Dart | `.dart` | Full processing + dartfmt |
| YAML | `.yaml`, `.yml` | Placeholder replacement |
| XML | `.xml` | Conditional + Placeholder |
| JSON | `.json` | Placeholder replacement |
| Markdown | `.md` | Placeholder replacement |
| Properties | `.properties` | Placeholder replacement |
| Gradle | `.gradle` | Full processing |
| Swift | `.swift` | Full processing |
| Kotlin | `.kt` | Full processing |
| Plist | `.plist` | Conditional + Placeholder |
| Images | `.png`, `.jpg`, etc. | Copy only |
| Fonts | `.ttf`, `.otf` | Copy only |

---

## 5. Conditional Content

### 5.1 Conditional Syntax

```
{{#if CONDITION}}
  Content when true
{{/if}}

{{#if CONDITION}}
  Content when true
{{else}}
  Content when false
{{/if}}

{{#unless CONDITION}}
  Content when false
{{/unless}}

{{#if CONDITION_A}}
  {{#if CONDITION_B}}
    Nested conditions
  {{/if}}
{{/if}}
```

### 5.2 Conditional Processor

```dart
/// conditional_processor.dart

class ConditionalProcessor {
  final Map<String, dynamic> values;
  
  // Regex patterns
  static final RegExp _ifPattern = RegExp(
    r'\{\{#if\s+(\w+)\}\}([\s\S]*?)\{\{/if\}\}',
    multiLine: true,
  );
  
  static final RegExp _ifElsePattern = RegExp(
    r'\{\{#if\s+(\w+)\}\}([\s\S]*?)\{\{else\}\}([\s\S]*?)\{\{/if\}\}',
    multiLine: true,
  );
  
  static final RegExp _unlessPattern = RegExp(
    r'\{\{#unless\s+(\w+)\}\}([\s\S]*?)\{\{/unless\}\}',
    multiLine: true,
  );
  
  ConditionalProcessor({required this.values});
  
  String process(String content) {
    var result = content;
    
    // Process if-else first (more specific)
    result = _processIfElse(result);
    
    // Process simple if
    result = _processIf(result);
    
    // Process unless
    result = _processUnless(result);
    
    return result;
  }
  
  String _processIfElse(String content) {
    return content.replaceAllMapped(_ifElsePattern, (match) {
      final condition = match.group(1)!;
      final trueContent = match.group(2)!;
      final falseContent = match.group(3)!;
      
      return _evaluateCondition(condition) ? trueContent : falseContent;
    });
  }
  
  String _processIf(String content) {
    // Keep processing until no more matches (handles nesting)
    var result = content;
    var previousResult = '';
    
    while (result != previousResult) {
      previousResult = result;
      result = result.replaceAllMapped(_ifPattern, (match) {
        final condition = match.group(1)!;
        final trueContent = match.group(2)!;
        
        return _evaluateCondition(condition) ? trueContent : '';
      });
    }
    
    return result;
  }
  
  String _processUnless(String content) {
    return content.replaceAllMapped(_unlessPattern, (match) {
      final condition = match.group(1)!;
      final falseContent = match.group(2)!;
      
      return !_evaluateCondition(condition) ? falseContent : '';
    });
  }
  
  bool _evaluateCondition(String condition) {
    // Handle negation
    if (condition.startsWith('!')) {
      final actualCondition = condition.substring(1);
      return !_evaluateCondition(actualCondition);
    }
    
    // Get value
    final value = values[condition];
    
    // Evaluate
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.isNotEmpty && value.toLowerCase() != 'false';
    if (value is num) return value != 0;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    
    return true;
  }
}
```

---

## 6. Loop Constructs

### 6.1 Loop Syntax

```
{{#each ARRAY_NAME}}
  {{this}}                    # Current item (primitives)
  {{this.property}}           # Property of current item
  {{@index}}                  # Current index (0-based)
  {{@first}}                  # Is first item?
  {{@last}}                   # Is last item?
{{/each}}

{{#each ARRAY_NAME as item}}
  {{item}}                    # Named reference
  {{item.property}}
{{/each}}
```

### 6.2 Loop Processor

```dart
/// loop_processor.dart

class LoopProcessor {
  final Map<String, dynamic> values;
  
  static final RegExp _eachPattern = RegExp(
    r'\{\{#each\s+(\w+)(?:\s+as\s+(\w+))?\}\}([\s\S]*?)\{\{/each\}\}',
    multiLine: true,
  );
  
  static final RegExp _thisPattern = RegExp(r'\{\{this(?:\.(\w+))?\}\}');
  static final RegExp _indexPattern = RegExp(r'\{\{@index\}\}');
  static final RegExp _firstPattern = RegExp(r'\{\{@first\}\}');
  static final RegExp _lastPattern = RegExp(r'\{\{@last\}\}');
  
  LoopProcessor({required this.values});
  
  String process(String content) {
    return content.replaceAllMapped(_eachPattern, (match) {
      final arrayName = match.group(1)!;
      final itemName = match.group(2) ?? 'this';
      final template = match.group(3)!;
      
      final array = values[arrayName];
      if (array == null || array is! List) {
        return '';
      }
      
      final results = <String>[];
      for (var i = 0; i < array.length; i++) {
        final item = array[i];
        var itemContent = template;
        
        // Replace item references
        if (item is Map) {
          // Object item
          itemContent = _replaceObjectItem(itemContent, itemName, item);
        } else {
          // Primitive item
          itemContent = _replacePrimitiveItem(itemContent, itemName, item);
        }
        
        // Replace special variables
        itemContent = itemContent
          .replaceAll(_indexPattern, i.toString())
          .replaceAll(_firstPattern, (i == 0).toString())
          .replaceAll(_lastPattern, (i == array.length - 1).toString());
        
        results.add(itemContent);
      }
      
      return results.join('');
    });
  }
  
  String _replaceObjectItem(String content, String itemName, Map item) {
    var result = content;
    
    // Replace {{itemName.property}}
    final propertyPattern = RegExp('\\{\\{$itemName\\.(\\w+)\\}\\}');
    result = result.replaceAllMapped(propertyPattern, (match) {
      final property = match.group(1)!;
      return item[property]?.toString() ?? '';
    });
    
    // Replace {{this.property}}
    result = result.replaceAllMapped(_thisPattern, (match) {
      final property = match.group(1);
      if (property != null) {
        return item[property]?.toString() ?? '';
      }
      return item.toString();
    });
    
    return result;
  }
  
  String _replacePrimitiveItem(String content, String itemName, dynamic item) {
    var result = content;
    
    // Replace {{itemName}}
    result = result.replaceAll('{{$itemName}}', item.toString());
    
    // Replace {{this}}
    result = result.replaceAll('{{this}}', item.toString());
    
    return result;
  }
}
```

---

## 7. Template Validation

### 7.1 Validation Rules

```dart
/// template_validator.dart

class TemplateValidator {
  final String templatePath;
  final List<String> _errors = [];
  final List<String> _warnings = [];
  
  TemplateValidator({required this.templatePath});
  
  Future<ValidationResult> validate() async {
    _errors.clear();
    _warnings.clear();
    
    // Check template exists
    await _checkTemplateExists();
    
    // Check required files
    await _checkRequiredFiles();
    
    // Check placeholder syntax
    await _checkPlaceholderSyntax();
    
    // Check conditional syntax
    await _checkConditionalSyntax();
    
    // Check loop syntax
    await _checkLoopSyntax();
    
    // Check for unmatched braces
    await _checkUnmatchedBraces();
    
    // Check file naming
    await _checkFileNaming();
    
    return ValidationResult(
      isValid: _errors.isEmpty,
      errors: List.unmodifiable(_errors),
      warnings: List.unmodifiable(_warnings),
    );
  }
  
  Future<void> _checkTemplateExists() async {
    if (!await Directory(templatePath).exists()) {
      _errors.add('Template directory does not exist: $templatePath');
    }
  }
  
  Future<void> _checkRequiredFiles() async {
    final requiredFiles = [
      'lib/main.dart',
      'pubspec.yaml',
      'android/app/src/main/AndroidManifest.xml',
      'ios/Runner/Info.plist',
    ];
    
    for (final file in requiredFiles) {
      final filePath = path.join(templatePath, file);
      if (!await File(filePath).exists()) {
        _errors.add('Missing required file: $file');
      }
    }
  }
  
  Future<void> _checkPlaceholderSyntax() async {
    final files = await _getTextFiles();
    
    for (final file in files) {
      final content = await file.readAsString();
      
      // Check for known placeholders
      final placeholders = RegExp(r'\{\{(\w+)\}\}')
          .allMatches(content)
          .map((m) => m.group(1)!)
          .toSet();
      
      for (final placeholder in placeholders) {
        if (!PlaceholderRegistry.isValid(placeholder) && 
            !_isSpecialVariable(placeholder)) {
          _warnings.add(
            'Unknown placeholder {{$placeholder}} in ${file.path}'
          );
        }
      }
    }
  }
  
  Future<void> _checkConditionalSyntax() async {
    final files = await _getTextFiles();
    
    for (final file in files) {
      final content = await file.readAsString();
      
      // Check for unclosed if blocks
      final ifOpens = RegExp(r'\{\{#if\s+\w+\}\}').allMatches(content).length;
      final ifCloses = RegExp(r'\{\{/if\}\}').allMatches(content).length;
      
      if (ifOpens != ifCloses) {
        _errors.add(
          'Unclosed {{#if}} block in ${file.path} '
          '(opens: $ifOpens, closes: $ifCloses)'
        );
      }
      
      // Check for unclosed unless blocks
      final unlessOpens = RegExp(r'\{\{#unless\s+\w+\}\}').allMatches(content).length;
      final unlessCloses = RegExp(r'\{\{/unless\}\}').allMatches(content).length;
      
      if (unlessOpens != unlessCloses) {
        _errors.add(
          'Unclosed {{#unless}} block in ${file.path} '
          '(opens: $unlessOpens, closes: $unlessCloses)'
        );
      }
    }
  }
  
  Future<void> _checkLoopSyntax() async {
    final files = await _getTextFiles();
    
    for (final file in files) {
      final content = await file.readAsString();
      
      final eachOpens = RegExp(r'\{\{#each\s+\w+').allMatches(content).length;
      final eachCloses = RegExp(r'\{\{/each\}\}').allMatches(content).length;
      
      if (eachOpens != eachCloses) {
        _errors.add(
          'Unclosed {{#each}} block in ${file.path} '
          '(opens: $eachOpens, closes: $eachCloses)'
        );
      }
    }
  }
  
  Future<void> _checkUnmatchedBraces() async {
    final files = await _getTextFiles();
    
    for (final file in files) {
      final content = await file.readAsString();
      
      // Look for single braces that might be typos
      final singleOpen = RegExp(r'(?<!\{)\{(?!\{)').allMatches(content);
      final singleClose = RegExp(r'(?<!\})\}(?!\})').allMatches(content);
      
      // This is just a warning as single braces are valid in Dart
      if (singleOpen.length != singleClose.length) {
        _warnings.add(
          'Potentially unmatched braces in ${file.path}'
        );
      }
    }
  }
  
  Future<void> _checkFileNaming() async {
    final dir = Directory(templatePath);
    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;
      
      final fileName = path.basename(entity.path);
      
      // Check for placeholder in filename
      if (fileName.contains('{{') && !fileName.contains('}}')) {
        _errors.add('Malformed placeholder in filename: $fileName');
      }
    }
  }
  
  bool _isSpecialVariable(String name) {
    const specialVars = ['this', 'index', 'first', 'last'];
    return specialVars.contains(name.toLowerCase());
  }
  
  Future<List<File>> _getTextFiles() async {
    final dir = Directory(templatePath);
    final files = <File>[];
    
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && _isTextFile(entity.path)) {
        files.add(entity);
      }
    }
    
    return files;
  }
  
  bool _isTextFile(String filePath) {
    const textExtensions = [
      '.dart', '.yaml', '.yml', '.json', '.xml', '.md',
      '.gradle', '.properties', '.swift', '.kt', '.plist',
      '.html', '.css', '.js', '.ts',
    ];
    return textExtensions.any((ext) => filePath.endsWith(ext));
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  
  const ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });
}
```

---

## 8. Performance Considerations

### 8.1 Optimization Strategies

1. **Parallel File Processing**: Process independent files concurrently
2. **Lazy Compilation**: Compile regex patterns once and reuse
3. **Streaming for Large Files**: Use streams for files > 1MB
4. **Caching**: Cache parsed templates for repeated use
5. **Early Validation**: Fail fast on validation errors

### 8.2 Memory Management

```dart
/// For large templates, use streaming

Future<void> processLargeFile(File file, File output) async {
  final sink = output.openWrite();
  
  await for (final line in file.openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())) {
    final processed = _processLine(line);
    sink.writeln(processed);
  }
  
  await sink.close();
}
```

---

**Next Document**: [06_roadmap.md](./06_roadmap.md)

