/// Payment repository implementation (data layer).
library;

import 'package:dio/dio.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../../core/errors/errors.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_dto.dart';
import '../models/payment_method_dto.dart';

/// Implementation of payment repository.
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl({
    required PaymentRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<PaymentEntity>> processPayment({
    required String orderId,
    required double amount,
    required PaymentMethodType method,
    String? paymentMethodId,
    String? description,
  }) async {
    try {
      final data = {
        'order_id': orderId,
        'amount': amount,
        'method': method.name,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
        if (description != null) 'description': description,
      };

      final response = await _remoteDataSource.processPayment(data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final dto = PaymentDto.fromJson(
            responseData['payment'] as Map<String, dynamic>,
          );
          return Result.success(dto.toEntity());
        }
      }
      return Result.failure(
        Failure.network(
          message: 'Failed to process payment: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to process payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to process payment: $e'),
      );
    }
  }

  @override
  Future<Result<PaymentEntity>> getPayment(String paymentId) async {
    try {
      final response = await _remoteDataSource.getPayment(paymentId);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final dto = PaymentDto.fromJson(
          data['payment'] as Map<String, dynamic>,
        );
        return Result.success(dto.toEntity());
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get payment: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get payment: $e'),
      );
    }
  }

  @override
  Future<Result<List<PaymentMethodEntity>>> getPaymentMethods() async {
    try {
      final response = await _remoteDataSource.getPaymentMethods();

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final methods = (data['payment_methods'] as List)
            .map((json) =>
                PaymentMethodDto.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();
        return Result.success(methods);
      } else {
        return Result.failure(
          Failure.network(
            message: 'Failed to get payment methods: ${response.statusMessage ?? 'Unknown error'}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to get payment methods',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get payment methods: $e'),
      );
    }
  }

  @override
  Future<Result<PaymentEntity>> refundPayment(
    String paymentId,
    String? reason,
  ) async {
    try {
      final response = await _remoteDataSource.refundPayment(paymentId, reason);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          final responseData = response.data as Map<String, dynamic>;
          final dto = PaymentDto.fromJson(
            responseData['payment'] as Map<String, dynamic>,
          );
          return Result.success(dto.toEntity());
        }
      }
      return Result.failure(
        Failure.network(
          message: 'Failed to refund payment: ${response.statusMessage ?? 'Unknown error'}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      return Result.failure(
        Failure.network(
          message: e.message ?? 'Failed to refund payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to refund payment: $e'),
      );
    }
  }
}
