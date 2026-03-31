import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../users/models/user_model.dart';
import '../../users/models/create_user_dto.dart';
import '../../debts/models/debt_model.dart';
import '../../../core/providers/repository_providers.dart';

export '../../../core/providers/repository_providers.dart'
    show usersProvider, debtsProvider;

final customerDebtsProvider =
    Provider.family<AsyncValue<List<Debt>>, String>((ref, customerId) {
  return ref.watch(debtsProvider).whenData(
        (debts) => debts.where((d) => d.customerId == customerId).toList(),
      );
});

final customerDebtSummaryProvider =
    Provider.family<AsyncValue<_DebtSummary>, String>((ref, userId) {
  return ref.watch(customerDebtsProvider(userId)).whenData((debts) {
    final total = debts.fold(0.0, (s, d) => s + d.amount);
    final pending = debts
        .where((d) => d.status == 'pending' || d.status == 'overdue')
        .fold(0.0, (s, d) => s + d.amount);
    return _DebtSummary(total: total, pending: pending, count: debts.length);
  });
});

class _DebtSummary {
  final double total;
  final double pending;
  final int count;

  const _DebtSummary({
    required this.total,
    required this.pending,
    required this.count,
  });
}

final createUserProvider =
    AsyncNotifierProvider<CreateUserNotifier, void>(CreateUserNotifier.new);

class CreateUserNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> create(CreateUserDto dto) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userServiceProvider).createUser(dto),
    );
    if (!state.hasError) {
      ref.invalidate(usersProvider);
    }
  }
}
