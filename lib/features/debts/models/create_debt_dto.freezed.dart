// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_debt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateDebtDto _$CreateDebtDtoFromJson(Map<String, dynamic> json) {
  return _CreateDebtDto.fromJson(json);
}

/// @nodoc
mixin _$CreateDebtDto {
  String get customerId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get dueDate => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this CreateDebtDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDebtDtoCopyWith<CreateDebtDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDebtDtoCopyWith<$Res> {
  factory $CreateDebtDtoCopyWith(
          CreateDebtDto value, $Res Function(CreateDebtDto) then) =
      _$CreateDebtDtoCopyWithImpl<$Res, CreateDebtDto>;
  @useResult
  $Res call(
      {String customerId,
      double amount,
      String description,
      String? dueDate,
      String? status});
}

/// @nodoc
class _$CreateDebtDtoCopyWithImpl<$Res, $Val extends CreateDebtDto>
    implements $CreateDebtDtoCopyWith<$Res> {
  _$CreateDebtDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? amount = null,
    Object? description = null,
    Object? dueDate = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateDebtDtoImplCopyWith<$Res>
    implements $CreateDebtDtoCopyWith<$Res> {
  factory _$$CreateDebtDtoImplCopyWith(
          _$CreateDebtDtoImpl value, $Res Function(_$CreateDebtDtoImpl) then) =
      __$$CreateDebtDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String customerId,
      double amount,
      String description,
      String? dueDate,
      String? status});
}

/// @nodoc
class __$$CreateDebtDtoImplCopyWithImpl<$Res>
    extends _$CreateDebtDtoCopyWithImpl<$Res, _$CreateDebtDtoImpl>
    implements _$$CreateDebtDtoImplCopyWith<$Res> {
  __$$CreateDebtDtoImplCopyWithImpl(
      _$CreateDebtDtoImpl _value, $Res Function(_$CreateDebtDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? amount = null,
    Object? description = null,
    Object? dueDate = freezed,
    Object? status = freezed,
  }) {
    return _then(_$CreateDebtDtoImpl(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateDebtDtoImpl implements _CreateDebtDto {
  const _$CreateDebtDtoImpl(
      {required this.customerId,
      required this.amount,
      required this.description,
      this.dueDate,
      this.status});

  factory _$CreateDebtDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateDebtDtoImplFromJson(json);

  @override
  final String customerId;
  @override
  final double amount;
  @override
  final String description;
  @override
  final String? dueDate;
  @override
  final String? status;

  @override
  String toString() {
    return 'CreateDebtDto(customerId: $customerId, amount: $amount, description: $description, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDebtDtoImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, customerId, amount, description, dueDate, status);

  /// Create a copy of CreateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDebtDtoImplCopyWith<_$CreateDebtDtoImpl> get copyWith =>
      __$$CreateDebtDtoImplCopyWithImpl<_$CreateDebtDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateDebtDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateDebtDto implements CreateDebtDto {
  const factory _CreateDebtDto(
      {required final String customerId,
      required final double amount,
      required final String description,
      final String? dueDate,
      final String? status}) = _$CreateDebtDtoImpl;

  factory _CreateDebtDto.fromJson(Map<String, dynamic> json) =
      _$CreateDebtDtoImpl.fromJson;

  @override
  String get customerId;
  @override
  double get amount;
  @override
  String get description;
  @override
  String? get dueDate;
  @override
  String? get status;

  /// Create a copy of CreateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDebtDtoImplCopyWith<_$CreateDebtDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
