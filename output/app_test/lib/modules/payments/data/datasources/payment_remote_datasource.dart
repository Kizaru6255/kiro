/// Payment remote data source.
library;

import 'package:dio/dio.dart';

/// Remote data source for payment operations.
abstract class PaymentRemoteDataSource {
  /// Process payment.
  Future<Response<Map<String, dynamic>>> processPayment(
    Map<String, dynamic> data,
  );

  /// Get payment by ID.
  Future<Response<Map<String, dynamic>>> getPayment(String paymentId);

  /// Get payment methods.
  Future<Response<Map<String, dynamic>>> getPaymentMethods();

  /// Refund payment.
  Future<Response<Map<String, dynamic>>> refundPayment(
    String paymentId,
    String? reason,
  );
}

/// Implementation of payment remote data source.
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<Response<Map<String, dynamic>>> processPayment(
    Map<String, dynamic> data,
  ) async {
    return await _dio.post<Map<String, dynamic>>(
      '/payments/process',
      data: data,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> getPayment(String paymentId) async {
    return await _dio.get<Map<String, dynamic>>(
      '/payments/$paymentId',
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> getPaymentMethods() async {
    return await _dio.get<Map<String, dynamic>>(
      '/payments/methods',
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> refundPayment(
    String paymentId,
    String? reason,
  ) async {
    return await _dio.post<Map<String, dynamic>>(
      '/payments/$paymentId/refund',
      data: {'reason': reason},
    );
  }
}
