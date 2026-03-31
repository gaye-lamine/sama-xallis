// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: const FlexibleIdConverter().fromJson(json['id']),
      name: json['name'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIdConverter().toJson(instance.id),
      'name': instance.name,
      'phone': instance.phone,
    };
