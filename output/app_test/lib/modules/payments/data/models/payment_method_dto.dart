/// Payment method DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_method_entity.dart';

part 'payment_method_dto.freezed.dart';
part 'payment_method_dto.g.dart';

/// Payment method data transfer object.
@freezed
class PaymentMethodDto with _$PaymentMethodDto {
  const factory PaymentMethodDto({
    required String id,
    required PaymentMethodType type,
    required String name,
    String? iconUrl,
    @Default(true) bool isEnabled,
    Map<String, dynamic>? metadata,
  }) = _PaymentMethodDto;

  factory PaymentMethodDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension PaymentMethodDtoExtension on PaymentMethodDto {
  /// Convert DTO to domain entity.
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      type: type,
      name: name,
      iconUrl: iconUrl,
      isEnabled: isEnabled,
      metadata: metadata,
    );
  }
}

