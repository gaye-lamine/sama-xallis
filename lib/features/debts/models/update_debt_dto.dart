import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_debt_dto.freezed.dart';
part 'update_debt_dto.g.dart';

@freezed
class UpdateDebtDto with _$UpdateDebtDto {
  const factory UpdateDebtDto({
    double? amount,
    String? description,
    String? status,
    String? dueDate,
  }) = _UpdateDebtDto;

  factory UpdateDebtDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateDebtDtoFromJson(json);
}
