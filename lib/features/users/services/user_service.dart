import 'package:dio/dio.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/user_model.dart';
import '../models/create_user_dto.dart';
import '../models/update_user_dto.dart';

class UserService {
  final Dio _dio;

  const UserService(this._dio);

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/api/customers');
      return (response.data as List).map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getUserById(String id) async {
    try {
      final response = await _dio.get('/api/customers/$id');
      return User.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> createUser(CreateUserDto dto) async {
    try {
      final response = await _dio.post('/api/customers', data: {
        'name': dto.name,
        'phone': dto.phone,
      });
      return User.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateUser(String id, UpdateUserDto dto) async {
    try {
      final body = {
        if (dto.name != null) 'name': dto.name,
        if (dto.phone != null) 'phone': dto.phone,
      };
      final response = await _dio.put('/api/customers/$id', data: body);
      return User.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _dio.delete('/api/customers/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.error is ApiException) return e.error as ApiException;
    return ApiException(
      message: e.message ?? 'Unknown error',
      statusCode: e.response?.statusCode ?? 0,
    );
  }
}
