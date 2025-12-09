/// Payment provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/payment.dart';
import '../services/payment_service.dart';

/// Payment service provider.
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

/// Payment notifier.
class PaymentNotifier extends StateNotifier<AsyncValue<Payment?>> {
  final PaymentService _paymentService;

  PaymentNotifier(this._paymentService) : super(const AsyncValue.data(null));

  /// Create payment.
  Future<void> createPayment({
    required double amount,
    required String currency,
    String? description,
    String? orderId,
  }) async {
    state = const AsyncValue.loading();
    final result = await _paymentService.createPayment(
      amount: amount,
      currency: currency,
      description: description,
      orderId: orderId,
    );

    result.fold(
      onSuccess: (payment) => state = AsyncValue.data(payment),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Verify payment.
  Future<void> verifyPayment({
    required String paymentId,
    required String signature,
  }) async {
    state = const AsyncValue.loading();
    final result = await _paymentService.verifyPayment(
      paymentId: paymentId,
      signature: signature,
    );

    result.fold(
      onSuccess: (payment) => state = AsyncValue.data(payment),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }
}

/// Payment notifier provider.
final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, AsyncValue<Payment?>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return PaymentNotifier(service);
});

