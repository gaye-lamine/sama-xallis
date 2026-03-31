import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/auth_user.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  AuthService(this._dio) : _storage = const FlutterSecureStorage();

  Future<AuthUser> login(String phone, String pin) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'phone': phone,
        'pin': pin,
      });
      final token = response.data['token'] as String;
      final user = AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
      await _storage.write(key: _tokenKey, value: token);
      return user;
    } on DioException catch (e) {
      throw _apiError(e);
    }
  }

  Future<AuthUser> register(String name, String phone, String pin) async {
    try {
      final response = await _dio.post('/api/auth/register', data: {
        'name': name,
        'phone': phone,
        'pin': pin,
      });
      return AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _apiError(e);
    }
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> logout() => _storage.delete(key: _tokenKey);

  ApiException _apiError(DioException e) {
    final data = e.response?.data;
    return ApiException(
      message: data is Map ? (data['message'] ?? 'Erreur') : 'Erreur de connexion',
      statusCode: e.response?.statusCode ?? 0,
    );
  }
}
