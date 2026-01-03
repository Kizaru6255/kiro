/// Transaction provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
/// Transaction service provider.
/// Transactions list provider.
final transactionsProvider = FutureProvider.family<List<Transaction>, Map<String, dynamic>>((ref, params) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

final transactionProvider = FutureProvider.family<Transaction, String>((ref, transactionId) async {
  throw UnimplementedError('Service removed - implement repository provider');