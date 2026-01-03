// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrackingSession _$TrackingSessionFromJson(Map<String, dynamic> json) {
  return _TrackingSession.fromJson(json);
}

/// @nodoc
mixin _$TrackingSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<Location> get locations => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  double get averageSpeed => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this TrackingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackingSessionCopyWith<TrackingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackingSessionCopyWith<$Res> {
  factory $TrackingSessionCopyWith(
          TrackingSession value, $Res Function(TrackingSession) then) =
      _$TrackingSessionCopyWithImpl<$Res, TrackingSession>;
  @useResult
  $Res call(
      {String id,
      String userId,
      List<Location> locations,
      DateTime startTime,
      DateTime? endTime,
      double totalDistance,
      double averageSpeed,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TrackingSessionCopyWithImpl<$Res, $Val extends TrackingSession>
    implements $TrackingSessionCopyWith<$Res> {
  _$TrackingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? locations = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? totalDistance = null,
    Object? averageSpeed = null,
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
      locations: null == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      averageSpeed: null == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrackingSessionImplCopyWith<$Res>
    implements $TrackingSessionCopyWith<$Res> {
  factory _$$TrackingSessionImplCopyWith(_$TrackingSessionImpl value,
          $Res Function(_$TrackingSessionImpl) then) =
      __$$TrackingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      List<Location> locations,
      DateTime startTime,
      DateTime? endTime,
      double totalDistance,
      double averageSpeed,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$TrackingSessionImplCopyWithImpl<$Res>
    extends _$TrackingSessionCopyWithImpl<$Res, _$TrackingSessionImpl>
    implements _$$TrackingSessionImplCopyWith<$Res> {
  __$$TrackingSessionImplCopyWithImpl(
      _$TrackingSessionImpl _value, $Res Function(_$TrackingSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrackingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? locations = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? totalDistance = null,
    Object? averageSpeed = null,
    Object? metadata = freezed,
  }) {
    return _then(_$TrackingSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      locations: null == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<Location>,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      averageSpeed: null == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackingSessionImpl implements _TrackingSession {
  const _$TrackingSessionImpl(
      {required this.id,
      required this.userId,
      required final List<Location> locations,
      required this.startTime,
      this.endTime,
      this.totalDistance = 0.0,
      this.averageSpeed = 0.0,
      final Map<String, dynamic>? metadata})
      : _locations = locations,
        _metadata = metadata;

  factory _$TrackingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackingSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  final List<Location> _locations;
  @override
  List<Location> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final double totalDistance;
  @override
  @JsonKey()
  final double averageSpeed;
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
    return 'TrackingSession(id: $id, userId: $userId, locations: $locations, startTime: $startTime, endTime: $endTime, totalDistance: $totalDistance, averageSpeed: $averageSpeed, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.averageSpeed, averageSpeed) ||
                other.averageSpeed == averageSpeed) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      const DeepCollectionEquality().hash(_locations),
      startTime,
      endTime,
      totalDistance,
      averageSpeed,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of TrackingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackingSessionImplCopyWith<_$TrackingSessionImpl> get copyWith =>
      __$$TrackingSessionImplCopyWithImpl<_$TrackingSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackingSessionImplToJson(
      this,
    );
  }
}

abstract class _TrackingSession implements TrackingSession {
  const factory _TrackingSession(
      {required final String id,
      required final String userId,
      required final List<Location> locations,
      required final DateTime startTime,
      final DateTime? endTime,
      final double totalDistance,
      final double averageSpeed,
      final Map<String, dynamic>? metadata}) = _$TrackingSessionImpl;

  factory _TrackingSession.fromJson(Map<String, dynamic> json) =
      _$TrackingSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  List<Location> get locations;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  double get totalDistance;
  @override
  double get averageSpeed;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of TrackingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackingSessionImplCopyWith<_$TrackingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
