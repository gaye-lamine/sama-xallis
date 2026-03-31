import 'package:dio/dio.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/payment_model.dart';
import '../models/create_payment_dto.dart';
import 'payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final Dio _dio;

  const PaymentRepositoryImpl(this._dio);

  @override
  Future<Payment> createPayment(CreatePaymentDto dto) async {
    try {
      final response = await _dio.post('/api/payments', data: dto.toJson());
      return Payment.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Payment>> getPaymentsByOrder(String orderId) async {
    try {
      final response = await _dio.get('/api/payments/order/$orderId');
      return (response.data as List).map((e) => Payment.fromJson(e)).toList();
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
