import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    @FlexibleIdConverter() required String id,
    required String paymentType,
    required double totalAmount,
    required double paidAmount,
    required double remainingAmount,
    required String status,
    @FlexibleIdConverter() String? customerId,
    @Default([]) List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
