// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimeSlotDto _$TimeSlotDtoFromJson(Map<String, dynamic> json) {
  return _TimeSlotDto.fromJson(json);
}

/// @nodoc
mixin _$TimeSlotDto {
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  SlotAvailability get availability => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;

  /// Serializes this TimeSlotDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotDtoCopyWith<TimeSlotDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotDtoCopyWith<$Res> {
  factory $TimeSlotDtoCopyWith(
          TimeSlotDto value, $Res Function(TimeSlotDto) then) =
      _$TimeSlotDtoCopyWithImpl<$Res, TimeSlotDto>;
  @useResult
  $Res call(
      {DateTime startTime,
      DateTime endTime,
      SlotAvailability availability,
      String? bookingId});
}

/// @nodoc
class _$TimeSlotDtoCopyWithImpl<$Res, $Val extends TimeSlotDto>
    implements $TimeSlotDtoCopyWith<$Res> {
  _$TimeSlotDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? availability = null,
    Object? bookingId = freezed,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availability: null == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as SlotAvailability,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeSlotDtoImplCopyWith<$Res>
    implements $TimeSlotDtoCopyWith<$Res> {
  factory _$$TimeSlotDtoImplCopyWith(
          _$TimeSlotDtoImpl value, $Res Function(_$TimeSlotDtoImpl) then) =
      __$$TimeSlotDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startTime,
      DateTime endTime,
      SlotAvailability availability,
      String? bookingId});
}

/// @nodoc
class __$$TimeSlotDtoImplCopyWithImpl<$Res>
    extends _$TimeSlotDtoCopyWithImpl<$Res, _$TimeSlotDtoImpl>
    implements _$$TimeSlotDtoImplCopyWith<$Res> {
  __$$TimeSlotDtoImplCopyWithImpl(
      _$TimeSlotDtoImpl _value, $Res Function(_$TimeSlotDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeSlotDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? availability = null,
    Object? bookingId = freezed,
  }) {
    return _then(_$TimeSlotDtoImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availability: null == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as SlotAvailability,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotDtoImpl implements _TimeSlotDto {
  const _$TimeSlotDtoImpl(
      {required this.startTime,
      required this.endTime,
      this.availability = SlotAvailability.available,
      this.bookingId});

  factory _$TimeSlotDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotDtoImplFromJson(json);

  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final SlotAvailability availability;
  @override
  final String? bookingId;

  @override
  String toString() {
    return 'TimeSlotDto(startTime: $startTime, endTime: $endTime, availability: $availability, bookingId: $bookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotDtoImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, availability, bookingId);

  /// Create a copy of TimeSlotDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotDtoImplCopyWith<_$TimeSlotDtoImpl> get copyWith =>
      __$$TimeSlotDtoImplCopyWithImpl<_$TimeSlotDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotDtoImplToJson(
      this,
    );
  }
}

abstract class _TimeSlotDto implements TimeSlotDto {
  const factory _TimeSlotDto(
      {required final DateTime startTime,
      required final DateTime endTime,
      final SlotAvailability availability,
      final String? bookingId}) = _$TimeSlotDtoImpl;

  factory _TimeSlotDto.fromJson(Map<String, dynamic> json) =
      _$TimeSlotDtoImpl.fromJson;

  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  SlotAvailability get availability;
  @override
  String? get bookingId;

  /// Create a copy of TimeSlotDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotDtoImplCopyWith<_$TimeSlotDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
