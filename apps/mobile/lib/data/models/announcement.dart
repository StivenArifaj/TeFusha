import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

enum AnnouncementType {
  @JsonValue('kerko_lojtar') kerkoLojtar,
  @JsonValue('kerko_kundershtare') kerkoKundershtare,
  @JsonValue('kerko_ekip') kerkoEkip
}

@JsonSerializable()
class Announcement {
  final int id;
  final int userId;
  final String titull;
  final String pershkrim;
  final String lloji_sportit;
  final String? vendndodhja;
  final String? data_lojes;
  final int lojtare_nevojitet;
  final AnnouncementType tipi;
  final String statusi;
  final DateTime created_at;
  final AnnouncementUser? perdoruesi;
  final List<AnnouncementResponse>? pergjigjet;

  Announcement({
    required this.id,
    required this.userId,
    required this.titull,
    required this.pershkrim,
    required this.lloji_sportit,
    this.vendndodhja,
    this.data_lojes,
    required this.lojtare_nevojitet,
    required this.tipi,
    required this.statusi,
    required this.created_at,
    this.perdoruesi,
    this.pergjigjet,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}

@JsonSerializable()
class AnnouncementUser {
  final int id;
  final String emri;

  AnnouncementUser({required this.id, required this.emri});

  factory AnnouncementUser.fromJson(Map<String, dynamic> json) => _$AnnouncementUserFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementUserToJson(this);
}

@JsonSerializable()
class AnnouncementResponse {
  final int id;
  final int announcementId;
  final int userId;
  final String? mesazhi;
  final DateTime created_at;
  final AnnouncementUser? perdoruesi;

  AnnouncementResponse({
    required this.id,
    required this.announcementId,
    required this.userId,
    this.mesazhi,
    required this.created_at,
    this.perdoruesi,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) => _$AnnouncementResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementResponseToJson(this);
}
