// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: const FlexibleIdConverter().fromJson(json['id']),
      paymentType: json['paymentType'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      status: json['status'] as String,
      customerId: const FlexibleIdConverter().fromJson(json['customerId']),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIdConverter().toJson(instance.id),
      'paymentType': instance.paymentType,
      'totalAmount': instance.totalAmount,
      'paidAmount': instance.paidAmount,
      'remainingAmount': instance.remainingAmount,
      'status': instance.status,
      'customerId': _$JsonConverterToJson<dynamic, String>(
          instance.customerId, const FlexibleIdConverter().toJson),
      'items': instance.items,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
