/// API response wrapper types.
///
/// Provides a type-safe way to handle API responses using
/// sealed classes for success and failure cases.
library;

import '../errors/errors.dart';

/// Represents the result of an API call.
///
/// Either [ApiSuccess] with data or [ApiFailure] with error info.
///
/// Example:
/// ```dart
/// final response = await apiService.get<User>('/user/123');
///
/// response.when(
///   success: (data, statusCode) => print('User: ${data.name}'),
///   failure: (error, statusCode) => print('Error: ${error.message}'),
/// );
/// ```
sealed class ApiResponse<T> {
  const ApiResponse();

  /// Create a successful response.
  const factory ApiResponse.success({
    required T data,
    required int statusCode,
    Map<String, dynamic>? meta,
    Map<String, List<String>>? headers,
  }) = ApiSuccess<T>;

  /// Create a failure response.
  const factory ApiResponse.failure({
    required KiroException exception,
    int? statusCode,
    String? rawBody,
    Map<String, List<String>>? headers,
  }) = ApiFailure<T>;

  /// Whether this is a success response.
  bool get isSuccess => this is ApiSuccess<T>;

  /// Whether this is a failure response.
  bool get isFailure => this is ApiFailure<T>;

  /// Get data if success, null otherwise.
  T? get dataOrNull => switch (this) {
        ApiSuccess<T>(:final data) => data,
        ApiFailure<T>() => null,
      };

  /// Get exception if failure, null otherwise.
  KiroException? get exceptionOrNull => switch (this) {
        ApiSuccess<T>() => null,
        ApiFailure<T>(:final exception) => exception,
      };

  /// Get status code.
  int? get statusCode => switch (this) {
        ApiSuccess<T>(:final statusCode) => statusCode,
        ApiFailure<T>(:final statusCode) => statusCode,
      };

  /// Get data or throw exception.
  T get dataOrThrow => switch (this) {
        ApiSuccess<T>(:final data) => data,
        ApiFailure<T>(:final exception) => throw exception,
      };

  /// Pattern match on success/failure.
  R when<R>({
    required R Function(T data, int statusCode) success,
    required R Function(KiroException exception, int? statusCode) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data, :final statusCode) => success(data, statusCode),
      ApiFailure<T>(:final exception, :final statusCode) =>
        failure(exception, statusCode),
    };
  }

  /// Pattern match with optional cases.
  R maybeWhen<R>({
    R Function(T data, int statusCode)? success,
    R Function(KiroException exception, int? statusCode)? failure,
    required R Function() orElse,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data, :final statusCode) =>
        success?.call(data, statusCode) ?? orElse(),
      ApiFailure<T>(:final exception, :final statusCode) =>
        failure?.call(exception, statusCode) ?? orElse(),
    };
  }

  /// Transform success data.
  ApiResponse<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      ApiSuccess<T>(:final data, :final statusCode, :final meta, :final headers) =>
        ApiResponse.success(
          data: transform(data),
          statusCode: statusCode,
          meta: meta,
          headers: headers,
        ),
      ApiFailure<T>(:final exception, :final statusCode, :final rawBody, :final headers) =>
        ApiResponse.failure(
          exception: exception,
          statusCode: statusCode,
          rawBody: rawBody,
          headers: headers,
        ),
    };
  }

  /// Transform success with a function that returns ApiResponse.
  ApiResponse<R> flatMap<R>(ApiResponse<R> Function(T data) transform) {
    return switch (this) {
      ApiSuccess<T>(:final data) => transform(data),
      ApiFailure<T>(:final exception, :final statusCode, :final rawBody, :final headers) =>
        ApiResponse.failure(
          exception: exception,
          statusCode: statusCode,
          rawBody: rawBody,
          headers: headers,
        ),
    };
  }

  /// Convert to Result type.
  Result<T> toResult() {
    return switch (this) {
      ApiSuccess<T>(:final data) => Result.success(data),
      ApiFailure<T>(:final exception) => Result.failure(Failure.fromException(exception)),
    };
  }
}

