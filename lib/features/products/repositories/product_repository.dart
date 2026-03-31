import '../models/product_model.dart';
import '../models/create_product_dto.dart';
import '../models/update_product_dto.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<Product> createProduct(CreateProductDto dto);
  Future<Product> updateProduct(String id, UpdateProductDto dto);
  Future<void> deleteProduct(String id);
}
