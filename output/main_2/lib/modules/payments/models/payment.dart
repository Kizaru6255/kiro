/// Payment model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Payment status.
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  cancelled,
}

/// Payment method type.
enum PaymentMethodType {
  card,
  upi,
  netbanking,
  wallet,
  cash,
}

/// Payment model.
@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required double amount,
    @Default('INR') String currency,
    required PaymentMethodType method,
    @Default(PaymentStatus.pending) PaymentStatus status,
    String? transactionId,
    String? gateway,
    String? description,
    DateTime? completedAt,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

/// Payment extensions.
extension PaymentExtension on Payment {
  /// Formatted amount.
  String get formattedAmount => '${currency} ${amount.toStringAsFixed(2)}';

  /// Check if payment is successful.
  bool get isSuccess => status == PaymentStatus.completed;

  /// Check if payment failed.
  bool get isFailed => status == PaymentStatus.failed;
}

