// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebtImpl _$$DebtImplFromJson(Map<String, dynamic> json) => _$DebtImpl(
      id: const FlexibleIdConverter().fromJson(json['id']),
      customerId: const FlexibleIdConverter().fromJson(json['customerId']),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      status: json['status'] as String,
      dueDate: json['dueDate'] as String?,
    );

Map<String, dynamic> _$$DebtImplToJson(_$DebtImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIdConverter().toJson(instance.id),
      'customerId': const FlexibleIdConverter().toJson(instance.customerId),
      'amount': instance.amount,
      'description': instance.description,
      'status': instance.status,
      'dueDate': instance.dueDate,
    };
