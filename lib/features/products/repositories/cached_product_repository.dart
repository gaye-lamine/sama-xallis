import '../../../core/cache/hive_boxes.dart';
import '../../../core/network/connectivity_service.dart';
import '../models/product_model.dart';
import '../models/create_product_dto.dart';
import '../models/update_product_dto.dart';
import 'product_repository.dart';

class CachedProductRepository implements ProductRepository {
  final ProductRepository _remote;
  final ConnectivityService _connectivity;

  const CachedProductRepository(this._remote, this._connectivity);

  @override
  Future<List<Product>> getProducts() async {
    final online = await _connectivity.isOnline;

    if (online) {
      try {
        final products = await _remote.getProducts();
        _writeCache(products);
        return products;
      } catch (_) {
        return _readCache();
      }
    }

    return _readCache();
  }

  @override
  Future<Product> getProductById(String id) async {
    final online = await _connectivity.isOnline;

    if (online) {
      final product = await _remote.getProductById(id);
      _writeSingle(product);
      return product;
    }

    final cached = HiveBoxes.productsBox.get(id);
    if (cached == null) throw Exception('Product not found in cache');
    return Product.fromJson(Map<String, dynamic>.from(cached));
  }

  @override
  Future<Product> createProduct(CreateProductDto dto) async {
    final product = await _remote.createProduct(dto);
    _writeSingle(product);
    return product;
  }

  @override
  Future<Product> updateProduct(String id, UpdateProductDto dto) async {
    final product = await _remote.updateProduct(id, dto);
    _writeSingle(product);
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _remote.deleteProduct(id);
    await HiveBoxes.productsBox.delete(id);
  }

  Future<void> sync() async {
    final online = await _connectivity.isOnline;
    if (!online) return;
    final products = await _remote.getProducts();
    _writeCache(products);
  }

  void _writeCache(List<Product> products) {
    final box = HiveBoxes.productsBox;
    box.clear();
    for (final p in products) {
      box.put(p.id, p.toJson());
    }
  }

  void _writeSingle(Product product) {
    HiveBoxes.productsBox.put(product.id, product.toJson());
  }

  List<Product> _readCache() {
    return HiveBoxes.productsBox.values
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
