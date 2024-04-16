// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
      (json['users'] as List<dynamic>).map((e) => e as String).toList(),
      (json['budget'] as num).toDouble(),
      (json['extraBudget'] as num).toDouble(),
      (json['savings'] as List<dynamic>).map((e) => e as String).toList(),
      json['name'] as String,
      json['id'] as String,
      const TimestampConverter().fromJson(json['timestamp']),
      (json['purchases'] as List<dynamic>).map((e) => e as String).toList(),
      Plan._boolFromInt(json['isPersonal'] as int),
      (json['categoryBudgets'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      const TimestampConverter().fromJson(json['intervalStart']),
      json['intervalDuration'] as int,
      json['intervalCount'] as int,
      json['ownerId'] as String,
    );

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'users': instance.users,
      'savings': instance.savings,
      'purchases': instance.purchases,
      'categoryBudgets': instance.categoryBudgets,
      'name': instance.name,
      'budget': instance.budget,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
      'extraBudget': instance.extraBudget,
      'id': instance.id,
      'intervalStart':
          const TimestampConverter().toJson(instance.intervalStart),
      'intervalCount': instance.intervalCount,
      'intervalDuration': instance.intervalDuration,
      'isPersonal': Plan._boolToInt(instance.isPersonal),
      'ownerId': instance.ownerId,
    };
