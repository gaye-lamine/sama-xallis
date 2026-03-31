import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_providers.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return products.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Failed to load products', style: TextStyle(color: Colors.red.shade700)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.invalidate(productsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (products) => GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) => _ProductCard(product: products[i]),
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(
      cartProvider.select((cart) => cart[product.id]?.quantity ?? 0),
    );
    final outOfStock = product.stock == 0;

    return Card(
      elevation: 0,
      color: outOfStock ? Colors.grey.shade200 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: outOfStock
            ? null
            : () => ref.read(cartProvider.notifier).add(product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '${product.sellingPrice.toStringAsFixed(0)} F',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    'Stock: ${product.stock}',
                    style: TextStyle(
                      fontSize: 11,
                      color: product.stock < 5
                          ? Colors.orange.shade700
                          : Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  if (qty > 0)
                    _QtyBadge(
                      qty: qty,
                      onRemove: () =>
                          ref.read(cartProvider.notifier).remove(product),
                      onAdd: outOfStock || qty >= product.stock
                          ? null
                          : () => ref.read(cartProvider.notifier).add(product),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyBadge extends StatelessWidget {
  final int qty;
  final VoidCallback onRemove;
  final VoidCallback? onAdd;

  const _QtyBadge({
    required this.qty,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleBtn(icon: Icons.remove, onTap: onRemove, color: Colors.red),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '$qty',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        _CircleBtn(
          icon: Icons.add,
          onTap: onAdd,
          color: onAdd != null ? Colors.green : Colors.grey,
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _CircleBtn({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
