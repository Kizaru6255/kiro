/// Wallet state model (presentation layer).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/transaction_entity.dart';

part 'wallet_state.freezed.dart';

/// Wallet state.
@freezed
class WalletState with _$WalletState {
  /// Initial state.
  const factory WalletState.initial() = _Initial;

  /// Loading state.
  const factory WalletState.loading() = _Loading;

  /// Loaded state with wallet.
  const factory WalletState.loaded(WalletEntity wallet) = _Loaded;

  /// Error state.
  const factory WalletState.error(String message) = _Error;
}

/// Transaction state.
@freezed
class TransactionState with _$TransactionState {
  /// Initial state.
  const factory TransactionState.initial() = _TransactionInitial;

  /// Loading state.
  const factory TransactionState.loading() = _TransactionLoading;

  /// Loaded state with transactions.
  const factory TransactionState.loaded(List<TransactionEntity> transactions) =
      _TransactionLoaded;

  /// Error state.
  const factory TransactionState.error(String message) = _TransactionError;
}


