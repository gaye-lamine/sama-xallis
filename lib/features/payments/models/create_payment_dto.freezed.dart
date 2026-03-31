// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_payment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreatePaymentDto _$CreatePaymentDtoFromJson(Map<String, dynamic> json) {
  return _CreatePaymentDto.fromJson(json);
}

/// @nodoc
mixin _$CreatePaymentDto {
  String get orderId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this CreatePaymentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePaymentDtoCopyWith<CreatePaymentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePaymentDtoCopyWith<$Res> {
  factory $CreatePaymentDtoCopyWith(
          CreatePaymentDto value, $Res Function(CreatePaymentDto) then) =
      _$CreatePaymentDtoCopyWithImpl<$Res, CreatePaymentDto>;
  @useResult
  $Res call({String orderId, double amount});
}

/// @nodoc
class _$CreatePaymentDtoCopyWithImpl<$Res, $Val extends CreatePaymentDto>
    implements $CreatePaymentDtoCopyWith<$Res> {
  _$CreatePaymentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePaymentDtoImplCopyWith<$Res>
    implements $CreatePaymentDtoCopyWith<$Res> {
  factory _$$CreatePaymentDtoImplCopyWith(_$CreatePaymentDtoImpl value,
          $Res Function(_$CreatePaymentDtoImpl) then) =
      __$$CreatePaymentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String orderId, double amount});
}

/// @nodoc
class __$$CreatePaymentDtoImplCopyWithImpl<$Res>
    extends _$CreatePaymentDtoCopyWithImpl<$Res, _$CreatePaymentDtoImpl>
    implements _$$CreatePaymentDtoImplCopyWith<$Res> {
  __$$CreatePaymentDtoImplCopyWithImpl(_$CreatePaymentDtoImpl _value,
      $Res Function(_$CreatePaymentDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
  }) {
    return _then(_$CreatePaymentDtoImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePaymentDtoImpl implements _CreatePaymentDto {
  const _$CreatePaymentDtoImpl({required this.orderId, required this.amount});

  factory _$CreatePaymentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePaymentDtoImplFromJson(json);

  @override
  final String orderId;
  @override
  final double amount;

  @override
  String toString() {
    return 'CreatePaymentDto(orderId: $orderId, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePaymentDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, amount);

  /// Create a copy of CreatePaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePaymentDtoImplCopyWith<_$CreatePaymentDtoImpl> get copyWith =>
      __$$CreatePaymentDtoImplCopyWithImpl<_$CreatePaymentDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePaymentDtoImplToJson(
      this,
    );
  }
}

abstract class _CreatePaymentDto implements CreatePaymentDto {
  const factory _CreatePaymentDto(
      {required final String orderId,
      required final double amount}) = _$CreatePaymentDtoImpl;

  factory _CreatePaymentDto.fromJson(Map<String, dynamic> json) =
      _$CreatePaymentDtoImpl.fromJson;

  @override
  String get orderId;
  @override
  double get amount;

  /// Create a copy of CreatePaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePaymentDtoImplCopyWith<_$CreatePaymentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
