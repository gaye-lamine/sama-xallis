import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_product_dto.freezed.dart';
part 'update_product_dto.g.dart';

@freezed
class UpdateProductDto with _$UpdateProductDto {
  const factory UpdateProductDto({
    String? name,
    double? purchasePrice,
    double? sellingPrice,
    int? stock,
  }) = _UpdateProductDto;

  factory UpdateProductDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductDtoFromJson(json);
}
