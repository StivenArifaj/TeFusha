import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/remote/api_client.dart';
import '../models/field.dart';
import '../models/time_slot.dart';

class FieldRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<Field>> getFields({String? qyteti, String? lloji}) async {
    final Map<String, dynamic> queryParameters = {};
    if (qyteti != null && qyteti.isNotEmpty) queryParameters['qyteti'] = qyteti;
    if (lloji != null && lloji.isNotEmpty) queryParameters['lloji'] = lloji;

    final response = await _dio.get(
      ApiConstants.fields,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    return (response.data as List).map((x) => Field.fromJson(x)).toList();
  }

  Future<Field> getFieldById(int id) async {
    final response = await _dio.get(ApiConstants.fieldById(id));
    return Field.fromJson(response.data);
  }

  Future<List<TimeSlot>> getAvailability(int id, String date) async {
    final response = await _dio.get(
      ApiConstants.fieldAvailability(id),
      queryParameters: {'date': date},
    );
    return (response.data as List).map((x) => TimeSlot.fromJson(x)).toList();
  }
}
