import 'package:expense_tracker/common/enums/saving_category.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/timestamp_converter.dart';

part 'budget.g.dart';

@JsonSerializable()
class Budget {
  final String id;
  final ItemCategory itemCategory;

  // original value
  final double value;

  // spent value
  final double usedValue;

  Budget(this.itemCategory, this.value, this.usedValue, this.id);

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetToJson(this);

  Budget copyWith({String? id, ItemCategory? itemCategory, double? value, double? usedValue}) {
    return Budget(
      itemCategory ?? this.itemCategory,
      value ?? this.value,
      usedValue ?? this.usedValue,
      id ?? this.id,
    );
  }
}
