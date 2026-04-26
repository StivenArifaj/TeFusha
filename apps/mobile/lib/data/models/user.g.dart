// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  emri: json['emri'] as String,
  email: json['email'] as String,
  nr_telefoni: json['nr_telefoni'] as String?,
  roli: json['roli'] as String,
  data_regjistrimit: json['data_regjistrimit'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'emri': instance.emri,
  'email': instance.email,
  'nr_telefoni': instance.nr_telefoni,
  'roli': instance.roli,
  'data_regjistrimit': instance.data_regjistrimit,
};
