// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateProductDto _$UpdateProductDtoFromJson(Map<String, dynamic> json) {
  return _UpdateProductDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateProductDto {
  String? get name => throw _privateConstructorUsedError;
  double? get purchasePrice => throw _privateConstructorUsedError;
  double? get sellingPrice => throw _privateConstructorUsedError;
  int? get stock => throw _privateConstructorUsedError;

  /// Serializes this UpdateProductDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateProductDtoCopyWith<UpdateProductDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProductDtoCopyWith<$Res> {
  factory $UpdateProductDtoCopyWith(
          UpdateProductDto value, $Res Function(UpdateProductDto) then) =
      _$UpdateProductDtoCopyWithImpl<$Res, UpdateProductDto>;
  @useResult
  $Res call(
      {String? name, double? purchasePrice, double? sellingPrice, int? stock});
}

/// @nodoc
class _$UpdateProductDtoCopyWithImpl<$Res, $Val extends UpdateProductDto>
    implements $UpdateProductDtoCopyWith<$Res> {
  _$UpdateProductDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? purchasePrice = freezed,
    Object? sellingPrice = freezed,
    Object? stock = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      sellingPrice: freezed == sellingPrice
          ? _value.sellingPrice
          : sellingPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateProductDtoImplCopyWith<$Res>
    implements $UpdateProductDtoCopyWith<$Res> {
  factory _$$UpdateProductDtoImplCopyWith(_$UpdateProductDtoImpl value,
          $Res Function(_$UpdateProductDtoImpl) then) =
      __$$UpdateProductDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name, double? purchasePrice, double? sellingPrice, int? stock});
}

/// @nodoc
class __$$UpdateProductDtoImplCopyWithImpl<$Res>
    extends _$UpdateProductDtoCopyWithImpl<$Res, _$UpdateProductDtoImpl>
    implements _$$UpdateProductDtoImplCopyWith<$Res> {
  __$$UpdateProductDtoImplCopyWithImpl(_$UpdateProductDtoImpl _value,
      $Res Function(_$UpdateProductDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? purchasePrice = freezed,
    Object? sellingPrice = freezed,
    Object? stock = freezed,
  }) {
    return _then(_$UpdateProductDtoImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      sellingPrice: freezed == sellingPrice
          ? _value.sellingPrice
          : sellingPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProductDtoImpl implements _UpdateProductDto {
  const _$UpdateProductDtoImpl(
      {this.name, this.purchasePrice, this.sellingPrice, this.stock});

  factory _$UpdateProductDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProductDtoImplFromJson(json);

  @override
  final String? name;
  @override
  final double? purchasePrice;
  @override
  final double? sellingPrice;
  @override
  final int? stock;

  @override
  String toString() {
    return 'UpdateProductDto(name: $name, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProductDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.sellingPrice, sellingPrice) ||
                other.sellingPrice == sellingPrice) &&
            (identical(other.stock, stock) || other.stock == stock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, purchasePrice, sellingPrice, stock);

  /// Create a copy of UpdateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProductDtoImplCopyWith<_$UpdateProductDtoImpl> get copyWith =>
      __$$UpdateProductDtoImplCopyWithImpl<_$UpdateProductDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProductDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateProductDto implements UpdateProductDto {
  const factory _UpdateProductDto(
      {final String? name,
      final double? purchasePrice,
      final double? sellingPrice,
      final int? stock}) = _$UpdateProductDtoImpl;

  factory _UpdateProductDto.fromJson(Map<String, dynamic> json) =
      _$UpdateProductDtoImpl.fromJson;

  @override
  String? get name;
  @override
  double? get purchasePrice;
  @override
  double? get sellingPrice;
  @override
  int? get stock;

  /// Create a copy of UpdateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProductDtoImplCopyWith<_$UpdateProductDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
