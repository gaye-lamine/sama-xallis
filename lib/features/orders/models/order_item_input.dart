import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_input.freezed.dart';
part 'order_item_input.g.dart';

@freezed
class OrderItemInput with _$OrderItemInput {
  const factory OrderItemInput({
    required String productId,
    required int quantity,
    double? unitPrice,
  }) = _OrderItemInput;

  factory OrderItemInput.fromJson(Map<String, dynamic> json) =>
      _$OrderItemInputFromJson(json);
}
