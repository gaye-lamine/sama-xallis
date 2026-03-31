// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemInputImpl _$$OrderItemInputImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemInputImpl(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$OrderItemInputImplToJson(
        _$OrderItemInputImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
