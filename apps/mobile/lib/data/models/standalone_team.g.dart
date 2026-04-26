// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standalone_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandaloneTeam _$StandaloneTeamFromJson(Map<String, dynamic> json) =>
    StandaloneTeam(
      id: (json['id'] as num).toInt(),
      emri: json['emri'] as String,
      lloji_sportit: json['lloji_sportit'] as String,
      kapiteni_id: (json['kapiteni_id'] as num).toInt(),
      pershkrim: json['pershkrim'] as String?,
      created_at: DateTime.parse(json['created_at'] as String),
      kapiten: json['kapiten'] == null
          ? null
          : TeamCaptain.fromJson(json['kapiten'] as Map<String, dynamic>),
      anetaret: (json['anetaret'] as List<dynamic>?)
          ?.map((e) => StandaloneTeamMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['_count'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StandaloneTeamToJson(StandaloneTeam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emri': instance.emri,
      'lloji_sportit': instance.lloji_sportit,
      'kapiteni_id': instance.kapiteni_id,
      'pershkrim': instance.pershkrim,
      'created_at': instance.created_at.toIso8601String(),
      'kapiten': instance.kapiten,
      'anetaret': instance.anetaret,
      '_count': instance.count,
    };

TeamCaptain _$TeamCaptainFromJson(Map<String, dynamic> json) =>
    TeamCaptain(id: (json['id'] as num).toInt(), emri: json['emri'] as String);

Map<String, dynamic> _$TeamCaptainToJson(TeamCaptain instance) =>
    <String, dynamic>{'id': instance.id, 'emri': instance.emri};

StandaloneTeamMember _$StandaloneTeamMemberFromJson(
  Map<String, dynamic> json,
) => StandaloneTeamMember(
  id: (json['id'] as num).toInt(),
  ekipi_id: (json['ekipi_id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  roli: json['roli'] as String,
  joined_at: DateTime.parse(json['joined_at'] as String),
  perdoruesi: json['perdoruesi'] == null
      ? null
      : TeamCaptain.fromJson(json['perdoruesi'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StandaloneTeamMemberToJson(
  StandaloneTeamMember instance,
) => <String, dynamic>{
  'id': instance.id,
  'ekipi_id': instance.ekipi_id,
  'userId': instance.userId,
  'roli': instance.roli,
  'joined_at': instance.joined_at.toIso8601String(),
  'perdoruesi': instance.perdoruesi,
};
