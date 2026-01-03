/// Wallet remote data source.
library;

import 'package:dio/dio.dart';

/// Remote data source for wallet operations.
abstract class WalletRemoteDataSource {
  /// Get wallet balance.
  Future<Response<Map<String, dynamic>>> getWallet();

  /// Add money to wallet.
  Future<Response<Map<String, dynamic>>> addMoney(Map<String, dynamic> data);

  /// Withdraw money from wallet.
  Future<Response<Map<String, dynamic>>> withdrawMoney(
    Map<String, dynamic> data,
  );

  /// Transfer money.
  Future<Response<Map<String, dynamic>>> transferMoney(
    Map<String, dynamic> data,
  );

  /// Get transactions.
  Future<Response<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  });
}

/// Implementation of wallet remote data source.
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio _dio;

  WalletRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  Future<Response<Map<String, dynamic>>> getWallet() async {
    return await _dio.get<Map<String, dynamic>>(
      '/wallet',
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> addMoney(
    Map<String, dynamic> data,
  ) async {
    return await _dio.post<Map<String, dynamic>>(
      '/wallet/add-money',
      data: data,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> withdrawMoney(
    Map<String, dynamic> data,
  ) async {
    return await _dio.post<Map<String, dynamic>>(
      '/wallet/withdraw',
      data: data,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> transferMoney(
    Map<String, dynamic> data,
  ) async {
    return await _dio.post<Map<String, dynamic>>(
      '/wallet/transfer',
      data: data,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }
    if (type != null) {
      queryParams['type'] = type;
    }

    return await _dio.get<Map<String, dynamic>>(
      '/wallet/transactions',
      queryParameters: queryParams,
    );
  }
}
