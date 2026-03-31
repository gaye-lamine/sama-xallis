import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_debt_dto.freezed.dart';
part 'create_debt_dto.g.dart';

@freezed
class CreateDebtDto with _$CreateDebtDto {
  const factory CreateDebtDto({
    required String customerId,
    required double amount,
    required String description,
    String? dueDate,
    String? status,
  }) = _CreateDebtDto;

  factory CreateDebtDto.fromJson(Map<String, dynamic> json) =>
      _$CreateDebtDtoFromJson(json);
}
