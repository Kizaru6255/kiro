/// Navigation utility functions and extensions.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation utilities and helpers.
class NavigationUtils {
  NavigationUtils._();

  /// Pop until reaching a specific route.
  static void popUntil(BuildContext context, String path) {
    final router = GoRouter.of(context);
    while (router.canPop()) {
      router.pop();
    }
  }

  /// Clear stack and navigate to new route.
  static void clearAndNavigate(BuildContext context, String path) {
    while (context.canPop()) {
      context.pop();
    }
    context.pushReplacement(path);
  }

  /// Get current route path.
  static String getCurrentPath(BuildContext context) {
    final router = GoRouter.of(context);
    return router.routeInformationProvider.value.uri.path;
  }

  /// Check if a route is active.
  static bool isRouteActive(BuildContext context, String path) {
    return getCurrentPath(context) == path;
  }

  /// Check if a route path starts with prefix.
  static bool isRouteStartsWith(BuildContext context, String prefix) {
    return getCurrentPath(context).startsWith(prefix);
  }
}

/// Extension methods for easier navigation.
extension NavigationExtensions on BuildContext {
  /// Navigate to a named route.
  void navigateTo(String path, {Object? extra}) {
    go(path, extra: extra);
  }

  /// Push a new route onto the stack.
  Future<T?> pushTo<T>(String path, {Object? extra}) {
    return push<T>(path, extra: extra);
  }

  /// Replace current route.
  void replaceTo(String path, {Object? extra}) {
    pushReplacement(path, extra: extra);
  }

  /// Pop the current route.
  void goBack<T>([T? result]) {
    pop(result);
  }

  /// Check if can go back.
  bool get hasBackRoute => canPop();

  /// Pop until predicate is true.
  void popUntilPath(String path) {
    NavigationUtils.popUntil(this, path);
  }

  /// Clear all routes and go to path.
  void clearAndGo(String path) {
    NavigationUtils.clearAndNavigate(this, path);
  }

  /// Get current path.
  String get currentPath => NavigationUtils.getCurrentPath(this);

  /// Check if route is active.
  bool isActive(String path) => NavigationUtils.isRouteActive(this, path);
}

/// Custom page transitions.
class KiroPageTransitions {
  KiroPageTransitions._();

  /// Fade transition.
  static CustomTransitionPage<T> fade<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide from right transition.
  static CustomTransitionPage<T> slideRight<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  /// Slide from bottom transition.
  static CustomTransitionPage<T> slideUp<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  /// Scale transition.
  static CustomTransitionPage<T> scale<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.9,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  /// No transition (instant).
  static CustomTransitionPage<T> none<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}

