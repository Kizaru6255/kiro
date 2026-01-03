/// Wallet DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wallet_entity.dart';

part 'wallet_dto.freezed.dart';
part 'wallet_dto.g.dart';

/// Wallet data transfer object.
@freezed
class WalletDto with _$WalletDto {
  const factory WalletDto({
    required String id,
    required String userId,
    required double balance,
    @Default('INR') String currency,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _WalletDto;

  factory WalletDto.fromJson(Map<String, dynamic> json) =>
      _$WalletDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension WalletDtoExtension on WalletDto {
  /// Convert DTO to domain entity.
  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      userId: userId,
      balance: balance,
      currency: currency,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
}


