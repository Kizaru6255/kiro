/// Route path definitions and utilities.
library;

/// Base class for defining type-safe route paths.
///
/// Example:
/// ```dart
/// class AppRoutes {
///   static const home = RoutePath('/');
///   static const profile = RoutePath('/profile');
///   static const settings = RoutePath('/settings');
///
///   // With parameters
///   static const userProfile = RoutePath('/user/:userId');
///   static const product = RoutePath('/product/:productId');
/// }
/// ```
class RoutePath {
  /// The path pattern.
  final String path;

  /// Route name (for named navigation).
  final String? name;

  /// Create a route path.
  const RoutePath(this.path, {this.name});

  /// Build path with parameters.
  ///
  /// Example:
  /// ```dart
  /// final path = AppRoutes.userProfile.build({'userId': '123'});
  /// // Returns: '/user/123'
  /// ```
  String build([Map<String, String>? params]) {
    if (params == null || params.isEmpty) {
      return path;
    }

    var result = path;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }

  /// Build path with query parameters.
  ///
  /// Example:
  /// ```dart
  /// final path = AppRoutes.search.withQuery({'q': 'flutter', 'page': '1'});
  /// // Returns: '/search?q=flutter&page=1'
  /// ```
  String withQuery(Map<String, String> queryParams) {
    if (queryParams.isEmpty) return path;

    final query = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$path?$query';
  }

  /// Build path with both path and query parameters.
  String buildWithQuery({
    Map<String, String>? params,
    Map<String, String>? queryParams,
  }) {
    var result = build(params);
    if (queryParams != null && queryParams.isNotEmpty) {
      result = withQuery(queryParams);
    }
    return result;
  }

  /// Extract parameters from a path.
  ///
  /// Example:
  /// ```dart
  /// final params = AppRoutes.userProfile.extractParams('/user/123');
  /// // Returns: {'userId': '123'}
  /// ```
  Map<String, String> extractParams(String actualPath) {
    final params = <String, String>{};

    final patternSegments = path.split('/');
    final actualSegments = actualPath.split('?').first.split('/');

    if (patternSegments.length != actualSegments.length) {
      return params;
    }

    for (var i = 0; i < patternSegments.length; i++) {
      final pattern = patternSegments[i];
      final actual = actualSegments[i];

      if (pattern.startsWith(':')) {
        final paramName = pattern.substring(1);
        params[paramName] = actual;
      }
    }

    return params;
  }

  /// Check if this route matches a path.
  bool matches(String actualPath) {
    final patternSegments = path.split('/');
    final actualSegments = actualPath.split('?').first.split('/');

    if (patternSegments.length != actualSegments.length) {
      return false;
    }

    for (var i = 0; i < patternSegments.length; i++) {
      final pattern = patternSegments[i];
      final actual = actualSegments[i];

      // Parameter segments always match
      if (pattern.startsWith(':')) continue;

      // Exact segments must match
      if (pattern != actual) return false;
    }

    return true;
  }

  @override
  String toString() => path;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutePath &&
          runtimeType == other.runtimeType &&
          path == other.path;

  @override
  int get hashCode => path.hashCode;
}

/// Route with nested children.
class NestedRoutePath extends RoutePath {
  /// Parent route path.
  final RoutePath? parent;

  /// Create a nested route.
  const NestedRoutePath(super.path, {super.name, this.parent});

  /// Get full path including parent.
  String get fullPath {
    if (parent == null) return path;
    final parentPath = parent!.path.endsWith('/')
        ? parent!.path.substring(0, parent!.path.length - 1)
        : parent!.path;
    return '$parentPath$path';
  }

  @override
  String build([Map<String, String>? params]) {
    if (params == null || params.isEmpty) {
      return fullPath;
    }

    var result = fullPath;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }
}

