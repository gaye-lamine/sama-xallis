// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: const FlexibleIdConverter().fromJson(json['id']),
      orderId: const FlexibleIdConverter().fromJson(json['orderId']),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIdConverter().toJson(instance.id),
      'orderId': const FlexibleIdConverter().toJson(instance.orderId),
      'amount': instance.amount,
    };
