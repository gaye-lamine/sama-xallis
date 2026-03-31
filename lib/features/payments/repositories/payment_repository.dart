import '../models/payment_model.dart';
import '../models/create_payment_dto.dart';

abstract class PaymentRepository {
  Future<Payment> createPayment(CreatePaymentDto dto);
  Future<List<Payment>> getPaymentsByOrder(String orderId);
}
