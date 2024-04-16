import 'package:json_annotation/json_annotation.dart';

import '../../common/enums/saving_category.dart';

part 'saving.g.dart';

@JsonSerializable()
class Saving {
  static const SAVINGS_KEY = 'savings';

  final String name;
  final String id;
  final double currentValue;
  final double requiredValue;
  @JsonKey(name: SAVINGS_KEY)
  final int color;

  Saving(this.name, this.id, this.currentValue, this.requiredValue, this.color);

  factory Saving.fromJson(Map<String, dynamic> json) => _$SavingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SavingToJson(this);
}
