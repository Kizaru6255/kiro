/// API endpoint definitions and builders.
///
/// Centralizes all API endpoints for easy management
/// and refactoring.
library;

/// Base class for API endpoint configuration.
///
/// Extend this class to define your application's endpoints.
///
/// Example:
/// ```dart
/// class MyApiEndpoints extends ApiEndpoints {
///   MyApiEndpoints() : super(baseUrl: 'https://api.example.com/v1');
///
///   // Auth endpoints
///   String get login => '/auth/login';
///   String get register => '/auth/register';
///
///   // User endpoints
///   String user(String id) => '/users/$id';
///   String get currentUser => '/users/me';
/// }
/// ```
abstract class ApiEndpoints {
  /// Base URL for all endpoints.
  final String baseUrl;

  /// API version prefix (e.g., '/v1').
  final String? versionPrefix;

  const ApiEndpoints({
    required this.baseUrl,
    this.versionPrefix,
  });

  /// Get full URL for an endpoint.
  String fullUrl(String endpoint) {
    final prefix = versionPrefix ?? '';
    return '$baseUrl$prefix$endpoint';
  }
}

/// Default Kiro API endpoints.
///
/// Override these in your application by extending [ApiEndpoints].
class KiroApiEndpoints extends ApiEndpoints {
  const KiroApiEndpoints({
    required super.baseUrl,
    super.versionPrefix,
  });

  // ============================================================
  // Authentication
  // ============================================================

  /// Login with credentials.
  String get login => '/auth/login';

  /// Register new account.
  String get register => '/auth/register';

  /// Logout current session.
  String get logout => '/auth/logout';

  /// Refresh access token.
  String get refreshToken => '/auth/refresh';

  /// Send OTP to phone.
  String get sendOtp => '/auth/otp/send';

  /// Verify OTP.
  String get verifyOtp => '/auth/otp/verify';

  /// Request password reset.
  String get forgotPassword => '/auth/forgot-password';

  /// Reset password with token.
  String get resetPassword => '/auth/reset-password';

  /// Change password.
  String get changePassword => '/auth/change-password';

  /// Social login.
  String get socialLogin => '/auth/social';

  // ============================================================
  // User
  // ============================================================

  /// Get current user profile.
  String get currentUser => '/users/me';

  /// Get user by ID.
  String user(String id) => '/users/$id';

  /// Update current user profile.
  String get updateProfile => '/users/me';

  /// Upload profile picture.
  String get uploadAvatar => '/users/me/avatar';

  /// Delete account.
  String get deleteAccount => '/users/me';

  // ============================================================
  // App Config
  // ============================================================

  /// Get app configuration.
  String get appConfig => '/config';

  /// Get feature flags.
  String get featureFlags => '/config/features';

  // ============================================================
  // Notifications
  // ============================================================

  /// Get notifications.
  String get notifications => '/notifications';

  /// Mark notification as read.
  String notificationRead(String id) => '/notifications/$id/read';

  /// Mark all notifications as read.
  String get notificationsReadAll => '/notifications/read-all';

  /// Register push token.
  String get registerPushToken => '/notifications/token';

  // ============================================================
  // File Upload
  // ============================================================

  /// Upload file.
  String get upload => '/upload';

  /// Upload multiple files.
  String get uploadMultiple => '/upload/multiple';

  // ============================================================
  // Helpers
  // ============================================================

  /// Build URL with query parameters.
  String withQuery(String endpoint, Map<String, dynamic> params) {
    final nonNullParams = params.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    if (nonNullParams.isEmpty) return endpoint;
    return '$endpoint?$nonNullParams';
  }

  /// Build paginated endpoint.
  String paginated(
    String endpoint, {
    int page = 1,
    int perPage = 20,
    String? sortBy,
    bool descending = false,
    Map<String, dynamic>? filters,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortBy != null) 'sort_order': descending ? 'desc' : 'asc',
      ...?filters,
    };
    return withQuery(endpoint, params);
  }
}

/// HTTP methods.
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  const HttpMethod(this.value);
  final String value;
}

/// Request content types.
enum ContentType {
  json('application/json'),
  formData('multipart/form-data'),
  formUrlEncoded('application/x-www-form-urlencoded'),
  text('text/plain');

  const ContentType(this.value);
  final String value;
}

