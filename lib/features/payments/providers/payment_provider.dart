import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/models/order_model.dart';
import '../models/payment_model.dart';
import '../models/create_payment_dto.dart';
import '../../../core/providers/repository_providers.dart';

export '../../../core/providers/repository_providers.dart'
    show ordersProvider, paymentRepositoryProvider, usersProvider;

final selectedOrderProvider = StateProvider<Order?>((_) => null);

final unpaidOrdersProvider = Provider<AsyncValue<List<Order>>>((ref) {
  return ref.watch(ordersProvider).whenData(
        (orders) => orders
            .where((o) => o.remainingAmount > 0)
            .toList(),
      );
});

final submitPaymentProvider =
    AsyncNotifierProvider<SubmitPaymentNotifier, Payment?>(
        SubmitPaymentNotifier.new);

class SubmitPaymentNotifier extends AsyncNotifier<Payment?> {
  @override
  Future<Payment?> build() async => null;

  Future<void> submit({required String orderId, required double amount}) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(paymentRepositoryProvider).createPayment(
            CreatePaymentDto(orderId: orderId, amount: amount),
          ),
    );
    if (!state.hasError) {
      ref.invalidate(ordersProvider);
      ref.read(selectedOrderProvider.notifier).state = null;
    }
  }
}
