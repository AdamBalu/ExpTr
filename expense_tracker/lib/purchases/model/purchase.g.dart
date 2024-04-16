// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      json['name'] as String,
      json['description'] as String,
      (json['cost'] as num).toDouble(),
      $enumDecode(_$ItemCategoryEnumMap, json['category']),
      json['id'] as String,
      DateTime.parse(json['date'] as String),
      json['imageUrl'] as String,
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'cost': instance.cost,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'date': instance.date.toIso8601String(),
      'category': _$ItemCategoryEnumMap[instance.category]!,
    };

const _$ItemCategoryEnumMap = {
  ItemCategory.food: 'food',
  ItemCategory.sport: 'sport',
  ItemCategory.electronics: 'electronics',
  ItemCategory.apparel: 'apparel',
  ItemCategory.other: 'other',
};
