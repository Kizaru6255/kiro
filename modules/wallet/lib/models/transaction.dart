/// Transaction model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

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

/// Transaction model.
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String walletId,
    required TransactionType type,
    required TransactionStatus status,
    required double amount,
    @Default('INR') String currency,
    String? description,
    String? referenceId,
    String? recipientId,
    String? senderId,
    DateTime? completedAt,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

/// Transaction extensions.
extension TransactionExtension on Transaction {
  /// Formatted amount string.
  String get formattedAmount {
    final sign = type == TransactionType.credit ? '+' : '-';
    return '$sign${currency} ${amount.toStringAsFixed(2)}';
  }

  /// Check if transaction is successful.
  bool get isSuccess => status == TransactionStatus.completed;

  /// Check if transaction is pending.
  bool get isPending => status == TransactionStatus.pending;

  /// Check if transaction failed.
  bool get isFailed => status == TransactionStatus.failed;

  /// Get transaction title.
  String get title {
    return switch (type) {
      TransactionType.credit => 'Money Added',
      TransactionType.debit => 'Payment',
      TransactionType.transfer => 'Transfer',
      TransactionType.refund => 'Refund',
    };
  }
}

