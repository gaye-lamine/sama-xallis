import '../models/order_model.dart';
import '../models/order_response.dart';
import '../models/create_order_dto.dart';
import '../models/payment_result.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<OrderResponse> createOrder(CreateOrderDto dto);
  Future<Order> getOrderById(String id);
  Future<PaymentResult> addPayment(String orderId, double paidAmount);
}
