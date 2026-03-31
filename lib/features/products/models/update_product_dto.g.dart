// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateProductDtoImpl _$$UpdateProductDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProductDtoImpl(
      name: json['name'] as String?,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UpdateProductDtoImplToJson(
        _$UpdateProductDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
      'stock': instance.stock,
    };
