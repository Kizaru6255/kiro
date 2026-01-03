// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentMethodDto _$PaymentMethodDtoFromJson(Map<String, dynamic> json) {
  return _PaymentMethodDto.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodDto {
  String get id => throw _privateConstructorUsedError;
  PaymentMethodType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodDtoCopyWith<PaymentMethodDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodDtoCopyWith<$Res> {
  factory $PaymentMethodDtoCopyWith(
          PaymentMethodDto value, $Res Function(PaymentMethodDto) then) =
      _$PaymentMethodDtoCopyWithImpl<$Res, PaymentMethodDto>;
  @useResult
  $Res call(
      {String id,
      PaymentMethodType type,
      String name,
      String? iconUrl,
      bool isEnabled,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PaymentMethodDtoCopyWithImpl<$Res, $Val extends PaymentMethodDto>
    implements $PaymentMethodDtoCopyWith<$Res> {
  _$PaymentMethodDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? isEnabled = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentMethodDtoImplCopyWith<$Res>
    implements $PaymentMethodDtoCopyWith<$Res> {
  factory _$$PaymentMethodDtoImplCopyWith(_$PaymentMethodDtoImpl value,
          $Res Function(_$PaymentMethodDtoImpl) then) =
      __$$PaymentMethodDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PaymentMethodType type,
      String name,
      String? iconUrl,
      bool isEnabled,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PaymentMethodDtoImplCopyWithImpl<$Res>
    extends _$PaymentMethodDtoCopyWithImpl<$Res, _$PaymentMethodDtoImpl>
    implements _$$PaymentMethodDtoImplCopyWith<$Res> {
  __$$PaymentMethodDtoImplCopyWithImpl(_$PaymentMethodDtoImpl _value,
      $Res Function(_$PaymentMethodDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? iconUrl = freezed,
    Object? isEnabled = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PaymentMethodDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentMethodType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodDtoImpl implements _PaymentMethodDto {
  const _$PaymentMethodDtoImpl(
      {required this.id,
      required this.type,
      required this.name,
      this.iconUrl,
      this.isEnabled = true,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$PaymentMethodDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodDtoImplFromJson(json);

  @override
  final String id;
  @override
  final PaymentMethodType type;
  @override
  final String name;
  @override
  final String? iconUrl;
  @override
  @JsonKey()
  final bool isEnabled;
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
    return 'PaymentMethodDto(id: $id, type: $type, name: $name, iconUrl: $iconUrl, isEnabled: $isEnabled, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, name, iconUrl,
      isEnabled, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodDtoImplCopyWith<_$PaymentMethodDtoImpl> get copyWith =>
      __$$PaymentMethodDtoImplCopyWithImpl<_$PaymentMethodDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodDtoImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodDto implements PaymentMethodDto {
  const factory _PaymentMethodDto(
      {required final String id,
      required final PaymentMethodType type,
      required final String name,
      final String? iconUrl,
      final bool isEnabled,
      final Map<String, dynamic>? metadata}) = _$PaymentMethodDtoImpl;

  factory _PaymentMethodDto.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodDtoImpl.fromJson;

  @override
  String get id;
  @override
  PaymentMethodType get type;
  @override
  String get name;
  @override
  String? get iconUrl;
  @override
  bool get isEnabled;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodDtoImplCopyWith<_$PaymentMethodDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
