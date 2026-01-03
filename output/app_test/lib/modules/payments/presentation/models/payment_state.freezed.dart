// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaymentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() processing,
    required TResult Function(PaymentEntity payment) completed,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? processing,
    TResult? Function(PaymentEntity payment)? completed,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? processing,
    TResult Function(PaymentEntity payment)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Processing value)? processing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentStateCopyWith<$Res> {
  factory $PaymentStateCopyWith(
          PaymentState value, $Res Function(PaymentState) then) =
      _$PaymentStateCopyWithImpl<$Res, PaymentState>;
}

/// @nodoc
class _$PaymentStateCopyWithImpl<$Res, $Val extends PaymentState>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'PaymentState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() processing,
    required TResult Function(PaymentEntity payment) completed,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? processing,
    TResult? Function(PaymentEntity payment)? completed,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? processing,
    TResult Function(PaymentEntity payment)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Processing value)? processing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements PaymentState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$ProcessingImplCopyWith<$Res> {
  factory _$$ProcessingImplCopyWith(
          _$ProcessingImpl value, $Res Function(_$ProcessingImpl) then) =
      __$$ProcessingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProcessingImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$ProcessingImpl>
    implements _$$ProcessingImplCopyWith<$Res> {
  __$$ProcessingImplCopyWithImpl(
      _$ProcessingImpl _value, $Res Function(_$ProcessingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProcessingImpl implements _Processing {
  const _$ProcessingImpl();

  @override
  String toString() {
    return 'PaymentState.processing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProcessingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() processing,
    required TResult Function(PaymentEntity payment) completed,
    required TResult Function(String message) error,
  }) {
    return processing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? processing,
    TResult? Function(PaymentEntity payment)? completed,
    TResult? Function(String message)? error,
  }) {
    return processing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? processing,
    TResult Function(PaymentEntity payment)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return processing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return processing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Processing value)? processing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing(this);
    }
    return orElse();
  }
}

abstract class _Processing implements PaymentState {
  const factory _Processing() = _$ProcessingImpl;
}

/// @nodoc
abstract class _$$CompletedImplCopyWith<$Res> {
  factory _$$CompletedImplCopyWith(
          _$CompletedImpl value, $Res Function(_$CompletedImpl) then) =
      __$$CompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaymentEntity payment});
}

/// @nodoc
class __$$CompletedImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$CompletedImpl>
    implements _$$CompletedImplCopyWith<$Res> {
  __$$CompletedImplCopyWithImpl(
      _$CompletedImpl _value, $Res Function(_$CompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payment = null,
  }) {
    return _then(_$CompletedImpl(
      null == payment
          ? _value.payment
          : payment // ignore: cast_nullable_to_non_nullable
              as PaymentEntity,
    ));
  }
}

/// @nodoc

class _$CompletedImpl implements _Completed {
  const _$CompletedImpl(this.payment);

  @override
  final PaymentEntity payment;

