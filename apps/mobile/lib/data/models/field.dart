import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'field.g.dart';

@JsonSerializable()
class Field {
  final int id;
  final String emri_fushes;
  final String lloji_fushes;
  final String vendndodhja;
  final String qyteti;
  @JsonKey(fromJson: _stringToDouble, toJson: _doubleToString)
  final double cmimi_orari;
  final int kapaciteti;
  final String? pajisjet;
  final String statusi;
  final double? lat;
  final double? lng;
  final int pronari_id;
  final User? pronari;

  Field({
    required this.id,
    required this.emri_fushes,
    required this.lloji_fushes,
    required this.vendndodhja,
    required this.qyteti,
    required this.cmimi_orari,
    required this.kapaciteti,
    this.pajisjet,
    required this.statusi,
    this.lat,
    this.lng,
    required this.pronari_id,
    this.pronari,
  });

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
  Map<String, dynamic> toJson() => _$FieldToJson(this);

  static double _stringToDouble(dynamic value) => double.parse(value.toString());
  static String _doubleToString(double value) => value.toString();
}
