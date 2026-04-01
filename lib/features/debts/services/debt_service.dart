import 'package:dio/dio.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/debt_model.dart';
import '../models/debt_payment.dart';
import '../models/create_debt_dto.dart';
import '../models/update_debt_dto.dart';

class DebtService {
  final Dio _dio;

  const DebtService(this._dio);

  Future<List<Debt>> getDebts() async {
    try {
      final response = await _dio.get('/api/debts');
      return (response.data as List).map((e) => Debt.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Debt> getDebtById(String id) async {
    try {
      final response = await _dio.get('/api/debts/$id');
      return Debt.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Debt> createDebt(CreateDebtDto dto) async {
    try {
      final body = {
        'customerId': dto.customerId,
        'amount': dto.amount,
        'description': dto.description,
        if (dto.dueDate != null) 'dueDate': dto.dueDate,
        if (dto.status != null) 'status': dto.status,
      };
      final response = await _dio.post('/api/debts', data: body);
      return Debt.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Debt> updateDebt(String id, UpdateDebtDto dto) async {
    try {
      final body = {
        if (dto.amount != null) 'amount': dto.amount,
        if (dto.description != null) 'description': dto.description,
        if (dto.status != null) 'status': dto.status,
        if (dto.dueDate != null) 'dueDate': dto.dueDate,
      };
      final response = await _dio.put('/api/debts/$id', data: body);
      return Debt.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteDebt(String id) async {
    try {
      await _dio.delete('/api/debts/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DebtPayment> payDebt(String id, double amount) async {
    try {
      final response = await _dio.post('/api/debts/$id/payments', data: {'amount': amount});
      return DebtPayment.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<DebtPayment>> getPaymentHistory(String id) async {
    try {
      final response = await _dio.get('/api/debts/$id/payments');
      return (response.data as List).map((e) => DebtPayment.fromJson(e)).toList();
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
