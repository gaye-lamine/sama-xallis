import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../exceptions/api_exception.dart';

class AppInterceptor extends Interceptor {
  final VoidCallback? onUnauthorized;

  AppInterceptor({this.onUnauthorized});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API] ${options.method} ${options.path}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API] ${response.statusCode} ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API ERROR] ${err.response?.statusCode} ${err.requestOptions.path}');
      debugPrint('[API ERROR] data: ${err.response?.data}');
    }

    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }

    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String? ?? _fallbackMessage(err);
      final statusCode = data['statusCode'] as int? ?? err.response?.statusCode ?? 0;
      return handler.reject(DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: ApiException(message: message, statusCode: statusCode),
      ));
    }

    handler.next(err);
  }

  String _fallbackMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout: return 'Connexion expirée';
      case DioExceptionType.receiveTimeout: return 'Serveur trop lent';
      case DioExceptionType.sendTimeout: return 'Envoi expiré';
      case DioExceptionType.connectionError: return 'Pas de connexion internet';
      default: return err.message ?? 'Erreur inattendue';
    }
  }
}
