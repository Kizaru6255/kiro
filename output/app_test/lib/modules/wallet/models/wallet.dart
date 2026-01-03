/// Wallet model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/wallet_entity.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

/// Wallet model representing user's digital wallet.
@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String userId,
    required double balance,
    @Default('INR') String currency,
    @Default(false) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

/// Wallet extensions.
extension WalletExtension on Wallet {
  /// Formatted balance string.
  String get formattedBalance {
    return '${currency} ${balance.toStringAsFixed(2)}';
  }

  /// Check if wallet has sufficient balance.
  bool hasSufficientBalance(double amount) {
    return balance >= amount;
  }

  /// Check if wallet is empty.
  bool get isEmpty => balance == 0;

  /// Check if wallet is low on balance.
  bool isLowBalance([double threshold = 100]) {
    return balance < threshold;
  }

  /// Convert to WalletEntity.
  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      userId: userId,
      balance: balance,
      currency: currency,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}

