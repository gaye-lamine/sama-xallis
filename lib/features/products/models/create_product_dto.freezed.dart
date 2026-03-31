// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateProductDto _$CreateProductDtoFromJson(Map<String, dynamic> json) {
  return _CreateProductDto.fromJson(json);
}

/// @nodoc
mixin _$CreateProductDto {
  String get name => throw _privateConstructorUsedError;
  double get purchasePrice => throw _privateConstructorUsedError;
  double get sellingPrice => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;

  /// Serializes this CreateProductDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateProductDtoCopyWith<CreateProductDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProductDtoCopyWith<$Res> {
  factory $CreateProductDtoCopyWith(
          CreateProductDto value, $Res Function(CreateProductDto) then) =
      _$CreateProductDtoCopyWithImpl<$Res, CreateProductDto>;
  @useResult
  $Res call(
      {String name, double purchasePrice, double sellingPrice, int stock});
}

/// @nodoc
class _$CreateProductDtoCopyWithImpl<$Res, $Val extends CreateProductDto>
    implements $CreateProductDtoCopyWith<$Res> {
  _$CreateProductDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? purchasePrice = null,
    Object? sellingPrice = null,
    Object? stock = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellingPrice: null == sellingPrice
          ? _value.sellingPrice
          : sellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateProductDtoImplCopyWith<$Res>
    implements $CreateProductDtoCopyWith<$Res> {
  factory _$$CreateProductDtoImplCopyWith(_$CreateProductDtoImpl value,
          $Res Function(_$CreateProductDtoImpl) then) =
      __$$CreateProductDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, double purchasePrice, double sellingPrice, int stock});
}

/// @nodoc
class __$$CreateProductDtoImplCopyWithImpl<$Res>
    extends _$CreateProductDtoCopyWithImpl<$Res, _$CreateProductDtoImpl>
    implements _$$CreateProductDtoImplCopyWith<$Res> {
  __$$CreateProductDtoImplCopyWithImpl(_$CreateProductDtoImpl _value,
      $Res Function(_$CreateProductDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? purchasePrice = null,
    Object? sellingPrice = null,
    Object? stock = null,
  }) {
    return _then(_$CreateProductDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      purchasePrice: null == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as double,
      sellingPrice: null == sellingPrice
          ? _value.sellingPrice
          : sellingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateProductDtoImpl implements _CreateProductDto {
  const _$CreateProductDtoImpl(
      {required this.name,
      required this.purchasePrice,
      required this.sellingPrice,
      required this.stock});

  factory _$CreateProductDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateProductDtoImplFromJson(json);

  @override
  final String name;
  @override
  final double purchasePrice;
  @override
  final double sellingPrice;
  @override
  final int stock;

  @override
  String toString() {
    return 'CreateProductDto(name: $name, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProductDtoImpl &&
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

  /// Create a copy of CreateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProductDtoImplCopyWith<_$CreateProductDtoImpl> get copyWith =>
      __$$CreateProductDtoImplCopyWithImpl<_$CreateProductDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateProductDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateProductDto implements CreateProductDto {
  const factory _CreateProductDto(
      {required final String name,
      required final double purchasePrice,
      required final double sellingPrice,
      required final int stock}) = _$CreateProductDtoImpl;

  factory _CreateProductDto.fromJson(Map<String, dynamic> json) =
      _$CreateProductDtoImpl.fromJson;

  @override
  String get name;
  @override
  double get purchasePrice;
  @override
  double get sellingPrice;
  @override
  int get stock;

  /// Create a copy of CreateProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateProductDtoImplCopyWith<_$CreateProductDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
