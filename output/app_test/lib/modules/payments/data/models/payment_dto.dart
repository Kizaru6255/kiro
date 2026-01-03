/// Payment DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_entity.dart';

part 'payment_dto.freezed.dart';
part 'payment_dto.g.dart';

/// Payment data transfer object.
@freezed
class PaymentDto with _$PaymentDto {
  const factory PaymentDto({
    required String id,
    required String orderId,
    required double amount,
    @Default('INR') String currency,
    required PaymentMethodType method,
    @Default(PaymentStatus.pending) PaymentStatus status,
    String? transactionId,
    String? gateway,
    String? description,
    DateTime? completedAt,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _PaymentDto;

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension PaymentDtoExtension on PaymentDto {
  /// Convert DTO to domain entity.
  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      orderId: orderId,
      amount: amount,
      currency: currency,
      method: method,
      status: status,
      transactionId: transactionId,
      gateway: gateway,
      description: description,
      completedAt: completedAt,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}


