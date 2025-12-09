/// Transaction provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

/// Transaction service provider.
final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService();
});

/// Transactions list provider.
final transactionsProvider = FutureProvider.family<List<Transaction>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(transactionServiceProvider);
  final result = await service.getTransactions(
    limit: params['limit'] as int?,
    offset: params['offset'] as int?,
    type: params['type'] as TransactionType?,
    status: params['status'] as TransactionStatus?,
  );
  
  return result.fold(
    onSuccess: (transactions) => transactions,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

/// Single transaction provider.
final transactionProvider = FutureProvider.family<Transaction, String>((ref, transactionId) async {
  final service = ref.watch(transactionServiceProvider);
  final result = await service.getTransaction(transactionId);
  
  return result.fold(
    onSuccess: (transaction) => transaction,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

