// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: (json['id'] as num).toInt(),
  fusha_id: (json['fusha_id'] as num).toInt(),
  perdoruesi_id: (json['perdoruesi_id'] as num).toInt(),
  data_rezervimit: json['data_rezervimit'] as String,
  ora_fillimit: json['ora_fillimit'] as String,
  ora_mbarimit: json['ora_mbarimit'] as String,
  statusi: json['statusi'] as String,
  cmimi_total: Booking._stringToDouble(json['cmimi_total']),
  data_krijimit: json['data_krijimit'] as String,
  fusha: json['fusha'] == null
      ? null
      : Field.fromJson(json['fusha'] as Map<String, dynamic>),
  perdoruesi: json['perdoruesi'] == null
      ? null
      : User.fromJson(json['perdoruesi'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'fusha_id': instance.fusha_id,
  'perdoruesi_id': instance.perdoruesi_id,
  'data_rezervimit': instance.data_rezervimit,
  'ora_fillimit': instance.ora_fillimit,
  'ora_mbarimit': instance.ora_mbarimit,
  'statusi': instance.statusi,
  'cmimi_total': Booking._doubleToString(instance.cmimi_total),
  'data_krijimit': instance.data_krijimit,
  'fusha': instance.fusha,
  'perdoruesi': instance.perdoruesi,
};
