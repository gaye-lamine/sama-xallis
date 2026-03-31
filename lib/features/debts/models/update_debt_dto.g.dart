// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_debt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateDebtDtoImpl _$$UpdateDebtDtoImplFromJson(Map<String, dynamic> json) =>
    _$UpdateDebtDtoImpl(
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      status: json['status'] as String?,
      dueDate: json['dueDate'] as String?,
    );

Map<String, dynamic> _$$UpdateDebtDtoImplToJson(_$UpdateDebtDtoImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'description': instance.description,
      'status': instance.status,
      'dueDate': instance.dueDate,
    };
