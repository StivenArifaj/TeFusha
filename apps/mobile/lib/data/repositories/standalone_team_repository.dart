import 'package:dio/dio.dart';
import '../datasources/remote/api_client.dart';
import '../models/standalone_team.dart';

class StandaloneTeamRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<StandaloneTeam>> getMyTeams() async {
    final response = await _dio.get('/teams/mine');
    return (response.data as List).map((x) => StandaloneTeam.fromJson(x)).toList();
  }

  Future<StandaloneTeam> getTeamById(int id) async {
    final response = await _dio.get('/teams/$id');
    return StandaloneTeam.fromJson(response.data);
  }

  Future<StandaloneTeam> createTeam(Map<String, dynamic> data) async {
    final response = await _dio.post('/teams', data: data);
    return StandaloneTeam.fromJson(response.data);
  }

  Future<void> joinTeam(int id) async {
    await _dio.post('/teams/$id/join');
  }

  Future<void> removeMember(int teamId, int userId) async {
    await _dio.delete('/teams/$teamId/members/$userId');
  }
}
