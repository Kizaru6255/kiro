// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentDto _$PaymentDtoFromJson(Map<String, dynamic> json) {
  return _PaymentDto.fromJson(json);
}

/// @nodoc
mixin _$PaymentDto {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentMethodType get method => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  String? get gateway => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PaymentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentDtoCopyWith<PaymentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentDtoCopyWith<$Res> {
  factory $PaymentDtoCopyWith(
          PaymentDto value, $Res Function(PaymentDto) then) =
      _$PaymentDtoCopyWithImpl<$Res, PaymentDto>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      double amount,
      String currency,
      PaymentMethodType method,
      PaymentStatus status,
      String? transactionId,
      String? gateway,
      String? description,
      DateTime? completedAt,
      DateTime createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PaymentDtoCopyWithImpl<$Res, $Val extends PaymentDto>
    implements $PaymentDtoCopyWith<$Res> {
  _$PaymentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? gateway = freezed,
    Object? description = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentDtoImplCopyWith<$Res>
    implements $PaymentDtoCopyWith<$Res> {
  factory _$$PaymentDtoImplCopyWith(
          _$PaymentDtoImpl value, $Res Function(_$PaymentDtoImpl) then) =
      __$$PaymentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      double amount,
      String currency,
      PaymentMethodType method,
      PaymentStatus status,
      String? transactionId,
      String? gateway,
      String? description,
      DateTime? completedAt,
      DateTime createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PaymentDtoImplCopyWithImpl<$Res>
    extends _$PaymentDtoCopyWithImpl<$Res, _$PaymentDtoImpl>
    implements _$$PaymentDtoImplCopyWith<$Res> {
  __$$PaymentDtoImplCopyWithImpl(
      _$PaymentDtoImpl _value, $Res Function(_$PaymentDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? gateway = freezed,
    Object? description = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PaymentDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentDtoImpl implements _PaymentDto {
  const _$PaymentDtoImpl(
      {required this.id,
      required this.orderId,
      required this.amount,
      this.currency = 'INR',
      required this.method,
      this.status = PaymentStatus.pending,
      this.transactionId,
      this.gateway,
      this.description,
      this.completedAt,
      required this.createdAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$PaymentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  final PaymentMethodType method;
  @override
  @JsonKey()
  final PaymentStatus status;
  @override
  final String? transactionId;
  @override
  final String? gateway;
  @override
  final String? description;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PaymentDto(id: $id, orderId: $orderId, amount: $amount, currency: $currency, method: $method, status: $status, transactionId: $transactionId, gateway: $gateway, description: $description, completedAt: $completedAt, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.gateway, gateway) || other.gateway == gateway) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      amount,
      currency,
      method,
      status,
      transactionId,
      gateway,
      description,
      completedAt,
      createdAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentDtoImplCopyWith<_$PaymentDtoImpl> get copyWith =>
      __$$PaymentDtoImplCopyWithImpl<_$PaymentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentDtoImplToJson(
      this,
    );
  }
}

abstract class _PaymentDto implements PaymentDto {
  const factory _PaymentDto(
      {required final String id,
      required final String orderId,
      required final double amount,
      final String currency,
      required final PaymentMethodType method,
      final PaymentStatus status,
      final String? transactionId,
      final String? gateway,
      final String? description,
      final DateTime? completedAt,
      required final DateTime createdAt,
      final Map<String, dynamic>? metadata}) = _$PaymentDtoImpl;

  factory _PaymentDto.fromJson(Map<String, dynamic> json) =
      _$PaymentDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentMethodType get method;
  @override
  PaymentStatus get status;
  @override
  String? get transactionId;
  @override
  String? get gateway;
  @override
  String? get description;
  @override
  DateTime? get completedAt;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentDtoImplCopyWith<_$PaymentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
