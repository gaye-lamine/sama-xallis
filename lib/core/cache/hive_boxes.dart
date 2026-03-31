import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String products = 'products';
  static const String debts = 'debts';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(products);
    await Hive.openBox<Map>(debts);
  }

  static Box<Map> get productsBox => Hive.box<Map>(products);
  static Box<Map> get debtsBox => Hive.box<Map>(debts);
}
