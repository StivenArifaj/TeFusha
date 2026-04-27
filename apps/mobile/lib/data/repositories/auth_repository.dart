import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/local/token_storage.dart';
import '../datasources/remote/api_client.dart';
import '../models/user.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  Future<User> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'fjalekalimi': password},
    );
    await TokenStorage.saveTokens(
      access: response.data['access'],
      refresh: response.data['refresh'],
    );
    return User.fromJson(response.data['user']);
  }

  Future<User> register(String fullName, String email, String password, String role) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: {
        'emri': fullName,
        'email': email,
        'fjalekalimi': password,
        'roli': role,
      },
    );
    await TokenStorage.saveTokens(
      access: response.data['access'],
      refresh: response.data['refresh'],
    );
    return User.fromJson(response.data['user']);
  }

  Future<void> logout() async {
    await TokenStorage.clear();
  }

  Future<bool> isAuthenticated() async {
    return TokenStorage.isLoggedIn();
  }
}
