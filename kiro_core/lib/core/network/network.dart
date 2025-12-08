/// Network module for Kiro Core.
///
/// Provides HTTP client and API services:
/// - [DioClient] - Pre-configured Dio HTTP client
/// - [ApiResponse] - Type-safe response wrapper
/// - [ApiEndpoints] - Centralized endpoint definitions
/// - Interceptors for auth, retry, and more
///
/// ## Quick Start
///
/// ```dart
/// // Initialize the client
/// DioClient.initialize(
///   config: DioClientConfig(baseUrl: 'https://api.example.com'),
/// );
///
/// // Make requests
/// final response = await DioClient.instance.get<User>(
///   '/users/1',
///   fromJson: User.fromJson,
/// );
///
/// response.when(
///   success: (user, status) => print('User: ${user.name}'),
///   failure: (error, status) => print('Error: ${error.message}'),
/// );
/// ```
///
/// ## With Authentication
///
/// ```dart
/// // Add auth interceptor
/// DioClient.instance.addInterceptor(
///   AuthInterceptor(
///     storage: secureStorage,
///     onRefreshToken: (token) => authApi.refresh(token),
///     onRefreshFailed: () => router.go('/login'),
///     excludedPaths: ['/auth/login', '/auth/register'],
///   ),
/// );
/// ```
///
/// ## With Retry
///
/// ```dart
/// DioClient.instance.addInterceptor(
///   RetryInterceptor(
///     maxRetries: 3,
///     retryableStatuses: {500, 502, 503},
///   ),
/// );
/// ```
library;

export 'api_endpoints.dart';
export 'api_response.dart';
export 'dio_client.dart';
export 'interceptors/auth_interceptor.dart';
export 'interceptors/retry_interceptor.dart';

