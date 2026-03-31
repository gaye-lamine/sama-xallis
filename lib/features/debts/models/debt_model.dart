import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'debt_model.freezed.dart';
part 'debt_model.g.dart';

@freezed
class Debt with _$Debt {
  const factory Debt({
    @FlexibleIdConverter() required String id,
    @FlexibleIdConverter() required String customerId,
    required double amount,
    required String description,
    required String status,
    String? dueDate,
  }) = _Debt;

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
}
