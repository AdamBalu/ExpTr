// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Budget _$BudgetFromJson(Map<String, dynamic> json) => Budget(
      $enumDecode(_$ItemCategoryEnumMap, json['itemCategory']),
      (json['value'] as num).toDouble(),
      (json['usedValue'] as num).toDouble(),
      json['id'] as String,
    );

Map<String, dynamic> _$BudgetToJson(Budget instance) => <String, dynamic>{
      'id': instance.id,
      'itemCategory': _$ItemCategoryEnumMap[instance.itemCategory]!,
      'value': instance.value,
      'usedValue': instance.usedValue,
    };

const _$ItemCategoryEnumMap = {
  ItemCategory.food: 'food',
  ItemCategory.sport: 'sport',
  ItemCategory.electronics: 'electronics',
  ItemCategory.apparel: 'apparel',
  ItemCategory.other: 'other',
};
