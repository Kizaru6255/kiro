/// Wallet provider (presentation layer).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/add_money_usecase.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../models/wallet_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// Remote data source provider.
final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSourceImpl();
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// WalletRepository provider.
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    remoteDataSource: ref.watch(walletRemoteDataSourceProvider),
  );
});

// ============================================================================
// Use Cases (Riverpod Providers)
// ============================================================================

/// Get wallet use case provider.
final getWalletUseCaseProvider = Provider<GetWalletUseCase>((ref) {
  return GetWalletUseCase(ref.watch(walletRepositoryProvider));
});

/// Add money use case provider.
final addMoneyUseCaseProvider = Provider<AddMoneyUseCase>((ref) {
  return AddMoneyUseCase(ref.watch(walletRepositoryProvider));
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// Wallet notifier.
class WalletNotifier extends StateNotifier<WalletState> {
  final GetWalletUseCase _getWalletUseCase;
  final AddMoneyUseCase _addMoneyUseCase;
  final WalletRepository _repository;

  WalletNotifier({
    required GetWalletUseCase getWalletUseCase,
    required AddMoneyUseCase addMoneyUseCase,
    required WalletRepository repository,
  })  : _getWalletUseCase = getWalletUseCase,
        _addMoneyUseCase = addMoneyUseCase,
        _repository = repository,
        super(const WalletState.initial()) {
    loadWallet();
  }

  /// Load wallet.
  Future<void> loadWallet() async {
    state = const WalletState.loading();

    final result = await _getWalletUseCase();

    result.fold(
      onSuccess: (wallet) => state = WalletState.loaded(wallet),
      onFailure: (failure) => state = WalletState.error(failure.message),
    );
  }

  /// Add money.
  Future<void> addMoney({
    required double amount,
    String? paymentMethodId,
  }) async {
    state = const WalletState.loading();

    final result = await _addMoneyUseCase(
      amount: amount,
      paymentMethodId: paymentMethodId,
    );

    result.fold(
      onSuccess: (wallet) => state = WalletState.loaded(wallet),
      onFailure: (failure) => state = WalletState.error(failure.message),
    );
  }

  /// Transfer money.
  Future<void> transferMoney({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    state = const WalletState.loading();

    final result = await _repository.transferMoney(
      recipientId: recipientId,
      amount: amount,
      description: description,
    );

    result.fold(
      onSuccess: (wallet) => state = WalletState.loaded(wallet),
      onFailure: (failure) => state = WalletState.error(failure.message),
    );
  }

  /// Refresh wallet.
  Future<void> refresh() => loadWallet();
}

/// Wallet state provider.
final walletProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(
    getWalletUseCase: ref.watch(getWalletUseCaseProvider),
    addMoneyUseCase: ref.watch(addMoneyUseCaseProvider),
    repository: ref.watch(walletRepositoryProvider),
  );
});

/// Transaction provider.
final transactionsProvider =
    FutureProvider.family<List<TransactionEntity>, Map<String, dynamic>>(
  (ref, filters) async {
    final repository = ref.watch(walletRepositoryProvider);
    final result = await repository.getTransactions(
      startDate: filters['startDate'] as DateTime?,
      endDate: filters['endDate'] as DateTime?,
      type: filters['type'] as TransactionType?,
    );
    return result.fold(
      onSuccess: (transactions) => transactions,
      onFailure: (failure) => throw Exception(failure.message),
    );
  },
);

