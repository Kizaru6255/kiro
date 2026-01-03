/// Get wallet use case (domain layer).
library;

import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for getting wallet.
class GetWalletUseCase {
  final WalletRepository _repository;

  GetWalletUseCase(this._repository);

  /// Execute get wallet.
  Future<Result<WalletEntity>> call() async {
    return await _repository.getWallet();
  }
}


