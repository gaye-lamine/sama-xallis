import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../../payments/models/payment_model.dart';
import '../../../core/providers/repository_providers.dart';

export '../../../core/providers/repository_providers.dart'
    show orderRepositoryProvider, paymentRepositoryProvider;

final orderDetailProvider =
    FutureProvider.family<Order, String>((ref, orderId) {
  return ref.watch(orderRepositoryProvider).getOrderById(orderId);
});

final orderPaymentsProvider =
    FutureProvider.family<List<Payment>, String>((ref, orderId) {
  return ref.watch(paymentRepositoryProvider).getPaymentsByOrder(orderId);
});
