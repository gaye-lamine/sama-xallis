import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/models/create_order_dto.dart';
import '../../orders/models/order_item_input.dart';
import '../../orders/models/order_response.dart';
import '../../users/models/user_model.dart';
import '../../../core/providers/repository_providers.dart';
import 'cart_provider.dart';

export '../../../core/providers/repository_providers.dart'
    show productsProvider, usersProvider;

final selectedPaymentTypeProvider =
    StateProvider<PaymentType>((_) => PaymentType.cash);

final selectedCustomerProvider = StateProvider<User?>((_) => null);

final orderSubmitProvider =
    AsyncNotifierProvider<OrderSubmitNotifier, OrderResponse?>(
        OrderSubmitNotifier.new);

class OrderSubmitNotifier extends AsyncNotifier<OrderResponse?> {
  @override
  Future<OrderResponse?> build() async => null;

  Future<void> submit() async {
    if (state.isLoading) return;

    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    final paymentType = ref.read(selectedPaymentTypeProvider);
    final customer = ref.read(selectedCustomerProvider);

    final dto = CreateOrderDto(
      paymentType: paymentType,
      customerId: customer?.id,
      items: cart.values
          .map((e) => OrderItemInput(
                productId: e.product.id,
                quantity: e.quantity,
              ))
          .toList(),
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(orderRepositoryProvider).createOrder(dto),
    );

    if (state.value != null && !state.hasError) {
      ref.read(cartProvider.notifier).clear();
      ref.read(selectedCustomerProvider.notifier).state = null;
      ref.read(selectedPaymentTypeProvider.notifier).state = PaymentType.cash;
      ref.invalidate(ordersProvider);
    }
  }
}
