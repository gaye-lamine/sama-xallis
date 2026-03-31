// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: const FlexibleIdConverter().fromJson(json['id']),
      orderId: const FlexibleIdConverter().fromJson(json['orderId']),
      productId: const FlexibleIdConverter().fromJson(json['productId']),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIdConverter().toJson(instance.id),
      'orderId': const FlexibleIdConverter().toJson(instance.orderId),
      'productId': const FlexibleIdConverter().toJson(instance.productId),
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
