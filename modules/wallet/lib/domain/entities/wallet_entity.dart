/// Wallet entity (domain layer).
library;

/// Wallet entity.
class WalletEntity {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    this.currency = 'INR',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  /// Formatted balance string.
  String get formattedBalance => '$currency ${balance.toStringAsFixed(2)}';

  /// Check if wallet has sufficient balance.
  bool hasSufficientBalance(double amount) => balance >= amount;

  /// Check if wallet is empty.
  bool get isEmpty => balance == 0;

  /// Check if wallet is low on balance.
  bool isLowBalance([double threshold = 100]) => balance < threshold;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


