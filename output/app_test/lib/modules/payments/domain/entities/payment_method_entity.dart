/// Payment method entity (domain layer).
library;

import 'payment_entity.dart';

/// Payment method entity.
class PaymentMethodEntity {
  final String id;
  final PaymentMethodType type;
  final String name;
  final String? iconUrl;
  final bool isEnabled;
  final Map<String, dynamic>? metadata;

  const PaymentMethodEntity({
    required this.id,
    required this.type,
    required this.name,
    this.iconUrl,
    this.isEnabled = true,
    this.metadata,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}


