import 'package:dio/dio.dart';
import '../../../core/exceptions/api_exception.dart';

class ExportService {
  final Dio _dio;

  const ExportService(this._dio);

  Future<String> exportOrders({String format = 'pdf', String? from, String? to}) async {
    return _export('/api/exports/orders', format: format, extra: {
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    });
  }

  Future<String> exportDebts({String format = 'pdf', String? userId}) async {
    return _export('/api/exports/debts', format: format, extra: {
      if (userId != null) 'userId': userId,
    });
  }

  Future<String> exportSummary({String format = 'pdf'}) async {
    return _export('/api/exports/summary', format: format);
  }

  Future<String> _export(String path, {required String format, Map<String, dynamic> extra = const {}}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: {'format': format, 'upload': 'true', ...extra},
      );
      final url = response.data['url'] as String?;
      if (url == null) throw const ApiException(message: 'URL manquante', statusCode: 500);
      return url;
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error as ApiException;
      throw ApiException(
        message: e.message ?? 'Erreur export',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }
}
