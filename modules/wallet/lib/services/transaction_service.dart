/// Transaction service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/transaction.dart';

/// Service for transaction operations.
class TransactionService {
  final DioClient _dioClient;

  TransactionService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get transaction history.
  Future<Result<List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    TransactionType? type,
    TransactionStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;
      if (type != null) queryParams['type'] = type.name;
      if (status != null) queryParams['status'] = status.name;

      final response = await _dioClient.get<Map<String, dynamic>>(
        '/wallet/transactions',
        queryParameters: queryParams,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final transactions = (data['transactions'] as List)
              .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.success(transactions);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get transactions: $e'),
      );
    }
  }

  /// Get transaction by ID.
  Future<Result<Transaction>> getTransaction(String transactionId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/wallet/transactions/$transactionId',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final transaction = Transaction.fromJson(
            data['transaction'] as Map<String, dynamic>,
          );
          return Result.success(transaction);
        },
        failure: (error, statusCode) {
          return Result.failure(
            Failure.network(
              message: error.message,
              statusCode: statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get transaction: $e'),
      );
    }
  }
}