/// Successful API response.
final class ApiSuccess<T> extends ApiResponse<T> {
  /// Response data.
  final T data;

  /// HTTP status code.
  @override
  final int statusCode;

  /// Optional metadata from response.
  final Map<String, dynamic>? meta;

  /// Response headers.
  final Map<String, List<String>>? headers;

  const ApiSuccess({
    required this.data,
    required this.statusCode,
    this.meta,
    this.headers,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiSuccess<T> &&
        other.data == data &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => Object.hash(data, statusCode);

  @override
  String toString() => 'ApiSuccess(statusCode: $statusCode, data: $data)';
}

/// Failed API response.
final class ApiFailure<T> extends ApiResponse<T> {
  /// Exception describing the failure.
  final KiroException exception;

  /// HTTP status code (may be null for network errors).
  @override
  final int? statusCode;

  /// Raw response body (for debugging).
  final String? rawBody;

  /// Response headers.
  final Map<String, List<String>>? headers;

  const ApiFailure({
    required this.exception,
    this.statusCode,
    this.rawBody,
    this.headers,
  });

  /// Error message shorthand.
  String get message => exception.message;

  /// Error code shorthand.
  String? get code => exception.code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiFailure<T> &&
        other.exception == exception &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => Object.hash(exception, statusCode);

  @override
  String toString() =>
      'ApiFailure(statusCode: $statusCode, message: ${exception.message})';
}

/// Extension for Future<ApiResponse>.
extension FutureApiResponseExtension<T> on Future<ApiResponse<T>> {
  /// Pattern match asynchronously.
  Future<R> when<R>({
    required R Function(T data, int statusCode) success,
    required R Function(KiroException exception, int? statusCode) failure,
  }) async {
    final response = await this;
    return response.when(success: success, failure: failure);
  }

  /// Transform success data asynchronously.
  Future<ApiResponse<R>> map<R>(R Function(T data) transform) async {
    final response = await this;
    return response.map(transform);
  }

  /// Get data or null asynchronously.
  Future<T?> get dataOrNull async {
    final response = await this;
    return response.dataOrNull;
  }

  /// Get data or throw asynchronously.
  Future<T> get dataOrThrow async {
    final response = await this;
    return response.dataOrThrow;
  }
}

/// Paginated response wrapper.
class PaginatedResponse<T> {
  /// List of items.
  final List<T> items;

  /// Current page number.
  final int page;

  /// Items per page.
  final int perPage;

  /// Total number of items.
  final int total;

  /// Total number of pages.
  final int totalPages;

  /// Whether there is a next page.
  final bool hasNextPage;

  /// Whether there is a previous page.
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Create from API response JSON.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson, {
    String itemsKey = 'data',
    String pageKey = 'page',
    String perPageKey = 'per_page',
    String totalKey = 'total',
    String totalPagesKey = 'total_pages',
  }) {
    final itemsList = json[itemsKey] as List? ?? [];
    final items = itemsList
        .map((item) => itemFromJson(item as Map<String, dynamic>))
        .toList();

    final page = json[pageKey] as int? ?? 1;
    final perPage = json[perPageKey] as int? ?? items.length;
    final total = json[totalKey] as int? ?? items.length;
    final totalPages = json[totalPagesKey] as int? ??
        (total / perPage).ceil();

    return PaginatedResponse(
      items: items,
      page: page,
      perPage: perPage,
      total: total,
      totalPages: totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    );
  }

  /// Map items to a different type.
  PaginatedResponse<R> map<R>(R Function(T) transform) {
    return PaginatedResponse<R>(
      items: items.map(transform).toList(),
      page: page,
      perPage: perPage,
      total: total,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }

  @override
  String toString() =>
      'PaginatedResponse(page: $page/$totalPages, items: ${items.length}/$total)';
}

