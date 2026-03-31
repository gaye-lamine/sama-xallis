// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrderDtoImpl _$$CreateOrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$CreateOrderDtoImpl(
      paymentType: $enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerId: json['customerId'] as String?,
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CreateOrderDtoImplToJson(
        _$CreateOrderDtoImpl instance) =>
    <String, dynamic>{
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
      'items': instance.items,
      'customerId': instance.customerId,
      'paidAmount': instance.paidAmount,
    };

const _$PaymentTypeEnumMap = {
  PaymentType.cash: 'cash',
  PaymentType.credit: 'credit',
};
