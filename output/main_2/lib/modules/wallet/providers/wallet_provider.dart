/// Wallet provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wallet.dart';
/// Wallet service provider.
/// Wallet state provider.
final walletProvider = FutureProvider<Wallet>((ref) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

/// Wallet notifier for state updates.
class $1 extends StateNotifier<AsyncValue<Wallet>> {  WalletNotifier() : super(const AsyncValue.loading()) {
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    state = const AsyncValue.loading();
    throw UnimplementedError('Service call removed');
    );
  }

  /// Add money to wallet.
  Future<void> addMoney({
    required double amount,
    String? paymentMethodId,
  }) async {
    throw UnimplementedError('Service call removed');
    );
  }

  /// Withdraw money.
  Future<void> withdrawMoney({
    required double amount,
    required String bankAccountId,
  }) async {
    throw UnimplementedError('Service call removed');
    );
  }

  /// Transfer money.
  Future<void> transferMoney({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    throw UnimplementedError('Service call removed');
    );
  }

  /// Refresh wallet.
  Future<void> refresh() => _loadWallet();
}

/// Wallet notifier provider.
final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<Wallet>>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});