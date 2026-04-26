import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/remote/api_client.dart';
import '../models/announcement.dart';

class AnnouncementRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<Announcement>> getAnnouncements({String? sport, String? type}) async {
    final Map<String, dynamic> query = {};
    if (sport != null) query['lloji_sportit'] = sport;
    if (type != null) query['tipi'] = type;

    final response = await _dio.get('/announcements', queryParameters: query);
    return (response.data as List).map((x) => Announcement.fromJson(x)).toList();
  }

  Future<Announcement> getAnnouncementById(int id) async {
    final response = await _dio.get('/announcements/$id');
    return Announcement.fromJson(response.data);
  }

  Future<Announcement> createAnnouncement(Map<String, dynamic> data) async {
    final response = await _dio.post('/announcements', data: data);
    return Announcement.fromJson(response.data);
  }

  Future<void> respond(int id, String? message) async {
    await _dio.post('/announcements/$id/respond', data: {'mesazhi': message});
  }
}
