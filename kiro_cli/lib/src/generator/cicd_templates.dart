/// CI/CD pipeline templates for generated apps.
library;

/// Generate GitHub Actions workflow.
String generateGitHubActions({
  required String appName,
  required List<String> platforms,
}) {
  final buffer = StringBuffer();

  buffer.writeln('name: CI');
  buffer.writeln();
  buffer.writeln('on:');
  buffer.writeln('  push:');
  buffer.writeln('    branches: [ main, develop ]');
  buffer.writeln('  pull_request:');
  buffer.writeln('    branches: [ main, develop ]');
  buffer.writeln();
  buffer.writeln('jobs:');
  buffer.writeln('  test:');
  buffer.writeln('    runs-on: ubuntu-latest');
  buffer.writeln();
  buffer.writeln('    steps:');
  buffer.writeln('    - uses: actions/checkout@v3');
  buffer.writeln('    - uses: subosito/flutter-action@v2');
  buffer.writeln('      with:');
  buffer.writeln('        flutter-version: \'3.0.0\'');
  buffer.writeln('        channel: \'stable\'');
  buffer.writeln();
  buffer.writeln('    - name: Install dependencies');
  buffer.writeln('      run: flutter pub get');
  buffer.writeln();
  buffer.writeln('    - name: Analyze code');
  buffer.writeln('      run: flutter analyze');
  buffer.writeln();
  buffer.writeln('    - name: Run tests');
  buffer.writeln('      run: flutter test');
  buffer.writeln();

  if (platforms.contains('android')) {
    buffer.writeln('    - name: Build Android');
    buffer.writeln('      run: flutter build apk --release');
    buffer.writeln();
  }

  if (platforms.contains('ios')) {
    buffer.writeln('    - name: Build iOS');
    buffer.writeln('      run: flutter build ios --release --no-codesign');
    buffer.writeln();
  }

  if (platforms.contains('web')) {
    buffer.writeln('    - name: Build Web');
    buffer.writeln('      run: flutter build web --release');
    buffer.writeln();
  }

  return buffer.toString();
}

/// Generate GitLab CI configuration.
String generateGitLabCI({
  required String appName,
  required List<String> platforms,
}) {
  final buffer = StringBuffer();

  buffer.writeln('image: cirrusci/flutter:stable');
  buffer.writeln();
  buffer.writeln('stages:');
  buffer.writeln('  - test');
  buffer.writeln('  - build');
  buffer.writeln();
  buffer.writeln('test:');
  buffer.writeln('  stage: test');
  buffer.writeln('  script:');
  buffer.writeln('    - flutter pub get');
  buffer.writeln('    - flutter analyze');
  buffer.writeln('    - flutter test');
  buffer.writeln();
  buffer.writeln('build:');
  buffer.writeln('  stage: build');
  buffer.writeln('  script:');
  buffer.writeln('    - flutter pub get');
  if (platforms.contains('android')) {
    buffer.writeln('    - flutter build apk --release');
  }
  if (platforms.contains('web')) {
    buffer.writeln('    - flutter build web --release');
  }
  buffer.writeln('  artifacts:');
  buffer.writeln('    paths:');
  buffer.writeln('      - build/');

  return buffer.toString();
}

/// Generate analysis options for linting.
String generateAnalysisOptions() {
  return '''
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_require_non_null_named_parameters
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_returning_null_for_future
    - avoid_slow_async_io
    - avoid_unnecessary_containers
    - cancel_subscriptions
    - close_sinks
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_single_quotes
    - sort_pub_dependencies
    - use_key_in_widget_constructors

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
''';
}


