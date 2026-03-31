import 'package:json_annotation/json_annotation.dart';

class FlexibleIdConverter implements JsonConverter<String, dynamic> {
  const FlexibleIdConverter();

  @override
  String fromJson(dynamic json) => json.toString();

  @override
  dynamic toJson(String id) => id;
}
