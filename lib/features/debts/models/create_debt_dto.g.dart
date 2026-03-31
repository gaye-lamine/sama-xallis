// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_debt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateDebtDtoImpl _$$CreateDebtDtoImplFromJson(Map<String, dynamic> json) =>
    _$CreateDebtDtoImpl(
      customerId: json['customerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      dueDate: json['dueDate'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$CreateDebtDtoImplToJson(_$CreateDebtDtoImpl instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'amount': instance.amount,
      'description': instance.description,
      'dueDate': instance.dueDate,
      'status': instance.status,
    };
