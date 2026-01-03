/// Payment repository interface (domain layer).
library;

import '../entities/payment_entity.dart';
import '../entities/payment_method_entity.dart';
import '../../core/errors/errors.dart';

/// Payment repository interface.
abstract class PaymentRepository {
  /// Process payment.
  Future<Result<PaymentEntity>> processPayment({
    required String orderId,
    required double amount,
    required PaymentMethodType method,
    String? paymentMethodId,
    String? description,
  });

  /// Get payment by ID.
  Future<Result<PaymentEntity>> getPayment(String paymentId);

  /// Get payment methods.
  Future<Result<List<PaymentMethodEntity>>> getPaymentMethods();

  /// Refund payment.
  Future<Result<PaymentEntity>> refundPayment(String paymentId, String? reason);
}


