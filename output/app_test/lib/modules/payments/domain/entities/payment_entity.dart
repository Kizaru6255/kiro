/// Payment entity (domain layer).
library;

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

/// Payment entity.
class PaymentEntity {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethodType method;
  final PaymentStatus status;
  final String? transactionId;
  final String? gateway;
  final String? description;
  final DateTime? completedAt;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const PaymentEntity({
    required this.id,
    required this.orderId,
    required this.amount,
    this.currency = 'INR',
    required this.method,
    this.status = PaymentStatus.pending,
    this.transactionId,
    this.gateway,
    this.description,
    this.completedAt,
    required this.createdAt,
    this.metadata,
  });

  /// Check if payment is completed.
  bool get isCompleted => status == PaymentStatus.completed;

  /// Check if payment is pending.
  bool get isPending => status == PaymentStatus.pending;

  /// Check if payment failed.
  bool get isFailed => status == PaymentStatus.failed;

  /// Formatted amount string.
  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


