import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    @FlexibleIdConverter() required String id,
    @FlexibleIdConverter() required String orderId,
    @FlexibleIdConverter() required String productId,
    required int quantity,
    required double unitPrice,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}
