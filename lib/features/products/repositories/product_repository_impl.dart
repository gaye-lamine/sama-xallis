import 'package:dio/dio.dart';
import '../../../core/exceptions/api_exception.dart';
import '../models/product_model.dart';
import '../models/create_product_dto.dart';
import '../models/update_product_dto.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;

  const ProductRepositoryImpl(this._dio);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/api/products');
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/api/products/$id');
      return Product.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Product> createProduct(CreateProductDto dto) async {
    try {
      final response = await _dio.post('/api/products', data: dto.toJson());
      return Product.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Product> updateProduct(String id, UpdateProductDto dto) async {
    try {
      final body = {
        if (dto.name != null) 'name': dto.name,
        if (dto.purchasePrice != null) 'purchasePrice': dto.purchasePrice,
        if (dto.sellingPrice != null) 'sellingPrice': dto.sellingPrice,
        if (dto.stock != null) 'stock': dto.stock,
      };
      final response = await _dio.put('/api/products/$id', data: body);
      return Product.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete('/api/products/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.error is ApiException) return e.error as ApiException;
    return ApiException(
      message: e.message ?? 'Unknown error',
      statusCode: e.response?.statusCode ?? 0,
    );
  }
}
