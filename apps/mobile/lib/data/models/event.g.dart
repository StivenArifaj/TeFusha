// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
  id: (json['id'] as num).toInt(),
  emri: json['emri'] as String,
  eventi_id: (json['eventi_id'] as num).toInt(),
);

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
  'id': instance.id,
  'emri': instance.emri,
  'eventi_id': instance.eventi_id,
};

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
  id: (json['id'] as num).toInt(),
  eventi_id: (json['eventi_id'] as num).toInt(),
  ekipi_shtepi_id: (json['ekipi_shtepi_id'] as num).toInt(),
  ekipi_udhetimit_id: (json['ekipi_udhetimit_id'] as num).toInt(),
  gola_shtepi: (json['gola_shtepi'] as num?)?.toInt(),
  gola_udhetimit: (json['gola_udhetimit'] as num?)?.toInt(),
  data_ndeshjes: json['data_ndeshjes'] as String?,
  raundi: (json['raundi'] as num).toInt(),
  ekipi_shtepi: json['ekipi_shtepi'] == null
      ? null
      : Team.fromJson(json['ekipi_shtepi'] as Map<String, dynamic>),
  ekipi_udhetimit: json['ekipi_udhetimit'] == null
      ? null
      : Team.fromJson(json['ekipi_udhetimit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
  'id': instance.id,
  'eventi_id': instance.eventi_id,
  'ekipi_shtepi_id': instance.ekipi_shtepi_id,
  'ekipi_udhetimit_id': instance.ekipi_udhetimit_id,
  'gola_shtepi': instance.gola_shtepi,
  'gola_udhetimit': instance.gola_udhetimit,
  'data_ndeshjes': instance.data_ndeshjes,
  'raundi': instance.raundi,
  'ekipi_shtepi': instance.ekipi_shtepi,
  'ekipi_udhetimit': instance.ekipi_udhetimit,
};

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  id: (json['id'] as num).toInt(),
  emri_eventit: json['emri_eventit'] as String,
  lloji: json['lloji'] as String,
  pershkrimi: json['pershkrimi'] as String?,
  fusha_id: (json['fusha_id'] as num).toInt(),
  data_fillimit: json['data_fillimit'] as String,
  data_mbarimit: json['data_mbarimit'] as String,
  nr_max_ekipesh: (json['nr_max_ekipesh'] as num).toInt(),
  organizatori_id: (json['organizatori_id'] as num).toInt(),
  statusi: json['statusi'] as String,
  fusha: json['fusha'] == null
      ? null
      : Field.fromJson(json['fusha'] as Map<String, dynamic>),
  ekipet: (json['ekipet'] as List<dynamic>?)
      ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
      .toList(),
  ndeshjet: (json['ndeshjet'] as List<dynamic>?)
      ?.map((e) => Match.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'id': instance.id,
  'emri_eventit': instance.emri_eventit,
  'lloji': instance.lloji,
  'pershkrimi': instance.pershkrimi,
  'fusha_id': instance.fusha_id,
  'data_fillimit': instance.data_fillimit,
  'data_mbarimit': instance.data_mbarimit,
  'nr_max_ekipesh': instance.nr_max_ekipesh,
  'organizatori_id': instance.organizatori_id,
  'statusi': instance.statusi,
  'fusha': instance.fusha,
  'ekipet': instance.ekipet,
  'ndeshjet': instance.ndeshjet,
};
