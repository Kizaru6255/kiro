/// Payment service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/payment.dart';

/// Service for payment operations.
class PaymentService {
  final DioClient _dioClient;

  PaymentService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Create payment order.
  Future<Result<Payment>> createPayment({
    required double amount,
    required String currency,
    String? description,
    String? orderId,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/payments/create',
        data: {
          'amount': amount,
          'currency': currency,
          if (description != null) 'description': description,
          if (orderId != null) 'order_id': orderId,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final payment = Payment.fromJson(
            data['payment'] as Map<String, dynamic>,
          );
          return Result.success(payment);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to create payment: $e'),
      );
    }
  }

  /// Verify payment.
  Future<Result<Payment>> verifyPayment({
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/payments/verify',
        data: {
          'payment_id': paymentId,
          'signature': signature,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final payment = Payment.fromJson(
            data['payment'] as Map<String, dynamic>,
          );
          return Result.success(payment);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to verify payment: $e'),
      );
    }
  }

  /// Get payment status.
  Future<Result<Payment>> getPaymentStatus(String paymentId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/payments/$paymentId',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final payment = Payment.fromJson(
            data['payment'] as Map<String, dynamic>,
          );
          return Result.success(payment);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get payment status: $e'),
      );
    }
  }
}

