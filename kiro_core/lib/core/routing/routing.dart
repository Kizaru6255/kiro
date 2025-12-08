/// Routing module for Kiro Core.
///
/// Provides:
/// - [AppRouter] - Base router configuration
/// - [RoutePath] - Type-safe route path definitions
/// - [RouteGuard] - Route protection/guards
/// - [NavigationUtils] - Navigation utilities and extensions
/// - [KiroPageTransitions] - Custom page transitions
///
/// ## Quick Start
///
/// ```dart
/// // Define routes
/// class AppRoutes {
///   static const home = RoutePath('/');
///   static const login = RoutePath('/login');
///   static const profile = RoutePath('/profile/:userId');
///   static const settings = RoutePath('/settings');
/// }
///
/// // Create guards
/// class AuthGuard extends RouteGuard {
///   final AuthService auth;
///
///   AuthGuard(this.auth);
///
///   @override
///   FutureOr<String?> canActivate(BuildContext context, GoRouterState state) {
///     if (!auth.isLoggedIn) {
///       return '/login?redirect=${state.uri.path}';
///     }
///     return null;
///   }
/// }
///
/// // Create router
/// final router = AppRouter(
///   initialRoute: AppRoutes.home,
///   guards: [AuthGuard(authService)],
///   excludedPaths: ['/login', '/register'],
///   routes: [
///     GoRoute(
///       path: AppRoutes.home.path,
///       builder: (context, state) => const HomeScreen(),
///     ),
///     GoRoute(
///       path: AppRoutes.profile.path,
///       builder: (context, state) => ProfileScreen(
///         userId: state.pathParameters['userId']!,
///       ),
///     ),
///   ],
/// );
///
/// // Use in app
/// MaterialApp.router(
///   routerConfig: router.config,
/// );
///
/// // Navigate
/// context.go(AppRoutes.profile.build({'userId': '123'}));
/// context.pushTo('/settings');
/// ```
library;

export 'app_router.dart';
export 'navigation_utils.dart';
export 'route_guards.dart';
export 'route_path.dart';

