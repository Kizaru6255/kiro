// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodImpl _$$PaymentMethodImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentMethodImplToJson(_$PaymentMethodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PaymentMethodTypeEnumMap[instance.type]!,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'isEnabled': instance.isEnabled,
      'metadata': instance.metadata,
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.card: 'card',
  PaymentMethodType.upi: 'upi',
  PaymentMethodType.netbanking: 'netbanking',
  PaymentMethodType.wallet: 'wallet',
  PaymentMethodType.cash: 'cash',
};
