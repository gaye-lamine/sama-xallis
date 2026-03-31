import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import 'app_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio createPublic([AppConfig config = AppConfig.development]) {
    final dio = Dio(_baseOptions(config));
    dio.interceptors.add(AppInterceptor());
    return dio;
  }

  static Dio create({AppConfig config = AppConfig.development, VoidCallback? onUnauthorized}) {
    final dio = Dio(_baseOptions(config));
    dio.interceptors.add(_AuthInterceptor());
    dio.interceptors.add(AppInterceptor(onUnauthorized: onUnauthorized));
    return dio;
  }

  static BaseOptions _baseOptions(AppConfig config) => BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.json,
      );
}

class _AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final isAuthRoute = options.path.contains('/api/auth/');
    if (!isAuthRoute) {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
