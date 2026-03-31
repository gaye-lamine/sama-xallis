import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    @FlexibleIdConverter() required String id,
    @FlexibleIdConverter() required String orderId,
    required double amount,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
