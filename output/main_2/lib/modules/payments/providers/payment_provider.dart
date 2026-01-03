/// Payment provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/payment.dart';
/// Payment service provider.
/// Payment notifier.
class PaymentNotifier extends StateNotifier<AsyncValue<Payment?>> {  PaymentNotifier() : super(const AsyncValue.data(null));

  /// Create payment.
  Future<void> createPayment({
    required double amount,
    required String currency,
    String? description,
    String? orderId,
  }) async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }

  /// Verify payment.
  Future<void> verifyPayment({
    required String paymentId,
    required String signature,
  }) async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }
}

/// Payment notifier provider.
final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, AsyncValue<Payment?>>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});