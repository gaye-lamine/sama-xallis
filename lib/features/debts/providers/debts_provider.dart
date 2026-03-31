import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/debt_model.dart';
import '../models/create_debt_dto.dart';
import '../models/update_debt_dto.dart';
import '../../orders/models/order_model.dart';
import '../../payments/models/create_payment_dto.dart';
import '../../../core/providers/repository_providers.dart';

export '../../../core/providers/repository_providers.dart'
    show debtsProvider, usersProvider, debtServiceProvider, ordersProvider,
        paymentRepositoryProvider;

final creditOrdersProvider = Provider<AsyncValue<List<Order>>>((ref) {
  return ref.watch(ordersProvider).whenData(
        (orders) => orders.where((o) => o.paymentType == 'credit').toList(),
      );
});

final createDebtProvider =
    AsyncNotifierProvider<CreateDebtNotifier, void>(CreateDebtNotifier.new);

class CreateDebtNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> create(CreateDebtDto dto) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(debtServiceProvider).createDebt(dto),
    );
    if (!state.hasError) {
      ref.invalidate(debtsProvider);
    }
  }
}

final markDebtPaidProvider =
    AsyncNotifierProviderFamily<MarkDebtPaidNotifier, void, String>(
        MarkDebtPaidNotifier.new);

class MarkDebtPaidNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<void> payAmount(double paid, double totalAmount) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final remaining = totalAmount - paid;
    final dto = remaining <= 0
        ? const UpdateDebtDto(status: 'paid')
        : UpdateDebtDto(amount: remaining.clamp(0, double.infinity));
    state = await AsyncValue.guard(
      () => ref.read(debtServiceProvider).updateDebt(arg, dto),
    );
    if (!state.hasError) {
      ref.invalidate(debtsProvider);
    }
  }
}

final orderPaymentProvider =
    AsyncNotifierProvider<OrderPaymentNotifier, void>(OrderPaymentNotifier.new);

class OrderPaymentNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> pay({required String orderId, required double amount}) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(paymentRepositoryProvider).createPayment(
            CreatePaymentDto(orderId: orderId, amount: amount),
          ),
    );
    if (!state.hasError) {
      ref.invalidate(ordersProvider);
    }
  }
}
