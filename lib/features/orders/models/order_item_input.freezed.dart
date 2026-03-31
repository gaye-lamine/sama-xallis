// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderItemInput _$OrderItemInputFromJson(Map<String, dynamic> json) {
  return _OrderItemInput.fromJson(json);
}

/// @nodoc
mixin _$OrderItemInput {
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double? get unitPrice => throw _privateConstructorUsedError;

  /// Serializes this OrderItemInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemInputCopyWith<OrderItemInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemInputCopyWith<$Res> {
  factory $OrderItemInputCopyWith(
          OrderItemInput value, $Res Function(OrderItemInput) then) =
      _$OrderItemInputCopyWithImpl<$Res, OrderItemInput>;
  @useResult
  $Res call({String productId, int quantity, double? unitPrice});
}

/// @nodoc
class _$OrderItemInputCopyWithImpl<$Res, $Val extends OrderItemInput>
    implements $OrderItemInputCopyWith<$Res> {
  _$OrderItemInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? quantity = null,
    Object? unitPrice = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemInputImplCopyWith<$Res>
    implements $OrderItemInputCopyWith<$Res> {
  factory _$$OrderItemInputImplCopyWith(_$OrderItemInputImpl value,
          $Res Function(_$OrderItemInputImpl) then) =
      __$$OrderItemInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productId, int quantity, double? unitPrice});
}

/// @nodoc
class __$$OrderItemInputImplCopyWithImpl<$Res>
    extends _$OrderItemInputCopyWithImpl<$Res, _$OrderItemInputImpl>
    implements _$$OrderItemInputImplCopyWith<$Res> {
  __$$OrderItemInputImplCopyWithImpl(
      _$OrderItemInputImpl _value, $Res Function(_$OrderItemInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItemInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? quantity = null,
    Object? unitPrice = freezed,
  }) {
    return _then(_$OrderItemInputImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemInputImpl implements _OrderItemInput {
  const _$OrderItemInputImpl(
      {required this.productId, required this.quantity, this.unitPrice});

  factory _$OrderItemInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemInputImplFromJson(json);

  @override
  final String productId;
  @override
  final int quantity;
  @override
  final double? unitPrice;

  @override
  String toString() {
    return 'OrderItemInput(productId: $productId, quantity: $quantity, unitPrice: $unitPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemInputImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, quantity, unitPrice);

  /// Create a copy of OrderItemInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemInputImplCopyWith<_$OrderItemInputImpl> get copyWith =>
      __$$OrderItemInputImplCopyWithImpl<_$OrderItemInputImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemInputImplToJson(
      this,
    );
  }
}

abstract class _OrderItemInput implements OrderItemInput {
  const factory _OrderItemInput(
      {required final String productId,
      required final int quantity,
      final double? unitPrice}) = _$OrderItemInputImpl;

  factory _OrderItemInput.fromJson(Map<String, dynamic> json) =
      _$OrderItemInputImpl.fromJson;

  @override
  String get productId;
  @override
  int get quantity;
  @override
  double? get unitPrice;

  /// Create a copy of OrderItemInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemInputImplCopyWith<_$OrderItemInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
