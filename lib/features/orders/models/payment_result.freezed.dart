// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentResult _$PaymentResultFromJson(Map<String, dynamic> json) {
  return _PaymentResult.fromJson(json);
}

/// @nodoc
mixin _$PaymentResult {
  double get paidAmount => throw _privateConstructorUsedError;
  double get remainingAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this PaymentResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentResultCopyWith<PaymentResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentResultCopyWith<$Res> {
  factory $PaymentResultCopyWith(
          PaymentResult value, $Res Function(PaymentResult) then) =
      _$PaymentResultCopyWithImpl<$Res, PaymentResult>;
  @useResult
  $Res call({double paidAmount, double remainingAmount, String status});
}

/// @nodoc
class _$PaymentResultCopyWithImpl<$Res, $Val extends PaymentResult>
    implements $PaymentResultCopyWith<$Res> {
  _$PaymentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paidAmount = null,
    Object? remainingAmount = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentResultImplCopyWith<$Res>
    implements $PaymentResultCopyWith<$Res> {
  factory _$$PaymentResultImplCopyWith(
          _$PaymentResultImpl value, $Res Function(_$PaymentResultImpl) then) =
      __$$PaymentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double paidAmount, double remainingAmount, String status});
}

/// @nodoc
class __$$PaymentResultImplCopyWithImpl<$Res>
    extends _$PaymentResultCopyWithImpl<$Res, _$PaymentResultImpl>
    implements _$$PaymentResultImplCopyWith<$Res> {
  __$$PaymentResultImplCopyWithImpl(
      _$PaymentResultImpl _value, $Res Function(_$PaymentResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paidAmount = null,
    Object? remainingAmount = null,
    Object? status = null,
  }) {
    return _then(_$PaymentResultImpl(
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentResultImpl implements _PaymentResult {
  const _$PaymentResultImpl(
      {required this.paidAmount,
      required this.remainingAmount,
      required this.status});

  factory _$PaymentResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentResultImplFromJson(json);

  @override
  final double paidAmount;
  @override
  final double remainingAmount;
  @override
  final String status;

  @override
  String toString() {
    return 'PaymentResult(paidAmount: $paidAmount, remainingAmount: $remainingAmount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentResultImpl &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paidAmount, remainingAmount, status);

  /// Create a copy of PaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentResultImplCopyWith<_$PaymentResultImpl> get copyWith =>
      __$$PaymentResultImplCopyWithImpl<_$PaymentResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentResultImplToJson(
      this,
    );
  }
}

abstract class _PaymentResult implements PaymentResult {
  const factory _PaymentResult(
      {required final double paidAmount,
      required final double remainingAmount,
      required final String status}) = _$PaymentResultImpl;

  factory _PaymentResult.fromJson(Map<String, dynamic> json) =
      _$PaymentResultImpl.fromJson;

  @override
  double get paidAmount;
  @override
  double get remainingAmount;
  @override
  String get status;

  /// Create a copy of PaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentResultImplCopyWith<_$PaymentResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
