import 'package:json_annotation/json_annotation.dart';

enum ItemCategory {
  @JsonValue("food")
  food,
  @JsonValue("sport")
  sport,
  @JsonValue("electronics")
  electronics,
  @JsonValue("apparel")
  apparel,
  @JsonValue("other")
  other,
}
