import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String emri;
  final String email;
  final String? nr_telefoni;
  final String roli;
  final String data_regjistrimit;

  User({
    required this.id,
    required this.emri,
    required this.email,
    this.nr_telefoni,
    required this.roli,
    required this.data_regjistrimit,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
