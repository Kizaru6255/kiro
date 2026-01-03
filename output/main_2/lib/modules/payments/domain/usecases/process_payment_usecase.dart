/// Process payment use case (domain layer).
library;

import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';
import '../../../../core/errors/errors.dart';

/// Use case for processing payment.
class ProcessPaymentUseCase {
  final PaymentRepository _repository;

  ProcessPaymentUseCase(this._repository);

  /// Execute process payment.
  Future<Result<PaymentEntity>> call({
    required String orderId,
    required double amount,
    required PaymentMethodType method,
    String? paymentMethodId,
    String? description,
  }) async {
    // Domain validation
    if (orderId.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'Order ID cannot be empty'),
      );
    }

    if (amount <= 0) {
      return Result.failure(
        Failure.validation(message: 'Amount must be greater than zero'),
      );
    }

    return await _repository.processPayment(
      orderId: orderId,
      amount: amount,
      method: method,
      paymentMethodId: paymentMethodId,
      description: description,
    );
  }
}


