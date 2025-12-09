/// Wallet provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wallet.dart';
import '../services/wallet_service.dart';

/// Wallet service provider.
final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService();
});

/// Wallet state provider.
final walletProvider = FutureProvider<Wallet>((ref) async {
  final service = ref.watch(walletServiceProvider);
  final result = await service.getWallet();
  return result.fold(
    onSuccess: (wallet) => wallet,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Wallet notifier for state updates.
class WalletNotifier extends StateNotifier<AsyncValue<Wallet>> {
  final WalletService _walletService;

  WalletNotifier(this._walletService) : super(const AsyncValue.loading()) {
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    state = const AsyncValue.loading();
    final result = await _walletService.getWallet();
    result.fold(
      onSuccess: (wallet) => state = AsyncValue.data(wallet),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Add money to wallet.
  Future<void> addMoney({
    required double amount,
    String? paymentMethodId,
  }) async {
    final result = await _walletService.addMoney(
      amount: amount,
      paymentMethodId: paymentMethodId,
    );

    result.fold(
      onSuccess: (wallet) => state = AsyncValue.data(wallet),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Withdraw money.
  Future<void> withdrawMoney({
    required double amount,
    required String bankAccountId,
  }) async {
    final result = await _walletService.withdrawMoney(
      amount: amount,
      bankAccountId: bankAccountId,
    );

    result.fold(
      onSuccess: (wallet) => state = AsyncValue.data(wallet),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Transfer money.
  Future<void> transferMoney({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    final result = await _walletService.transferMoney(
      recipientId: recipientId,
      amount: amount,
      description: description,
    );

    result.fold(
      onSuccess: (wallet) => state = AsyncValue.data(wallet),
      onFailure: (failure) => state = AsyncValue.error(
        Exception(failure.message),
        StackTrace.current,
      ),
    );
  }

  /// Refresh wallet.
  Future<void> refresh() => _loadWallet();
}

/// Wallet notifier provider.
final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<Wallet>>((ref) {
  final service = ref.watch(walletServiceProvider);
  return WalletNotifier(service);
});

