import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  static const _storage    = FlutterSecureStorage();
  static const _accessKey  = 'tf_access';
  static const _refreshKey = 'tf_refresh';

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessKey,  value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> getAccessToken()  async => _storage.read(key: _accessKey);
  static Future<String?> getRefreshToken() async => _storage.read(key: _refreshKey);

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessKey);
    return token != null;
  }

  static Future<void> clear() async => _storage.deleteAll();

  static Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      return jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}