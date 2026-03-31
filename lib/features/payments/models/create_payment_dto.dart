import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_payment_dto.freezed.dart';
part 'create_payment_dto.g.dart';

@freezed
class CreatePaymentDto with _$CreatePaymentDto {
  const factory CreatePaymentDto({
    required String orderId,
    required double amount,
  }) = _CreatePaymentDto;

  factory CreatePaymentDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentDtoFromJson(json);
}
