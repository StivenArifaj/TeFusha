import 'package:json_annotation/json_annotation.dart';

part 'standalone_team.g.dart';

@JsonSerializable()
class StandaloneTeam {
  final int id;
  final String emri;
  final String lloji_sportit;
  final int kapiteni_id;
  final String? pershkrim;
  final DateTime created_at;
  final TeamCaptain? kapiten;
  final List<StandaloneTeamMember>? anetaret;
  @JsonKey(name: '_count')
  final Map<String, dynamic>? count;

  StandaloneTeam({
    required this.id,
    required this.emri,
    required this.lloji_sportit,
    required this.kapiteni_id,
    this.pershkrim,
    required this.created_at,
    this.kapiten,
    this.anetaret,
    this.count,
  });

  int get memberCount => count?['anetaret'] ?? (anetaret?.length ?? 0);

  factory StandaloneTeam.fromJson(Map<String, dynamic> json) => _$StandaloneTeamFromJson(json);
  Map<String, dynamic> toJson() => _$StandaloneTeamToJson(this);
}

@JsonSerializable()
class TeamCaptain {
  final int id;
  final String emri;

  TeamCaptain({required this.id, required this.emri});

  factory TeamCaptain.fromJson(Map<String, dynamic> json) => _$TeamCaptainFromJson(json);
  Map<String, dynamic> toJson() => _$TeamCaptainToJson(this);
}

@JsonSerializable()
class StandaloneTeamMember {
  final int id;
  final int ekipi_id;
  final int userId;
  final String roli;
  final DateTime joined_at;
  final TeamCaptain? perdoruesi;

  StandaloneTeamMember({
    required this.id,
    required this.ekipi_id,
    required this.userId,
    required this.roli,
    required this.joined_at,
    this.perdoruesi,
  });

  factory StandaloneTeamMember.fromJson(Map<String, dynamic> json) => _$StandaloneTeamMemberFromJson(json);
  Map<String, dynamic> toJson() => _$StandaloneTeamMemberToJson(this);
}
