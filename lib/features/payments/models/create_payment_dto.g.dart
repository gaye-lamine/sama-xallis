// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePaymentDtoImpl _$$CreatePaymentDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePaymentDtoImpl(
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$CreatePaymentDtoImplToJson(
        _$CreatePaymentDtoImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amount': instance.amount,
    };
