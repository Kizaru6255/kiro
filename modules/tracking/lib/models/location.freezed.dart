// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Location _$LocationFromJson(Map<String, dynamic> json) {
  return _Location.fromJson(json);
}

/// @nodoc
mixin _$Location {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationCopyWith<Location> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationCopyWith<$Res> {
  factory $LocationCopyWith(Location value, $Res Function(Location) then) =
      _$LocationCopyWithImpl<$Res, Location>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      double? altitude,
      double? accuracy,
      double? speed,
      DateTime? timestamp});
}

/// @nodoc
class _$LocationCopyWithImpl<$Res, $Val extends Location>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = freezed,
    Object? accuracy = freezed,
    Object? speed = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationImplCopyWith<$Res>
    implements $LocationCopyWith<$Res> {
  factory _$$LocationImplCopyWith(
          _$LocationImpl value, $Res Function(_$LocationImpl) then) =
      __$$LocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      double? altitude,
      double? accuracy,
      double? speed,
      DateTime? timestamp});
}

/// @nodoc
class __$$LocationImplCopyWithImpl<$Res>
    extends _$LocationCopyWithImpl<$Res, _$LocationImpl>
    implements _$$LocationImplCopyWith<$Res> {
  __$$LocationImplCopyWithImpl(
      _$LocationImpl _value, $Res Function(_$LocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = freezed,
    Object? accuracy = freezed,
    Object? speed = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$LocationImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      accuracy: freezed == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationImpl implements _Location {
  const _$LocationImpl(
      {required this.latitude,
      required this.longitude,
      this.altitude,
      this.accuracy,
      this.speed,
      this.timestamp});

  factory _$LocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? altitude;
  @override
  final double? accuracy;
  @override
  final double? speed;
  @override
  final DateTime? timestamp;

  @override
  String toString() {
    return 'Location(latitude: $latitude, longitude: $longitude, altitude: $altitude, accuracy: $accuracy, speed: $speed, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, latitude, longitude, altitude, accuracy, speed, timestamp);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      __$$LocationImplCopyWithImpl<_$LocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationImplToJson(
      this,
    );
  }
}

abstract class _Location implements Location {
  const factory _Location(
      {required final double latitude,
      required final double longitude,
      final double? altitude,
      final double? accuracy,
      final double? speed,
      final DateTime? timestamp}) = _$LocationImpl;

  factory _Location.fromJson(Map<String, dynamic> json) =
      _$LocationImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get altitude;
  @override
  double? get accuracy;
  @override
  double? get speed;
  @override
  DateTime? get timestamp;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
