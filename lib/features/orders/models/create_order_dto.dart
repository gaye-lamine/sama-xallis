import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item_input.dart';

part 'create_order_dto.freezed.dart';
part 'create_order_dto.g.dart';

enum PaymentType {
  @JsonValue('cash')
  cash,
  @JsonValue('credit')
  credit,
}

@freezed
class CreateOrderDto with _$CreateOrderDto {
  const factory CreateOrderDto({
    required PaymentType paymentType,
    required List<OrderItemInput> items,
    String? customerId,
    double? paidAmount,
  }) = _CreateOrderDto;

  factory CreateOrderDto.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderDtoFromJson(json);
}
