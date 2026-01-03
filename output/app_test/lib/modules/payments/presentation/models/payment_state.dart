/// Payment state model (presentation layer).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_method_entity.dart';

part 'payment_state.freezed.dart';

/// Payment state.
@freezed
class PaymentState with _$PaymentState {
  /// Initial state.
  const factory PaymentState.initial() = _Initial;

  /// Processing state.
  const factory PaymentState.processing() = _Processing;

  /// Completed state with payment.
  const factory PaymentState.completed(PaymentEntity payment) = _Completed;

  /// Error state.
  const factory PaymentState.error(String message) = _Error;
}

/// Payment methods state.
@freezed
class PaymentMethodsState with _$PaymentMethodsState {
  /// Initial state.
  const factory PaymentMethodsState.initial() = _PaymentMethodsInitial;

  /// Loading state.
  const factory PaymentMethodsState.loading() = _PaymentMethodsLoading;

  /// Loaded state with payment methods.
  const factory PaymentMethodsState.loaded(
    List<PaymentMethodEntity> methods,
  ) = _PaymentMethodsLoaded;

  /// Error state.
  const factory PaymentMethodsState.error(String message) =
      _PaymentMethodsError;
}


