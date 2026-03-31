import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/repository_providers.dart';
import '../services/export_service.dart';

export '../services/export_service.dart' show ExportType;

final exportServiceProvider = Provider<ExportService>(
  (ref) => ExportService(ref.watch(dioProvider)),
);

enum ExportType { orders, debts, summary }

final exportProvider =
    AsyncNotifierProviderFamily<ExportNotifier, String?, ExportType>(
        ExportNotifier.new);

class ExportNotifier extends FamilyAsyncNotifier<String?, ExportType> {
  @override
  Future<String?> build(ExportType arg) async => null;

  Future<String?> launch({String format = 'pdf', String? from, String? to, String? userId}) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final svc = ref.read(exportServiceProvider);
      switch (arg) {
        case ExportType.orders:
          return svc.exportOrders(format: format, from: from, to: to);
        case ExportType.debts:
          return svc.exportDebts(format: format, userId: userId);
        case ExportType.summary:
          return svc.exportSummary(format: format);
      }
    });
    return state.value;
  }
}
