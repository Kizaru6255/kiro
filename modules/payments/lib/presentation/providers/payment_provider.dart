/// Payment provider (presentation layer).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/datasources/payment_remote_datasource.dart';
import '../models/payment_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// Remote data source provider.
final paymentRemoteDataSourceProvider =
    Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl();
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// PaymentRepository provider.
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    remoteDataSource: ref.watch(paymentRemoteDataSourceProvider),
  );
});

// ============================================================================
// Use Cases (Riverpod Providers)
// ============================================================================

/// Process payment use case provider.
final processPaymentUseCaseProvider = Provider<ProcessPaymentUseCase>((ref) {
  return ProcessPaymentUseCase(ref.watch(paymentRepositoryProvider));
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// PaymentEntitynotifier.
class PaymentNotifier extends StateNotifier<PaymentState> {
  final ProcessPaymentUseCase _processPaymentUseCase;

  PaymentNotifier({
    required ProcessPaymentUseCase processPaymentUseCase,
  })  : _processPaymentUseCase = processPaymentUseCase,
        super(const PaymentState.initial());

  /// Process payment.
  Future<void> processPayment({
    required String orderId,
    required double amount,
    required PaymentMethodType method,
    String? paymentMethodId,
    String? description,
  }) async {
    state = const PaymentState.processing();

    final result = await _processPaymentUseCase(
      orderId: orderId,
      amount: amount,
      method: method,
      paymentMethodId: paymentMethodId,
      description: description,
    );

    result.fold(
      onSuccess: (payment) => state = PaymentState.completed(payment),
      onFailure: (failure) => state = PaymentState.error(failure.message),
    );
  }
}

/// Payment state provider.
final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(
    processPaymentUseCase: ref.watch(processPaymentUseCaseProvider),
  );
});

/// PaymentEntitymethods provider.
final paymentMethodsProvider =
    FutureProvider<List<PaymentMethodEntity>>((ref) async {
  final repository = ref.watch(paymentRepositoryProvider);
  final result = await repository.getPaymentMethods();
  return result.fold(
    onSuccess: (methods) => methods,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

