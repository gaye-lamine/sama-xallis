// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_debt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateDebtDto _$UpdateDebtDtoFromJson(Map<String, dynamic> json) {
  return _UpdateDebtDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateDebtDto {
  double? get amount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get dueDate => throw _privateConstructorUsedError;

  /// Serializes this UpdateDebtDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateDebtDtoCopyWith<UpdateDebtDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateDebtDtoCopyWith<$Res> {
  factory $UpdateDebtDtoCopyWith(
          UpdateDebtDto value, $Res Function(UpdateDebtDto) then) =
      _$UpdateDebtDtoCopyWithImpl<$Res, UpdateDebtDto>;
  @useResult
  $Res call(
      {double? amount, String? description, String? status, String? dueDate});
}

/// @nodoc
class _$UpdateDebtDtoCopyWithImpl<$Res, $Val extends UpdateDebtDto>
    implements $UpdateDebtDtoCopyWith<$Res> {
  _$UpdateDebtDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? dueDate = freezed,
  }) {
    return _then(_value.copyWith(
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateDebtDtoImplCopyWith<$Res>
    implements $UpdateDebtDtoCopyWith<$Res> {
  factory _$$UpdateDebtDtoImplCopyWith(
          _$UpdateDebtDtoImpl value, $Res Function(_$UpdateDebtDtoImpl) then) =
      __$$UpdateDebtDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? amount, String? description, String? status, String? dueDate});
}

/// @nodoc
class __$$UpdateDebtDtoImplCopyWithImpl<$Res>
    extends _$UpdateDebtDtoCopyWithImpl<$Res, _$UpdateDebtDtoImpl>
    implements _$$UpdateDebtDtoImplCopyWith<$Res> {
  __$$UpdateDebtDtoImplCopyWithImpl(
      _$UpdateDebtDtoImpl _value, $Res Function(_$UpdateDebtDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? dueDate = freezed,
  }) {
    return _then(_$UpdateDebtDtoImpl(
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateDebtDtoImpl implements _UpdateDebtDto {
  const _$UpdateDebtDtoImpl(
      {this.amount, this.description, this.status, this.dueDate});

  factory _$UpdateDebtDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateDebtDtoImplFromJson(json);

  @override
  final double? amount;
  @override
  final String? description;
  @override
  final String? status;
  @override
  final String? dueDate;

  @override
  String toString() {
    return 'UpdateDebtDto(amount: $amount, description: $description, status: $status, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDebtDtoImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, amount, description, status, dueDate);

  /// Create a copy of UpdateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDebtDtoImplCopyWith<_$UpdateDebtDtoImpl> get copyWith =>
      __$$UpdateDebtDtoImplCopyWithImpl<_$UpdateDebtDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateDebtDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateDebtDto implements UpdateDebtDto {
  const factory _UpdateDebtDto(
      {final double? amount,
      final String? description,
      final String? status,
      final String? dueDate}) = _$UpdateDebtDtoImpl;

  factory _UpdateDebtDto.fromJson(Map<String, dynamic> json) =
      _$UpdateDebtDtoImpl.fromJson;

  @override
  double? get amount;
  @override
  String? get description;
  @override
  String? get status;
  @override
  String? get dueDate;

  /// Create a copy of UpdateDebtDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateDebtDtoImplCopyWith<_$UpdateDebtDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
