import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_product_dto.freezed.dart';
part 'create_product_dto.g.dart';

@freezed
class CreateProductDto with _$CreateProductDto {
  const factory CreateProductDto({
    required String name,
    required double purchasePrice,
    required double sellingPrice,
    required int stock,
  }) = _CreateProductDto;

  factory CreateProductDto.fromJson(Map<String, dynamic> json) =>
      _$CreateProductDtoFromJson(json);
}
