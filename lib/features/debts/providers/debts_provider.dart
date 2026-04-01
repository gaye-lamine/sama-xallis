import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/debt_model.dart';
import '../models/debt_payment.dart';
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

  Future<String?> create(CreateDebtDto dto) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(debtServiceProvider).createDebt(dto),
    );
    if (!state.hasError) {
      ref.invalidate(debtsProvider);
      return null;
    }
    return state.error.toString();
  }}

final debtPaymentHistoryProvider =
    FutureProvider.family<List<DebtPayment>, String>((ref, debtId) {
  return ref.watch(debtServiceProvider).getPaymentHistory(debtId);
});

final markDebtPaidProvider =
    AsyncNotifierProviderFamily<MarkDebtPaidNotifier, void, String>(
        MarkDebtPaidNotifier.new);

class MarkDebtPaidNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<void> payAmount(double amount) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(debtServiceProvider).payDebt(arg, amount),
    );
    if (!state.hasError) {
      ref.invalidate(debtsProvider);
      ref.invalidate(debtPaymentHistoryProvider(arg));
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
