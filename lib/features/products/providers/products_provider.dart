import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../models/create_product_dto.dart';
import '../../../core/providers/repository_providers.dart';

export '../../../core/providers/repository_providers.dart'
    show productsProvider, productRepositoryProvider;

final productSearchProvider = StateProvider<String>((_) => '');

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final query = ref.watch(productSearchProvider).toLowerCase().trim();
  final products = ref.watch(productsProvider);
  if (query.isEmpty) return products;
  return products.whenData(
    (list) => list
        .where((p) => p.name.toLowerCase().contains(query))
        .toList(),
  );
});

final createProductProvider =
    AsyncNotifierProvider<CreateProductNotifier, void>(
        CreateProductNotifier.new);

class CreateProductNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> create(CreateProductDto dto) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productRepositoryProvider).createProduct(dto),
    );
    if (!state.hasError) {
      ref.invalidate(productsProvider);
    }
  }
}
