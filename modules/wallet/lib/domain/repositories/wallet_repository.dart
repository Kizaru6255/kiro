/// Wallet repository interface (domain layer).
library;

import '../entities/wallet_entity.dart';
import '../entities/transaction_entity.dart';
import '../../core/errors/errors.dart';

/// Wallet repository interface.
abstract class WalletRepository {
  /// Get wallet balance.
  Future<Result<WalletEntity>> getWallet();

  /// Add money to wallet.
  Future<Result<WalletEntity>> addMoney({
    required double amount,
    String? paymentMethodId,
  });

  /// Withdraw money from wallet.
  Future<Result<WalletEntity>> withdrawMoney({
    required double amount,
    required String bankAccountId,
  });

  /// Transfer money to another user.
  Future<Result<WalletEntity>> transferMoney({
    required String recipientId,
    required double amount,
    String? description,
  });

  /// Get transactions.
  Future<Result<List<TransactionEntity>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  });
}


