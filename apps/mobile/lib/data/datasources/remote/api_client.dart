import 'package:dio/dio.dart';
import '../../datasources/local/token_storage.dart';
import '../../../core/constants/api_constants.dart';

class ApiClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(_AuthInterceptor(dio));
    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  _AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refresh = await TokenStorage.getRefreshToken();
        final response = await dio.post(
          ApiConstants.refresh,
          data: {'refresh_token': refresh},
          options: Options(headers: {}), // no auth header on refresh
        );
        await TokenStorage.saveTokens(
          access: response.data['access_token'],
          refresh: response.data['refresh_token'],
        );
        final retryOpts = err.requestOptions;
        retryOpts.headers['Authorization'] =
            'Bearer ${response.data["access_token"]}';
        return handler.resolve(await dio.fetch(retryOpts));
      } catch (_) {
        await TokenStorage.clear();
        // The router should handle the redirect on next interaction
      }
    }
    handler.next(err);
  }
}
