/// Transaction entity (domain layer).
library;

/// Transaction type.
enum TransactionType {
  credit,
  debit,
  transfer,
  refund,
}

/// Transaction status.
enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

/// Transaction entity.
class TransactionEntity {
  final String id;
  final String walletId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final String? description;
  final String? referenceId;
  final String? recipientId;
  final String? senderId;
  final DateTime? completedAt;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const TransactionEntity({
    required this.id,
    required this.walletId,
    required this.type,
    required this.status,
    required this.amount,
    this.currency = 'INR',
    this.description,
    this.referenceId,
    this.recipientId,
    this.senderId,
    this.completedAt,
    required this.createdAt,
    this.metadata,
  });

  /// Formatted amount string.
  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';

  /// Check if transaction is completed.
  bool get isCompleted => status == TransactionStatus.completed;

  /// Check if transaction is pending.
  bool get isPending => status == TransactionStatus.pending;

  /// Check if transaction failed.
  bool get isFailed => status == TransactionStatus.failed;

  /// Transaction title based on type.
  String get title {
    return switch (type) {
      TransactionType.credit => 'Credit',
      TransactionType.debit => 'Debit',
      TransactionType.transfer => 'Transfer',
      TransactionType.refund => 'Refund',
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

