// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateProductDtoImpl _$$CreateProductDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateProductDtoImpl(
      name: json['name'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
    );

Map<String, dynamic> _$$CreateProductDtoImplToJson(
        _$CreateProductDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'purchasePrice': instance.purchasePrice,
      'sellingPrice': instance.sellingPrice,
      'stock': instance.stock,
    };
