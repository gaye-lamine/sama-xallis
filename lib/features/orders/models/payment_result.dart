import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_result.freezed.dart';
part 'payment_result.g.dart';

@freezed
class PaymentResult with _$PaymentResult {
  const factory PaymentResult({
    required double paidAmount,
    required double remainingAmount,
    required String status,
  }) = _PaymentResult;

  factory PaymentResult.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultFromJson(json);
}
