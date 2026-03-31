// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_order_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateOrderDto _$CreateOrderDtoFromJson(Map<String, dynamic> json) {
  return _CreateOrderDto.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderDto {
  PaymentType get paymentType => throw _privateConstructorUsedError;
  List<OrderItemInput> get items => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  double? get paidAmount => throw _privateConstructorUsedError;

  /// Serializes this CreateOrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrderDtoCopyWith<CreateOrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderDtoCopyWith<$Res> {
  factory $CreateOrderDtoCopyWith(
          CreateOrderDto value, $Res Function(CreateOrderDto) then) =
      _$CreateOrderDtoCopyWithImpl<$Res, CreateOrderDto>;
  @useResult
  $Res call(
      {PaymentType paymentType,
      List<OrderItemInput> items,
      String? customerId,
      double? paidAmount});
}

/// @nodoc
class _$CreateOrderDtoCopyWithImpl<$Res, $Val extends CreateOrderDto>
    implements $CreateOrderDtoCopyWith<$Res> {
  _$CreateOrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentType = null,
    Object? items = null,
    Object? customerId = freezed,
    Object? paidAmount = freezed,
  }) {
    return _then(_value.copyWith(
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemInput>,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAmount: freezed == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateOrderDtoImplCopyWith<$Res>
    implements $CreateOrderDtoCopyWith<$Res> {
  factory _$$CreateOrderDtoImplCopyWith(_$CreateOrderDtoImpl value,
          $Res Function(_$CreateOrderDtoImpl) then) =
      __$$CreateOrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PaymentType paymentType,
      List<OrderItemInput> items,
      String? customerId,
      double? paidAmount});
}

/// @nodoc
class __$$CreateOrderDtoImplCopyWithImpl<$Res>
    extends _$CreateOrderDtoCopyWithImpl<$Res, _$CreateOrderDtoImpl>
    implements _$$CreateOrderDtoImplCopyWith<$Res> {
  __$$CreateOrderDtoImplCopyWithImpl(
      _$CreateOrderDtoImpl _value, $Res Function(_$CreateOrderDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentType = null,
    Object? items = null,
    Object? customerId = freezed,
    Object? paidAmount = freezed,
  }) {
    return _then(_$CreateOrderDtoImpl(
      paymentType: null == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemInput>,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAmount: freezed == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderDtoImpl implements _CreateOrderDto {
  const _$CreateOrderDtoImpl(
      {required this.paymentType,
      required final List<OrderItemInput> items,
      this.customerId,
      this.paidAmount})
      : _items = items;

  factory _$CreateOrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderDtoImplFromJson(json);

  @override
  final PaymentType paymentType;
  final List<OrderItemInput> _items;
  @override
  List<OrderItemInput> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? customerId;
  @override
  final double? paidAmount;

  @override
  String toString() {
    return 'CreateOrderDto(paymentType: $paymentType, items: $items, customerId: $customerId, paidAmount: $paidAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderDtoImpl &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, paymentType,
      const DeepCollectionEquality().hash(_items), customerId, paidAmount);

  /// Create a copy of CreateOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderDtoImplCopyWith<_$CreateOrderDtoImpl> get copyWith =>
      __$$CreateOrderDtoImplCopyWithImpl<_$CreateOrderDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateOrderDto implements CreateOrderDto {
  const factory _CreateOrderDto(
      {required final PaymentType paymentType,
      required final List<OrderItemInput> items,
      final String? customerId,
      final double? paidAmount}) = _$CreateOrderDtoImpl;

  factory _CreateOrderDto.fromJson(Map<String, dynamic> json) =
      _$CreateOrderDtoImpl.fromJson;

  @override
  PaymentType get paymentType;
  @override
  List<OrderItemInput> get items;
  @override
  String? get customerId;
  @override
  double? get paidAmount;

  /// Create a copy of CreateOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrderDtoImplCopyWith<_$CreateOrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
