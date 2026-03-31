import 'package:dio/dio.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/order_model.dart';
import '../models/order_response.dart';
import '../models/create_order_dto.dart';
import '../models/payment_result.dart';
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Dio _dio;

  const OrderRepositoryImpl(this._dio);

  @override
  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get('/api/orders');
      return (response.data as List).map((e) => Order.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<OrderResponse> createOrder(CreateOrderDto dto) async {
    try {
      final body = {
        'paymentType': dto.paymentType == PaymentType.cash ? 'cash' : 'credit',
        'items': dto.items.map((i) => {
          'productId': i.productId,
          'quantity': i.quantity,
          if (i.unitPrice != null) 'unitPrice': i.unitPrice,
        }).toList(),
        if (dto.customerId != null) 'customerId': dto.customerId,
        if (dto.paidAmount != null) 'paidAmount': dto.paidAmount,
      };
      final response = await _dio.post('/api/orders', data: body);
      return OrderResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Order> getOrderById(String id) async {
    try {
      final response = await _dio.get('/api/orders/$id');
      return Order.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PaymentResult> addPayment(String orderId, double paidAmount) async {
    try {
      final response = await _dio.post(
        '/api/orders/$orderId/payments',
        data: {'paidAmount': paidAmount},
      );
      return PaymentResult.fromJson(response.data as Map<String, dynamic>);
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
