import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/remote/api_client.dart';
import '../models/event.dart';

class EventRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<Event>> getEvents() async {
    final response = await _dio.get(ApiConstants.events);
    return (response.data as List).map((x) => Event.fromJson(x)).toList();
  }

  Future<Event> getEventById(int id) async {
    final response = await _dio.get(ApiConstants.eventById(id));
    return Event.fromJson(response.data);
  }

  Future<Team> registerTeam(int eventId, String teamName) async {
    final response = await _dio.post(
      ApiConstants.registerTeam(eventId),
      data: {'emri': teamName},
    );
    return Team.fromJson(response.data);
  }
}
