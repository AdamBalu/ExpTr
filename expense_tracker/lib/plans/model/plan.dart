import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/timestamp_converter.dart';

part 'plan.g.dart';

@JsonSerializable()
class Plan {
  final List<String> users;
  final List<String> savings;
  final List<String> purchases;
  final List<String> categoryBudgets;

  final String name;
  final double budget;

  @TimestampConverter()
  final DateTime? timestamp;
  final double extraBudget;
  final String id;

  @TimestampConverter()
  final DateTime? intervalStart;
  final int intervalCount;
  final int intervalDuration;

  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  final bool isPersonal;

  final String ownerId;

  static bool _boolFromInt(int done) => done == 1;
  static int _boolToInt(bool done) => done ? 1 : 0;

  Plan(
      this.users,
      this.budget,
      this.extraBudget,
      this.savings,
      this.name,
      this.id,
      this.timestamp,
      this.purchases,
      this.isPersonal,
      this.categoryBudgets,
      this.intervalStart,
      this.intervalDuration,
      this.intervalCount,
      this.ownerId);

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  Map<String, dynamic> toJson() => _$PlanToJson(this);

  Plan copyWith(
      {List<String>? users,
      List<String>? savings,
      List<String>? purchases,
      List<String>? categoryBudgets,
      String? name,
      double? budget,
      DateTime? timestamp,
      double? extraBudget,
      String? id,
      DateTime? intervalStart,
      int? intervalCount,
      int? intervalDuration,
      bool? isPersonal,
      String? ownerId}) {
    return Plan(
        users ?? this.users,
        budget ?? this.budget,
        extraBudget ?? this.extraBudget,
        savings ?? this.savings,
        name ?? this.name,
        id ?? this.id,
        timestamp ?? this.timestamp,
        purchases ?? this.purchases,
        isPersonal ?? this.isPersonal,
        categoryBudgets ?? this.categoryBudgets,
        intervalStart ?? this.intervalStart,
        intervalDuration ?? this.intervalDuration,
        intervalCount ?? this.intervalCount,
        ownerId ?? this.ownerId);
  }
}
