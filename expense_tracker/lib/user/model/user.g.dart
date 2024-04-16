// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['username'] as String,
      json['id'] as String,
      (json['invitations'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
      'invitations': instance.invitations,
    };
