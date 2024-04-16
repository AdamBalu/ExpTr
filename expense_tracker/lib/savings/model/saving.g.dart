// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saving.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Saving _$SavingFromJson(Map<String, dynamic> json) => Saving(
      json['name'] as String,
      json['id'] as String,
      (json['currentValue'] as num).toDouble(),
      (json['requiredValue'] as num).toDouble(),
      json['color'] as int,
    );

Map<String, dynamic> _$SavingToJson(Saving instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'currentValue': instance.currentValue,
      'requiredValue': instance.requiredValue,
      'color': instance.color,
    };
