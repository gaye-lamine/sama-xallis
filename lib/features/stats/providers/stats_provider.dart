import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/repository_providers.dart';

export '../../../core/providers/repository_providers.dart'
    show ordersProvider, debtsProvider;

class StatsData {
  final double revenue;
  final double cashCollected;
  final double creditCollected;
  final double totalCollected;
  final double totalDebt;
  final double overdueDebt;
  final int totalOrders;
  final int paidOrders;
  final int unpaidOrders;

  const StatsData({
    required this.revenue,
    required this.cashCollected,
    required this.creditCollected,
    required this.totalCollected,
    required this.totalDebt,
    required this.overdueDebt,
    required this.totalOrders,
    required this.paidOrders,
    required this.unpaidOrders,
  });

  double get collectionRate => revenue > 0 ? totalCollected / revenue : 0;
}

final statsProvider = Provider<AsyncValue<StatsData>>((ref) {
  final orders = ref.watch(ordersProvider);
  final debts = ref.watch(debtsProvider);

  if (orders.isLoading || debts.isLoading) return const AsyncLoading();
  if (orders.hasError) return AsyncError(orders.error!, StackTrace.empty);
  if (debts.hasError) return AsyncError(debts.error!, StackTrace.empty);

  final orderList = orders.value!;
  final debtList = debts.value!;

  final revenue = orderList.fold(0.0, (s, o) => s + o.totalAmount);

  // paidAmount reflects actual money received regardless of payment type
  final cashCollected = orderList
      .where((o) => o.paymentType == 'cash')
      .fold(0.0, (s, o) => s + o.paidAmount);
  final creditCollected = orderList
      .where((o) => o.paymentType == 'credit')
      .fold(0.0, (s, o) => s + o.paidAmount);
  final totalCollected = cashCollected + creditCollected;

  final totalDebt = debtList.fold(0.0, (s, d) => s + d.amount);
  final overdueDebt = debtList
      .where((d) => d.status == 'overdue')
      .fold(0.0, (s, d) => s + d.amount);
  final paidOrders = orderList.where((o) => o.status == 'paid').length;

  return AsyncData(StatsData(
    revenue: revenue,
    cashCollected: cashCollected,
    creditCollected: creditCollected,
    totalCollected: totalCollected,
    totalDebt: totalDebt,
    overdueDebt: overdueDebt,
    totalOrders: orderList.length,
    paidOrders: paidOrders,
    unpaidOrders: orderList.length - paidOrders,
  ));
});
