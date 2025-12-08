/// Dio HTTP client configuration and singleton.
///
/// Provides a pre-configured Dio instance with interceptors
/// for logging, authentication, and error handling.
library;

import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/errors.dart';
import '../logger/logger.dart';
import 'api_response.dart';

/// Configuration for DioClient.
class DioClientConfig {
  /// Base URL for all requests.
  final String baseUrl;

  /// Connection timeout.
  final Duration connectTimeout;

  /// Receive timeout.
  final Duration receiveTimeout;

  /// Send timeout.
  final Duration sendTimeout;

  /// Default headers for all requests.
  final Map<String, dynamic> headers;

  /// Whether to enable request/response logging.
  final bool enableLogging;

  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Whether to follow redirects.
  final bool followRedirects;

  /// Maximum number of redirects to follow.
  final int maxRedirects;

  const DioClientConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.headers = const {},
    this.enableLogging = true,
    this.maxRetries = 3,
    this.followRedirects = true,
    this.maxRedirects = 5,
  });

  /// Create a copy with updated values.
  DioClientConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
    bool? enableLogging,
    int? maxRetries,
    bool? followRedirects,
    int? maxRedirects,
  }) {
    return DioClientConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      headers: headers ?? this.headers,
      enableLogging: enableLogging ?? this.enableLogging,
      maxRetries: maxRetries ?? this.maxRetries,
      followRedirects: followRedirects ?? this.followRedirects,
      maxRedirects: maxRedirects ?? this.maxRedirects,
    );
  }
}

/// Singleton Dio HTTP client.
///
/// Pre-configured with interceptors for:
/// - Logging
/// - Error handling
/// - Token authentication (when configured)
/// - Retry logic
///
/// Example:
/// ```dart
/// final client = DioClient(
///   config: DioClientConfig(baseUrl: 'https://api.example.com'),
/// );
///
/// final response = await client.get<Map<String, dynamic>>('/users/1');
/// ```
class DioClient {
  /// Dio instance.
  final Dio dio;

  /// Client configuration.
  final DioClientConfig config;

  /// Logger instance.
  final KiroLogger _logger;

  /// Singleton instance.
  static DioClient? _instance;

  /// Get singleton instance.
  ///
  /// Must call [initialize] first.
  static DioClient get instance {
    if (_instance == null) {
      throw const ConfigurationException(
        message: 'DioClient not initialized. Call DioClient.initialize() first.',
        code: 'DIO_NOT_INITIALIZED',
      );
    }
    return _instance!;
  }

  /// Initialize the singleton with configuration.
  static DioClient initialize({required DioClientConfig config}) {
    _instance = DioClient(config: config);
    return _instance!;
  }

  /// Create a new DioClient instance.
  DioClient({
    required this.config,
    Dio? dio,
    KiroLogger? logger,
  })  : dio = dio ?? Dio(),
        _logger = logger ?? KiroLogger(tag: 'DioClient') {
    _configureDio();
  }

  void _configureDio() {
    dio.options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...config.headers,
      },
      followRedirects: config.followRedirects,
      maxRedirects: config.maxRedirects,
    );

    // Add logging interceptor
    if (config.enableLogging) {
      dio.interceptors.add(_LoggingInterceptor(_logger));
    }

    // Add error handler interceptor
    dio.interceptors.add(_ErrorInterceptor());
  }

  /// Add an interceptor.
  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  /// Remove an interceptor.
  void removeInterceptor(Interceptor interceptor) {
    dio.interceptors.remove(interceptor);
  }

  /// Clear all interceptors.
  void clearInterceptors() {
    dio.interceptors.clear();
    _configureDio(); // Re-add default interceptors
  }

  // ============================================================
  // HTTP Methods
  // ============================================================

  /// Perform GET request.
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// Perform POST request.
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// Perform PUT request.
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// Perform PATCH request.
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// Perform DELETE request.
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// Upload a file.
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required File file,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      ...?data,
    });

    return post<T>(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// Download a file.
  Future<ApiResponse<File>> download(
    String urlPath, {
    required String savePath,
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      return ApiResponse.success(
        data: File(savePath),
        statusCode: 200,
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        exception: _mapDioException(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ============================================================
  // Internal Methods
  // ============================================================

  Future<ApiResponse<T>> _request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );

      final responseData = response.data;
      final T parsedData;

      if (fromJson != null) {
        parsedData = fromJson(responseData);
      } else if (responseData is T) {
        parsedData = responseData;
      } else {
        parsedData = responseData as T;
      }

      return ApiResponse.success(
        data: parsedData,
        statusCode: response.statusCode ?? 200,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        exception: _mapDioException(e),
        statusCode: e.response?.statusCode,
        rawBody: e.response?.data?.toString(),
        headers: e.response?.headers.map,
      );
    } catch (e, st) {
      return ApiResponse.failure(
        exception: NetworkException(
          message: 'Unexpected error: $e',
          code: 'UNEXPECTED_ERROR',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  NetworkException _mapDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        TimeoutException(
          message: 'Request timed out',
          originalError: e,
          stackTrace: e.stackTrace,
        ),
      DioExceptionType.connectionError => NoInternetException(
          message: 'No internet connection',
          originalError: e,
          stackTrace: e.stackTrace,
        ),
      DioExceptionType.badResponse => _mapStatusCode(e),
      DioExceptionType.cancel => NetworkException(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
          originalError: e,
          stackTrace: e.stackTrace,
        ),
      _ => NetworkException(
          message: e.message ?? 'Network error',
          code: 'NETWORK_ERROR',
          originalError: e,
          stackTrace: e.stackTrace,
        ),
    };
  }

  NetworkException _mapStatusCode(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final message = _extractErrorMessage(data) ?? 'Request failed';

    return switch (statusCode) {
      400 => BadRequestException(
          message: message,
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
      401 => UnauthorizedException(
          message: message,
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
      403 => ForbiddenException(
          message: message,
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
      404 => NotFoundException(
          message: message,
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
      429 => RateLimitException(
          message: message,
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
      _ when statusCode != null && statusCode >= 500 => ServerException(
          message: message,
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
      _ => NetworkException(
          message: message,
          code: 'HTTP_$statusCode',
          statusCode: statusCode,
          responseData: data,
          originalError: e,
        ),
    };
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }
}

/// Logging interceptor.
class _LoggingInterceptor extends Interceptor {
  final KiroLogger _logger;

  _LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.logRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      body: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.logResponse(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      statusCode: response.statusCode ?? 0,
      body: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error(
      'Request failed: ${err.requestOptions.uri}',
      error: err,
      data: {
        'statusCode': err.response?.statusCode,
        'message': err.message,
      },
    );
    handler.next(err);
  }
}

/// Error handling interceptor.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can add global error handling here
    // For example, handling token expiration
    handler.next(err);
  }
}

