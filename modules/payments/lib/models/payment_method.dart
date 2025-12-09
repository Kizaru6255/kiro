/// Payment method model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

/// Payment method model.
@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required PaymentMethodType type,
    required String name,
    String? iconUrl,
    @Default(true) bool isEnabled,
    Map<String, dynamic>? metadata,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

