import '../../../core/cache/hive_boxes.dart';
import '../../../core/network/connectivity_service.dart';
import '../models/debt_model.dart';
import '../models/create_debt_dto.dart';
import '../models/update_debt_dto.dart';
import 'debt_service.dart';

class CachedDebtService {
  final DebtService _remote;
  final ConnectivityService _connectivity;

  const CachedDebtService(this._remote, this._connectivity);

  Future<List<Debt>> getDebts() async {
    final online = await _connectivity.isOnline;

    if (online) {
      try {
        final debts = await _remote.getDebts();
        _writeCache(debts);
        return debts;
      } catch (_) {
        return _readCache();
      }
    }

    return _readCache();
  }

  Future<Debt> getDebtById(String id) async {
    final online = await _connectivity.isOnline;

    if (online) {
      final debt = await _remote.getDebtById(id);
      _writeSingle(debt);
      return debt;
    }

    final cached = HiveBoxes.debtsBox.get(id);
    if (cached == null) throw Exception('Debt not found in cache');
    return Debt.fromJson(Map<String, dynamic>.from(cached));
  }

  Future<Debt> createDebt(CreateDebtDto dto) async {
    final debt = await _remote.createDebt(dto);
    _writeSingle(debt);
    return debt;
  }

  Future<Debt> updateDebt(String id, UpdateDebtDto dto) async {
    final debt = await _remote.updateDebt(id, dto);
    _writeSingle(debt);
    return debt;
  }

  Future<void> deleteDebt(String id) async {
    await _remote.deleteDebt(id);
    await HiveBoxes.debtsBox.delete(id);
  }

  Future<void> sync() async {
    final online = await _connectivity.isOnline;
    if (!online) return;
    final debts = await _remote.getDebts();
    _writeCache(debts);
  }

  void _writeCache(List<Debt> debts) {
    final box = HiveBoxes.debtsBox;
    box.clear();
    for (final d in debts) {
      box.put(d.id, d.toJson());
    }
  }

  void _writeSingle(Debt debt) {
    HiveBoxes.debtsBox.put(debt.id, debt.toJson());
  }

  List<Debt> _readCache() {
    return HiveBoxes.debtsBox.values
        .map((e) => Debt.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
