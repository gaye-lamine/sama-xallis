import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/repositories/product_repository.dart';
import '../../features/products/repositories/product_repository_impl.dart';
import '../../features/products/repositories/cached_product_repository.dart';
import '../../features/users/services/user_service.dart';
import '../../features/debts/services/debt_service.dart';
import '../../features/debts/services/cached_debt_service.dart';
import '../../features/orders/repositories/order_repository.dart';
import '../../features/orders/repositories/order_repository_impl.dart';
import '../../features/payments/repositories/payment_repository.dart';
import '../../features/payments/repositories/payment_repository_impl.dart';
import '../../features/products/models/product_model.dart';
import '../../features/users/models/user_model.dart';
import '../../features/debts/models/debt_model.dart';
import '../../features/orders/models/order_model.dart';
import '../network/dio_client.dart';
import '../network/connectivity_service.dart';
import 'unauthorized_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(
    onUnauthorized: () => ref.read(unauthorizedProvider.notifier).state++,
  );
});

final remoteProductRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(dioProvider)),
);

final remoteDebtServiceProvider = Provider<DebtService>(
  (ref) => DebtService(ref.watch(dioProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remote = ref.watch(remoteProductRepositoryProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return CachedProductRepository(remote, connectivity);
});

final debtServiceProvider = Provider<CachedDebtService>((ref) {
  final remote = ref.watch(remoteDebtServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  return CachedDebtService(remote, connectivity);
});

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.watch(dioProvider)),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepositoryImpl(ref.watch(dioProvider)),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepositoryImpl(ref.watch(dioProvider)),
);

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

final usersProvider = FutureProvider<List<User>>((ref) {
  return ref.watch(userServiceProvider).getUsers();
});

final debtsProvider = FutureProvider<List<Debt>>((ref) {
  return ref.watch(debtServiceProvider).getDebts();
});

final ordersProvider = FutureProvider<List<Order>>((ref) {
  return ref.watch(orderRepositoryProvider).getOrders();
});
