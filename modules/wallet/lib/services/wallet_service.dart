/// Wallet service.
library;

import 'package:kiro_core/kiro_core.dart';

import '../models/wallet.dart';

/// Service for wallet operations.
class WalletService {
  final DioClient _dioClient;

  WalletService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get wallet balance.
  Future<Result<Wallet>> getWallet() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/wallet',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final wallet = Wallet.fromJson(data['wallet'] as Map<String, dynamic>);
          return Result.success(wallet);
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
        Failure.network(message: 'Failed to get wallet: $e'),
      );
    }
  }

  /// Add money to wallet.
  Future<Result<Wallet>> addMoney({
    required double amount,
    String? paymentMethodId,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/wallet/add-money',
        data: {
          'amount': amount,
          if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final wallet = Wallet.fromJson(data['wallet'] as Map<String, dynamic>);
          return Result.success(wallet);
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
        Failure.network(message: 'Failed to add money: $e'),
      );
    }
  }

  /// Withdraw money from wallet.
  Future<Result<Wallet>> withdrawMoney({
    required double amount,
    required String bankAccountId,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/wallet/withdraw',
        data: {
          'amount': amount,
          'bank_account_id': bankAccountId,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final wallet = Wallet.fromJson(data['wallet'] as Map<String, dynamic>);
          return Result.success(wallet);
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
        Failure.network(message: 'Failed to withdraw money: $e'),
      );
    }
  }

  /// Transfer money to another user.
  Future<Result<Wallet>> transferMoney({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/wallet/transfer',
        data: {
          'recipient_id': recipientId,
          'amount': amount,
          if (description != null) 'description': description,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return response.when(
        success: (data, statusCode) {
          final wallet = Wallet.fromJson(data['wallet'] as Map<String, dynamic>);
          return Result.success(wallet);
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
        Failure.network(message: 'Failed to transfer money: $e'),
      );
    }
  }
}

