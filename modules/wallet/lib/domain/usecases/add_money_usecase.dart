/// Add money use case (domain layer).
library;

import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for adding money to wallet.
class AddMoneyUseCase {
  final WalletRepository _repository;

  AddMoneyUseCase(this._repository);

  /// Execute add money.
  Future<Result<WalletEntity>> call({
    required double amount,
    String? paymentMethodId,
  }) async {
    // Domain validation
    if (amount <= 0) {
      return Result.failure(
        Failure.validation(message: 'Amount must be greater than zero'),
      );
    }

    return await _repository.addMoney(
      amount: amount,
      paymentMethodId: paymentMethodId,
    );
  }
}


