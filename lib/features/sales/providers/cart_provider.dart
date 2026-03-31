import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/models/product_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  double get subtotal => product.sellingPrice * quantity;
}

class CartNotifier extends Notifier<Map<String, CartItem>> {
  @override
  Map<String, CartItem> build() => {};

  void add(Product product) {
    final current = state[product.id];
    final newQty = (current?.quantity ?? 0) + 1;
    if (newQty > product.stock) return;
    state = {
      ...state,
      product.id: CartItem(product: product, quantity: newQty),
    };
  }

  void remove(Product product) {
    final current = state[product.id];
    if (current == null) return;
    if (current.quantity <= 1) {
      final updated = Map<String, CartItem>.from(state);
      updated.remove(product.id);
      state = updated;
    } else {
      state = {
        ...state,
        product.id: current.copyWith(quantity: current.quantity - 1),
      };
    }
  }

  void clear() => state = {};
}

final cartProvider =
    NotifierProvider<CartNotifier, Map<String, CartItem>>(CartNotifier.new);

final cartTotalProvider = Provider<double>((ref) {
  return ref
      .watch(cartProvider)
      .values
      .fold(0.0, (sum, item) => sum + item.subtotal);
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref
      .watch(cartProvider)
      .values
      .fold(0, (sum, item) => sum + item.quantity);
});
