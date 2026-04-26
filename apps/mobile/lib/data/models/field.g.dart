// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
  id: (json['id'] as num).toInt(),
  emri_fushes: json['emri_fushes'] as String,
  lloji_fushes: json['lloji_fushes'] as String,
  vendndodhja: json['vendndodhja'] as String,
  qyteti: json['qyteti'] as String,
  cmimi_orari: Field._stringToDouble(json['cmimi_orari']),
  kapaciteti: (json['kapaciteti'] as num).toInt(),
  pajisjet: json['pajisjet'] as String?,
  statusi: json['statusi'] as String,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  pronari_id: (json['pronari_id'] as num).toInt(),
  pronari: json['pronari'] == null
      ? null
      : User.fromJson(json['pronari'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
  'id': instance.id,
  'emri_fushes': instance.emri_fushes,
  'lloji_fushes': instance.lloji_fushes,
  'vendndodhja': instance.vendndodhja,
  'qyteti': instance.qyteti,
  'cmimi_orari': Field._doubleToString(instance.cmimi_orari),
  'kapaciteti': instance.kapaciteti,
  'pajisjet': instance.pajisjet,
  'statusi': instance.statusi,
  'lat': instance.lat,
  'lng': instance.lng,
  'pronari_id': instance.pronari_id,
  'pronari': instance.pronari,
};
