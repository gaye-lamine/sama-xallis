// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentResultImpl _$$PaymentResultImplFromJson(Map<String, dynamic> json) =>
    _$PaymentResultImpl(
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$PaymentResultImplToJson(_$PaymentResultImpl instance) =>
    <String, dynamic>{
      'paidAmount': instance.paidAmount,
      'remainingAmount': instance.remainingAmount,
      'status': instance.status,
    };
