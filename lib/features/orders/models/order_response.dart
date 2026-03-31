import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_model.dart';
import 'order_item_model.dart';

part 'order_response.freezed.dart';
part 'order_response.g.dart';

@freezed
class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required Order order,
    required List<OrderItem> items,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}
