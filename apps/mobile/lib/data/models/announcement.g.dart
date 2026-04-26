// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  titull: json['titull'] as String,
  pershkrim: json['pershkrim'] as String,
  lloji_sportit: json['lloji_sportit'] as String,
  vendndodhja: json['vendndodhja'] as String?,
  data_lojes: json['data_lojes'] as String?,
  lojtare_nevojitet: (json['lojtare_nevojitet'] as num).toInt(),
  tipi: $enumDecode(_$AnnouncementTypeEnumMap, json['tipi']),
  statusi: json['statusi'] as String,
  created_at: DateTime.parse(json['created_at'] as String),
  perdoruesi: json['perdoruesi'] == null
      ? null
      : AnnouncementUser.fromJson(json['perdoruesi'] as Map<String, dynamic>),
  pergjigjet: (json['pergjigjet'] as List<dynamic>?)
      ?.map((e) => AnnouncementResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'titull': instance.titull,
      'pershkrim': instance.pershkrim,
      'lloji_sportit': instance.lloji_sportit,
      'vendndodhja': instance.vendndodhja,
      'data_lojes': instance.data_lojes,
      'lojtare_nevojitet': instance.lojtare_nevojitet,
      'tipi': _$AnnouncementTypeEnumMap[instance.tipi]!,
      'statusi': instance.statusi,
      'created_at': instance.created_at.toIso8601String(),
      'perdoruesi': instance.perdoruesi,
      'pergjigjet': instance.pergjigjet,
    };

const _$AnnouncementTypeEnumMap = {
  AnnouncementType.kerkoLojtar: 'kerko_lojtar',
  AnnouncementType.kerkoKundershtare: 'kerko_kundershtare',
  AnnouncementType.kerkoEkip: 'kerko_ekip',
};

AnnouncementUser _$AnnouncementUserFromJson(Map<String, dynamic> json) =>
    AnnouncementUser(
      id: (json['id'] as num).toInt(),
      emri: json['emri'] as String,
    );

Map<String, dynamic> _$AnnouncementUserToJson(AnnouncementUser instance) =>
    <String, dynamic>{'id': instance.id, 'emri': instance.emri};

AnnouncementResponse _$AnnouncementResponseFromJson(
  Map<String, dynamic> json,
) => AnnouncementResponse(
  id: (json['id'] as num).toInt(),
  announcementId: (json['announcementId'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  mesazhi: json['mesazhi'] as String?,
  created_at: DateTime.parse(json['created_at'] as String),
  perdoruesi: json['perdoruesi'] == null
      ? null
      : AnnouncementUser.fromJson(json['perdoruesi'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnnouncementResponseToJson(
  AnnouncementResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'announcementId': instance.announcementId,
  'userId': instance.userId,
  'mesazhi': instance.mesazhi,
  'created_at': instance.created_at.toIso8601String(),
  'perdoruesi': instance.perdoruesi,
};
