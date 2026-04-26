import 'package:json_annotation/json_annotation.dart';
import 'field.dart';
import 'user.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final int id;
  final int fusha_id;
  final int perdoruesi_id;
  final String data_rezervimit;
  final String ora_fillimit;
  final String ora_mbarimit;
  final String statusi;
  @JsonKey(fromJson: _stringToDouble, toJson: _doubleToString)
  final double cmimi_total;
  final String data_krijimit;
  final Field? fusha;
  final User? perdoruesi;

  Booking({
    required this.id,
    required this.fusha_id,
    required this.perdoruesi_id,
    required this.data_rezervimit,
    required this.ora_fillimit,
    required this.ora_mbarimit,
    required this.statusi,
    required this.cmimi_total,
    required this.data_krijimit,
    this.fusha,
    this.perdoruesi,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);

  static double _stringToDouble(dynamic value) => double.parse(value.toString());
  static String _doubleToString(double value) => value.toString();
}