/// Route guards for protecting routes.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Base class for route guards.
///
/// Route guards determine whether navigation to a route should be allowed.
///
/// Example:
/// ```dart
/// class AuthGuard extends RouteGuard {
///   final AuthService auth;
///
///   AuthGuard(this.auth);
///
///   @override
///   Future<String?> canActivate(BuildContext context, GoRouterState state) async {
///     if (!auth.isLoggedIn) {
///       return '/login?redirect=${state.uri.path}';
///     }
///     return null; // Allow navigation
///   }
/// }
/// ```
abstract class RouteGuard {
  /// Check if navigation should be allowed.
  ///
  /// Returns `null` to allow, or a redirect path to redirect.
  FutureOr<String?> canActivate(BuildContext context, GoRouterState state);
}

/// Combines multiple guards.
class CompositeGuard extends RouteGuard {
  /// List of guards to check.
  final List<RouteGuard> guards;

  /// Create a composite guard.
  CompositeGuard(this.guards);

  @override
  Future<String?> canActivate(BuildContext context, GoRouterState state) async {
    for (final guard in guards) {
      final result = await guard.canActivate(context, state);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

/// Guard that checks a synchronous condition.
class SyncGuard extends RouteGuard {
  /// Condition to check.
  final bool Function(BuildContext context, GoRouterState state) condition;

  /// Redirect path if condition fails.
  final String redirectPath;

  /// Create a sync guard.
  SyncGuard({
    required this.condition,
    required this.redirectPath,
  });

  @override
  String? canActivate(BuildContext context, GoRouterState state) {
    return condition(context, state) ? null : redirectPath;
  }
}

/// Guard that checks an async condition.
class AsyncGuard extends RouteGuard {
  /// Async condition to check.
  final Future<bool> Function(BuildContext context, GoRouterState state) condition;

  /// Redirect path if condition fails.
  final String redirectPath;

  /// Create an async guard.
  AsyncGuard({
    required this.condition,
    required this.redirectPath,
  });

  @override
  Future<String?> canActivate(BuildContext context, GoRouterState state) async {
    final allowed = await condition(context, state);
    return allowed ? null : redirectPath;
  }
}

/// Guard that requires a specific role.
class RoleGuard extends RouteGuard {
  /// Function to get current user roles.
  final Future<List<String>> Function() getRoles;

  /// Required roles (user must have at least one).
  final List<String> requiredRoles;

  /// Redirect path if not authorized.
  final String unauthorizedPath;

  /// Create a role guard.
  RoleGuard({
    required this.getRoles,
    required this.requiredRoles,
    this.unauthorizedPath = '/unauthorized',
  });

  @override
  Future<String?> canActivate(BuildContext context, GoRouterState state) async {
    final userRoles = await getRoles();
    final hasRole = requiredRoles.any((role) => userRoles.contains(role));
    return hasRole ? null : unauthorizedPath;
  }
}

/// Guard that checks if onboarding is complete.
class OnboardingGuard extends RouteGuard {
  /// Function to check if onboarding is complete.
  final Future<bool> Function() isComplete;

  /// Onboarding route.
  final String onboardingPath;

  /// Create an onboarding guard.
  OnboardingGuard({
    required this.isComplete,
    this.onboardingPath = '/onboarding',
  });

  @override
  Future<String?> canActivate(BuildContext context, GoRouterState state) async {
    final complete = await isComplete();
    return complete ? null : onboardingPath;
  }
}

/// Guard that checks connectivity.
class ConnectivityGuard extends RouteGuard {
  /// Function to check connectivity.
  final bool Function() isConnected;

  /// Offline route.
  final String offlinePath;

  /// Create a connectivity guard.
  ConnectivityGuard({
    required this.isConnected,
    this.offlinePath = '/offline',
  });

  @override
  String? canActivate(BuildContext context, GoRouterState state) {
    return isConnected() ? null : offlinePath;
  }
}

/// Create a redirect function from guards.
///
/// Example:
/// ```dart
/// final router = GoRouter(
///   redirect: createRedirectFromGuards([
///     AuthGuard(authService),
///     OnboardingGuard(storage),
///   ]),
///   routes: [...],
/// );
/// ```
FutureOr<String?> Function(BuildContext, GoRouterState) createRedirectFromGuards(
  List<RouteGuard> guards, {
  List<String>? excludedPaths,
}) {
  return (context, state) async {
    // Skip guards for excluded paths
    if (excludedPaths != null) {
      final currentPath = state.uri.path;
      if (excludedPaths.any((path) => currentPath.startsWith(path))) {
        return null;
      }
    }

    // Check all guards
    for (final guard in guards) {
      final redirect = await guard.canActivate(context, state);
      if (redirect != null) {
        return redirect;
      }
    }

    return null;
  };
}

