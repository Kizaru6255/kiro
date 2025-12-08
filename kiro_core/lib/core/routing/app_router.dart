/// Base app router configuration.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_guards.dart';
import 'route_path.dart';

/// Router configuration for Kiro apps.
///
/// Provides a base configuration for go_router with common features.
///
/// Example:
/// ```dart
/// final router = AppRouter(
///   initialRoute: AppRoutes.home,
///   routes: [
///     GoRoute(
///       path: AppRoutes.home.path,
///       builder: (context, state) => const HomeScreen(),
///     ),
///   ],
///   guards: [AuthGuard(auth)],
/// );
///
/// MaterialApp.router(
///   routerConfig: router.config,
/// );
/// ```
class AppRouter {
  /// Initial route.
  final RoutePath initialRoute;

  /// Route definitions.
  final List<RouteBase> routes;

  /// Route guards.
  final List<RouteGuard> guards;

  /// Paths to exclude from guards.
  final List<String> excludedPaths;

  /// Error/404 page builder.
  final Widget Function(BuildContext, GoRouterState)? errorBuilder;

  /// Navigation observers.
  final List<NavigatorObserver>? observers;

  /// Debug logging.
  final bool debugLogDiagnostics;

  /// GoRouter instance.
  late final GoRouter _router;

  /// Create an app router.
  AppRouter({
    required this.initialRoute,
    required this.routes,
    this.guards = const [],
    this.excludedPaths = const [],
    this.errorBuilder,
    this.observers,
    this.debugLogDiagnostics = false,
  }) {
    _router = GoRouter(
      initialLocation: initialRoute.path,
      routes: routes,
      redirect: guards.isNotEmpty
          ? createRedirectFromGuards(guards, excludedPaths: excludedPaths)
          : null,
      errorBuilder: errorBuilder ?? _defaultErrorBuilder,
      observers: observers,
      debugLogDiagnostics: debugLogDiagnostics,
    );
  }

  /// Get router configuration.
  GoRouter get config => _router;

  /// Current location.
  String get currentLocation =>
      _router.routeInformationProvider.value.uri.path;

  /// Navigate to a path.
  void go(String path, {Object? extra}) {
    _router.go(path, extra: extra);
  }

  /// Navigate to a route path.
  void goTo(RoutePath route, {Map<String, String>? params, Object? extra}) {
    _router.go(route.build(params), extra: extra);
  }

  /// Push a path.
  Future<T?> push<T>(String path, {Object? extra}) {
    return _router.push<T>(path, extra: extra);
  }

  /// Push a route path.
  Future<T?> pushTo<T>(RoutePath route, {Map<String, String>? params, Object? extra}) {
    return _router.push<T>(route.build(params), extra: extra);
  }

  /// Replace current path.
  void replace(String path, {Object? extra}) {
    _router.pushReplacement(path, extra: extra);
  }

  /// Pop current route.
  void pop<T>([T? result]) {
    _router.pop(result);
  }

  /// Check if can pop.
  bool canPop() => _router.canPop();

  /// Refresh router (re-evaluate redirects).
  void refresh() {
    _router.refresh();
  }

  Widget _defaultErrorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              '404',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => go(initialRoute.path),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Route builder helper for common patterns.
class RouteBuilder {
  RouteBuilder._();

  /// Create a simple route.
  static GoRoute simple({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? name,
    List<RouteBase>? routes,
  }) {
    return GoRoute(
      path: path,
      name: name,
      builder: builder,
      routes: routes ?? [],
    );
  }

  /// Create a route from RoutePath.
  static GoRoute fromPath({
    required RoutePath route,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<RouteBase>? routes,
  }) {
    return GoRoute(
      path: route.path,
      name: route.name,
      builder: builder,
      routes: routes ?? [],
    );
  }

  /// Create a shell route (for nested navigation).
  static ShellRoute shell({
    required Widget Function(BuildContext, GoRouterState, Widget) builder,
    required List<RouteBase> routes,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return ShellRoute(
      navigatorKey: navigatorKey,
      builder: builder,
      routes: routes,
    );
  }

  /// Create a stateful shell route (for bottom navigation).
  static StatefulShellRoute bottomNavigation({
    required Widget Function(
      BuildContext,
      GoRouterState,
      StatefulNavigationShell,
    )
        builder,
    required List<StatefulShellBranch> branches,
  }) {
    return StatefulShellRoute.indexedStack(
      builder: builder,
      branches: branches,
    );
  }

  /// Create a branch for stateful shell route.
  static StatefulShellBranch branch({
    required List<RouteBase> routes,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return StatefulShellBranch(
      navigatorKey: navigatorKey,
      routes: routes,
    );
  }
}

