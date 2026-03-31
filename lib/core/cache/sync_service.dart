import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/connectivity_service.dart';
import '../providers/repository_providers.dart';
import '../../features/products/repositories/cached_product_repository.dart';
import '../../features/debts/services/cached_debt_service.dart';

class SyncService {
  final CachedProductRepository _products;
  final CachedDebtService _debts;
  final ConnectivityService _connectivity;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  StreamSubscription<bool>? _sub;

  SyncService(this._products, this._debts, this._connectivity);

  void start() {
    _sub = _connectivity.onlineStream.listen((online) {
      if (online) _sync();
    });
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }

  Future<void> _sync() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return;
    await Future.wait([
      _products.sync(),
      _debts.sync(),
    ]);
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final products =
      ref.watch(productRepositoryProvider) as CachedProductRepository;
  final debts = ref.watch(debtServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  final service = SyncService(products, debts, connectivity);
  service.start();
  ref.onDispose(service.stop);
  return service;
});
