// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  String? get serviceName => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancelledBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String serviceId,
      String? serviceName,
      DateTime startTime,
      DateTime endTime,
      BookingStatus status,
      String? notes,
      String? location,
      double? price,
      String? currency,
      DateTime? cancelledAt,
      String? cancelledBy,
      DateTime? createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? serviceId = null,
    Object? serviceName = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? location = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? createdAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: freezed == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
          _$BookingImpl value, $Res Function(_$BookingImpl) then) =
      __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String serviceId,
      String? serviceName,
      DateTime startTime,
      DateTime endTime,
      BookingStatus status,
      String? notes,
      String? location,
      double? price,
      String? currency,
      DateTime? cancelledAt,
      String? cancelledBy,
      DateTime? createdAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
      _$BookingImpl _value, $Res Function(_$BookingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? serviceId = null,
    Object? serviceName = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? location = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? createdAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$BookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceName: freezed == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl(
      {required this.id,
      required this.userId,
      required this.serviceId,
      this.serviceName,
      required this.startTime,
      required this.endTime,
      this.status = BookingStatus.pending,
      this.notes,
      this.location,
      this.price,
      this.currency,
      this.cancelledAt,
      this.cancelledBy,
      this.createdAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String serviceId;
  @override
  final String? serviceName;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final BookingStatus status;
  @override
  final String? notes;
  @override
  final String? location;
  @override
  final double? price;
  @override
  final String? currency;
  @override
  final DateTime? cancelledAt;
  @override
  final String? cancelledBy;
  @override
  final DateTime? createdAt;
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
    return 'Booking(id: $id, userId: $userId, serviceId: $serviceId, serviceName: $serviceName, startTime: $startTime, endTime: $endTime, status: $status, notes: $notes, location: $location, price: $price, currency: $currency, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      serviceId,
      serviceName,
      startTime,
      endTime,
      status,
      notes,
      location,
      price,
      currency,
      cancelledAt,
      cancelledBy,
      createdAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(
      this,
    );
  }
}

abstract class _Booking implements Booking {
  const factory _Booking(
      {required final String id,
      required final String userId,
      required final String serviceId,
      final String? serviceName,
      required final DateTime startTime,
      required final DateTime endTime,
      final BookingStatus status,
      final String? notes,
      final String? location,
      final double? price,
      final String? currency,
      final DateTime? cancelledAt,
      final String? cancelledBy,
      final DateTime? createdAt,
      final Map<String, dynamic>? metadata}) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get serviceId;
  @override
  String? get serviceName;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  BookingStatus get status;
  @override
  String? get notes;
  @override
  String? get location;
  @override
  double? get price;
  @override
  String? get currency;
  @override
  DateTime? get cancelledAt;
  @override
  String? get cancelledBy;
  @override
  DateTime? get createdAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