  @override
  String toString() {
    return 'PaymentState.completed(payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedImpl &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, payment);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedImplCopyWith<_$CompletedImpl> get copyWith =>
      __$$CompletedImplCopyWithImpl<_$CompletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() processing,
    required TResult Function(PaymentEntity payment) completed,
    required TResult Function(String message) error,
  }) {
    return completed(payment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? processing,
    TResult? Function(PaymentEntity payment)? completed,
    TResult? Function(String message)? error,
  }) {
    return completed?.call(payment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? processing,
    TResult Function(PaymentEntity payment)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(payment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Processing value)? processing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class _Completed implements PaymentState {
  const factory _Completed(final PaymentEntity payment) = _$CompletedImpl;

  PaymentEntity get payment;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedImplCopyWith<_$CompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PaymentState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() processing,
    required TResult Function(PaymentEntity payment) completed,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? processing,
    TResult? Function(PaymentEntity payment)? completed,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? processing,
    TResult Function(PaymentEntity payment)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Processing value)? processing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements PaymentState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaymentMethodsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<PaymentMethodEntity> methods) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<PaymentMethodEntity> methods)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<PaymentMethodEntity> methods)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaymentMethodsInitial value) initial,
    required TResult Function(_PaymentMethodsLoading value) loading,
    required TResult Function(_PaymentMethodsLoaded value) loaded,
    required TResult Function(_PaymentMethodsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaymentMethodsInitial value)? initial,
    TResult? Function(_PaymentMethodsLoading value)? loading,
    TResult? Function(_PaymentMethodsLoaded value)? loaded,
    TResult? Function(_PaymentMethodsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaymentMethodsInitial value)? initial,
    TResult Function(_PaymentMethodsLoading value)? loading,
    TResult Function(_PaymentMethodsLoaded value)? loaded,
    TResult Function(_PaymentMethodsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodsStateCopyWith<$Res> {
  factory $PaymentMethodsStateCopyWith(
          PaymentMethodsState value, $Res Function(PaymentMethodsState) then) =
      _$PaymentMethodsStateCopyWithImpl<$Res, PaymentMethodsState>;
}

/// @nodoc
class _$PaymentMethodsStateCopyWithImpl<$Res, $Val extends PaymentMethodsState>
    implements $PaymentMethodsStateCopyWith<$Res> {
  _$PaymentMethodsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PaymentMethodsInitialImplCopyWith<$Res> {
  factory _$$PaymentMethodsInitialImplCopyWith(
          _$PaymentMethodsInitialImpl value,
          $Res Function(_$PaymentMethodsInitialImpl) then) =
      __$$PaymentMethodsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentMethodsInitialImplCopyWithImpl<$Res>
    extends _$PaymentMethodsStateCopyWithImpl<$Res, _$PaymentMethodsInitialImpl>
    implements _$$PaymentMethodsInitialImplCopyWith<$Res> {
  __$$PaymentMethodsInitialImplCopyWithImpl(_$PaymentMethodsInitialImpl _value,
      $Res Function(_$PaymentMethodsInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentMethodsInitialImpl implements _PaymentMethodsInitial {
  const _$PaymentMethodsInitialImpl();

  @override
  String toString() {
    return 'PaymentMethodsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<PaymentMethodEntity> methods) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<PaymentMethodEntity> methods)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<PaymentMethodEntity> methods)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaymentMethodsInitial value) initial,
    required TResult Function(_PaymentMethodsLoading value) loading,
    required TResult Function(_PaymentMethodsLoaded value) loaded,
    required TResult Function(_PaymentMethodsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaymentMethodsInitial value)? initial,
    TResult? Function(_PaymentMethodsLoading value)? loading,
    TResult? Function(_PaymentMethodsLoaded value)? loaded,
    TResult? Function(_PaymentMethodsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaymentMethodsInitial value)? initial,
    TResult Function(_PaymentMethodsLoading value)? loading,
    TResult Function(_PaymentMethodsLoaded value)? loaded,
    TResult Function(_PaymentMethodsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _PaymentMethodsInitial implements PaymentMethodsState {
  const factory _PaymentMethodsInitial() = _$PaymentMethodsInitialImpl;
}

/// @nodoc
abstract class _$$PaymentMethodsLoadingImplCopyWith<$Res> {
  factory _$$PaymentMethodsLoadingImplCopyWith(
          _$PaymentMethodsLoadingImpl value,
          $Res Function(_$PaymentMethodsLoadingImpl) then) =
      __$$PaymentMethodsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentMethodsLoadingImplCopyWithImpl<$Res>
    extends _$PaymentMethodsStateCopyWithImpl<$Res, _$PaymentMethodsLoadingImpl>
    implements _$$PaymentMethodsLoadingImplCopyWith<$Res> {
  __$$PaymentMethodsLoadingImplCopyWithImpl(_$PaymentMethodsLoadingImpl _value,
      $Res Function(_$PaymentMethodsLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentMethodsLoadingImpl implements _PaymentMethodsLoading {
  const _$PaymentMethodsLoadingImpl();

  @override
  String toString() {
    return 'PaymentMethodsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<PaymentMethodEntity> methods) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<PaymentMethodEntity> methods)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<PaymentMethodEntity> methods)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaymentMethodsInitial value) initial,
    required TResult Function(_PaymentMethodsLoading value) loading,
    required TResult Function(_PaymentMethodsLoaded value) loaded,
    required TResult Function(_PaymentMethodsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaymentMethodsInitial value)? initial,
    TResult? Function(_PaymentMethodsLoading value)? loading,
    TResult? Function(_PaymentMethodsLoaded value)? loaded,
    TResult? Function(_PaymentMethodsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaymentMethodsInitial value)? initial,
    TResult Function(_PaymentMethodsLoading value)? loading,
    TResult Function(_PaymentMethodsLoaded value)? loaded,
    TResult Function(_PaymentMethodsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _PaymentMethodsLoading implements PaymentMethodsState {
  const factory _PaymentMethodsLoading() = _$PaymentMethodsLoadingImpl;
}

/// @nodoc
abstract class _$$PaymentMethodsLoadedImplCopyWith<$Res> {
  factory _$$PaymentMethodsLoadedImplCopyWith(_$PaymentMethodsLoadedImpl value,
          $Res Function(_$PaymentMethodsLoadedImpl) then) =
      __$$PaymentMethodsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<PaymentMethodEntity> methods});
}

/// @nodoc
class __$$PaymentMethodsLoadedImplCopyWithImpl<$Res>
    extends _$PaymentMethodsStateCopyWithImpl<$Res, _$PaymentMethodsLoadedImpl>
    implements _$$PaymentMethodsLoadedImplCopyWith<$Res> {
  __$$PaymentMethodsLoadedImplCopyWithImpl(_$PaymentMethodsLoadedImpl _value,
      $Res Function(_$PaymentMethodsLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? methods = null,
  }) {
    return _then(_$PaymentMethodsLoadedImpl(
      null == methods
          ? _value._methods
          : methods // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethodEntity>,
    ));
  }
}

/// @nodoc

class _$PaymentMethodsLoadedImpl implements _PaymentMethodsLoaded {
  const _$PaymentMethodsLoadedImpl(final List<PaymentMethodEntity> methods)
      : _methods = methods;

  final List<PaymentMethodEntity> _methods;
  @override
  List<PaymentMethodEntity> get methods {
    if (_methods is EqualUnmodifiableListView) return _methods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_methods);
  }

  @override
  String toString() {
    return 'PaymentMethodsState.loaded(methods: $methods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodsLoadedImpl &&
            const DeepCollectionEquality().equals(other._methods, _methods));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_methods));

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodsLoadedImplCopyWith<_$PaymentMethodsLoadedImpl>
      get copyWith =>
          __$$PaymentMethodsLoadedImplCopyWithImpl<_$PaymentMethodsLoadedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<PaymentMethodEntity> methods) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(methods);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<PaymentMethodEntity> methods)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(methods);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<PaymentMethodEntity> methods)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(methods);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaymentMethodsInitial value) initial,
    required TResult Function(_PaymentMethodsLoading value) loading,
    required TResult Function(_PaymentMethodsLoaded value) loaded,
    required TResult Function(_PaymentMethodsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaymentMethodsInitial value)? initial,
    TResult? Function(_PaymentMethodsLoading value)? loading,
    TResult? Function(_PaymentMethodsLoaded value)? loaded,
    TResult? Function(_PaymentMethodsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaymentMethodsInitial value)? initial,
    TResult Function(_PaymentMethodsLoading value)? loading,
    TResult Function(_PaymentMethodsLoaded value)? loaded,
    TResult Function(_PaymentMethodsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _PaymentMethodsLoaded implements PaymentMethodsState {
  const factory _PaymentMethodsLoaded(final List<PaymentMethodEntity> methods) =
      _$PaymentMethodsLoadedImpl;

  List<PaymentMethodEntity> get methods;

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodsLoadedImplCopyWith<_$PaymentMethodsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentMethodsErrorImplCopyWith<$Res> {
  factory _$$PaymentMethodsErrorImplCopyWith(_$PaymentMethodsErrorImpl value,
          $Res Function(_$PaymentMethodsErrorImpl) then) =
      __$$PaymentMethodsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PaymentMethodsErrorImplCopyWithImpl<$Res>
    extends _$PaymentMethodsStateCopyWithImpl<$Res, _$PaymentMethodsErrorImpl>
    implements _$$PaymentMethodsErrorImplCopyWith<$Res> {
  __$$PaymentMethodsErrorImplCopyWithImpl(_$PaymentMethodsErrorImpl _value,
      $Res Function(_$PaymentMethodsErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PaymentMethodsErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PaymentMethodsErrorImpl implements _PaymentMethodsError {
  const _$PaymentMethodsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PaymentMethodsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodsErrorImplCopyWith<_$PaymentMethodsErrorImpl> get copyWith =>
      __$$PaymentMethodsErrorImplCopyWithImpl<_$PaymentMethodsErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<PaymentMethodEntity> methods) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<PaymentMethodEntity> methods)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<PaymentMethodEntity> methods)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaymentMethodsInitial value) initial,
    required TResult Function(_PaymentMethodsLoading value) loading,
    required TResult Function(_PaymentMethodsLoaded value) loaded,
    required TResult Function(_PaymentMethodsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaymentMethodsInitial value)? initial,
    TResult? Function(_PaymentMethodsLoading value)? loading,
    TResult? Function(_PaymentMethodsLoaded value)? loaded,
    TResult? Function(_PaymentMethodsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaymentMethodsInitial value)? initial,
    TResult Function(_PaymentMethodsLoading value)? loading,
    TResult Function(_PaymentMethodsLoaded value)? loaded,
    TResult Function(_PaymentMethodsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _PaymentMethodsError implements PaymentMethodsState {
  const factory _PaymentMethodsError(final String message) =
      _$PaymentMethodsErrorImpl;

  String get message;

  /// Create a copy of PaymentMethodsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodsErrorImplCopyWith<_$PaymentMethodsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
