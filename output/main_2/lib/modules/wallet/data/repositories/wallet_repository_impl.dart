/// Wallet repository implementation (data layer).
library;

import 'package:dio/dio.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../../../core/errors/errors.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../models/wallet_dto.dart';
import '../models/transaction_dto.dart';

/// Implementation of wallet repository.
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<WalletEntity>> getWallet() async {
    try {
      final response = await _remoteDataSource.getWallet();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final dto = WalletDto.fromJson(
          data['wallet'] as Map<String, dynamic>,
        );
        return Result.success(dto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get wallet: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get wallet',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get wallet: $e'),
      );
    }
  }

  @override
  Future<Result<WalletEntity>> addMoney({
    required double amount,
    String? paymentMethodId,
  }) async {
    try {
      final data = {
        'amount': amount,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      };

      final response = await _remoteDataSource.addMoney(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final dto = WalletDto.fromJson(
            responseData['wallet'] as Map<String, dynamic>,
          );
          return Result.success(dto.toEntity());
        }
      }
      return Result.failure(
        Failure.network(
          message: 'Failed to add money: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to add money',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to add money: $e'),
      );
    }
  }

  @override
  Future<Result<WalletEntity>> withdrawMoney({
    required double amount,
    required String bankAccountId,
  }) async {
    try {
      final data = {
        'amount': amount,
        'bank_account_id': bankAccountId,
      };

      final response = await _remoteDataSource.withdrawMoney(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final dto = WalletDto.fromJson(
            responseData['wallet'] as Map<String, dynamic>,
          );
          return Result.success(dto.toEntity());
        }
      }
      return Result.failure(
        Failure.network(
          message: 'Failed to withdraw money: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to withdraw money',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to withdraw money: $e'),
      );
    }
  }

  @override
  Future<Result<WalletEntity>> transferMoney({
    required String recipientId,
    required double amount,
    String? description,
  }) async {
    try {
      final data = {
        'recipient_id': recipientId,
        'amount': amount,
        if (description != null) 'description': description,
      };

      final response = await _remoteDataSource.transferMoney(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final dto = WalletDto.fromJson(
            responseData['wallet'] as Map<String, dynamic>,
          );
          return Result.success(dto.toEntity());
        }
      }
      return Result.failure(
        Failure.network(
          message: 'Failed to transfer money: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to transfer money',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to transfer money: $e'),
      );
    }
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) async {
    try {
      final response = await _remoteDataSource.getTransactions(
        startDate: startDate,
        endDate: endDate,
        type: type?.name,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final transactions = (data['transactions'] as List)
            .map((json) =>
                TransactionDto.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();
        return Result.success(transactions);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get transactions: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get transactions',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get transactions: $e'),
      );
    }
  }
}
