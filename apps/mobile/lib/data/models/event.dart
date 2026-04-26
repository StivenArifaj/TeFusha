import 'package:json_annotation/json_annotation.dart';
import 'field.dart';

part 'event.g.dart';

@JsonSerializable()
class Team {
  final int id;
  final String emri;
  final int eventi_id;

  Team({
    required this.id,
    required this.emri,
    required this.eventi_id,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

@JsonSerializable()
class Match {
  final int id;
  final int eventi_id;
  final int ekipi_shtepi_id;
  final int ekipi_udhetimit_id;
  final int? gola_shtepi;
  final int? gola_udhetimit;
  final String? data_ndeshjes;
  final int raundi;
  final Team? ekipi_shtepi;
  final Team? ekipi_udhetimit;

  Match({
    required this.id,
    required this.eventi_id,
    required this.ekipi_shtepi_id,
    required this.ekipi_udhetimit_id,
    this.gola_shtepi,
    this.gola_udhetimit,
    this.data_ndeshjes,
    required this.raundi,
    this.ekipi_shtepi,
    this.ekipi_udhetimit,
  });

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}

@JsonSerializable()
class Event {
  final int id;
  final String emri_eventit;
  final String lloji;
  final String? pershkrimi;
  final int fusha_id;
  final String data_fillimit;
  final String data_mbarimit;
  final int nr_max_ekipesh;
  final int organizatori_id;
  final String statusi;
  final Field? fusha;
  final List<Team>? ekipet;
  final List<Match>? ndeshjet;

  Event({
    required this.id,
    required this.emri_eventit,
    required this.lloji,
    this.pershkrimi,
    required this.fusha_id,
    required this.data_fillimit,
    required this.data_mbarimit,
    required this.nr_max_ekipesh,
    required this.organizatori_id,
    required this.statusi,
    this.fusha,
    this.ekipet,
    this.ndeshjet,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
