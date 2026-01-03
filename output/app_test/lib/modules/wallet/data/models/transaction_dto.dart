/// Transaction DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/transaction_entity.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

/// Transaction data transfer object.
@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    required String walletId,
    required TransactionType type,
    required TransactionStatus status,
    required double amount,
    @Default('INR') String currency,
    String? description,
    String? referenceId,
    String? recipientId,
    String? senderId,
    DateTime? completedAt,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension TransactionDtoExtension on TransactionDto {
  /// Convert DTO to domain entity.
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      walletId: walletId,
      type: type,
      status: status,
      amount: amount,
      currency: currency,
      description: description,
      referenceId: referenceId,
      recipientId: recipientId,
      senderId: senderId,
      completedAt: completedAt,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}


