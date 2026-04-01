import 'package:hive_flutter/hive_flutter.dart';
import '../models/debt_payment_entry.dart';

class DebtPaymentHistoryService {
  static const _boxName = 'debt_payment_history';

  static Future<void> init() async {
    await Hive.openBox<Map>(_boxName);
  }

  static Box<Map> get _box => Hive.box<Map>(_boxName);

  static Future<void> record(DebtPaymentEntry entry) async {
    final key = '${entry.debtId}_${entry.paidAt.millisecondsSinceEpoch}';
    await _box.put(key, entry.toMap());
  }

  static List<DebtPaymentEntry> getHistory(String debtId) {
    return _box.values
        .where((m) => m['debtId'] == debtId)
        .map((m) => DebtPaymentEntry.fromMap(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.paidAt.compareTo(a.paidAt));
  }
}
