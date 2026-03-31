import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/qty_control.dart';
import '../../../core/widgets/status_badge.dart';
import '../../orders/models/create_order_dto.dart';
import '../../products/models/product_model.dart';
import '../../users/models/user_model.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_providers.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(orderSubmitProvider, (_, next) {
      if (next.hasError) {
        final err = next.error;
        final msg = err is Exception ? err.toString().replaceAll('Exception: ', '') : 'Erreur lors de la vente';
        AppFeedback.error(context, msg);
      } else if (next.hasValue && next.value != null) {
        AppFeedback.success(context, 'Vente enregistrée');
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ventes'),
        actions: [
          Consumer(builder: (_, ref, __) {
            final count = ref.watch(cartItemCountProvider);
            if (count == 0) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: AppSpacing.lg),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: _ProductGrid()),
          const _CartPanel(),
        ],
      ),
    );
  }
}

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return products.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: AppSpacing.md),
            const Text('Impossible de charger les produits', style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Réessayer',
              icon: Icons.refresh,
              onTap: () => ref.invalidate(productsProvider),
              expanded: false,
            ),
          ],
        ),
      ),
      data: (products) => GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.05,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
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
      cartProvider.select((c) => c[product.id]?.quantity ?? 0),
    );
    final outOfStock = product.stock == 0;

    return GestureDetector(
      onTap: outOfStock ? null : () => ref.read(cartProvider.notifier).add(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: qty > 0 ? AppColors.primary : AppColors.border,
            width: qty > 0 ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusBadge.stock(product.stock),
              ],
            ),
            const Spacer(),
            Text(
              '${product.sellingPrice.toStringAsFixed(0)} F',
              style: AppTextStyles.amount.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (qty == 0)
              SizedBox(
                width: double.infinity,
                child: outOfStock
                    ? const Text('Rupture', style: TextStyle(color: AppColors.danger, fontSize: 13))
                    : Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add, color: AppColors.primary, size: 22),
                      ),
              )
            else
              QtyControl(
                value: qty,
                onAdd: () => ref.read(cartProvider.notifier).add(product),
                onRemove: () => ref.read(cartProvider.notifier).remove(product),
                canAdd: qty < product.stock,
              ),
          ],
        ),
      ),
    );
  }
}

class _CartPanel extends ConsumerWidget {
  const _CartPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final paymentType = ref.watch(selectedPaymentTypeProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final submitState = ref.watch(orderSubmitProvider);

    if (cart.isEmpty) {
      return Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 20),
            SizedBox(width: AppSpacing.sm),
            Text('Panier vide — appuyez sur un produit', style: AppTextStyles.small),
          ],
        ),
      );
    }

    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${cart.length} article(s)', style: AppTextStyles.small),
              GestureDetector(
                onTap: () => ref.read(cartProvider.notifier).clear(),
                child: const Text('Vider', style: TextStyle(color: AppColors.danger, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...cart.values.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(item.product.name, style: AppTextStyles.small.copyWith(color: Theme.of(context).colorScheme.onSurface), overflow: TextOverflow.ellipsis),
                ),
                Text('${item.quantity}×${item.product.sellingPrice.toStringAsFixed(0)}', style: AppTextStyles.small),
                const SizedBox(width: AppSpacing.sm),
                Text('${item.subtotal.toStringAsFixed(0)} F', style: AppTextStyles.small.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          )),
          const Divider(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), letterSpacing: 1)),
              Text('${total.toStringAsFixed(0)} F', style: AppTextStyles.amount.copyWith(color: AppColors.primary, fontSize: 26)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _PayTypeBtn(label: 'Cash', icon: Icons.payments_outlined, selected: paymentType == PaymentType.cash, onTap: () => ref.read(selectedPaymentTypeProvider.notifier).state = PaymentType.cash),
              const SizedBox(width: AppSpacing.sm),
              _PayTypeBtn(label: 'Crédit', icon: Icons.credit_card_outlined, selected: paymentType == PaymentType.credit, onTap: () => ref.read(selectedPaymentTypeProvider.notifier).state = PaymentType.credit),
            ],
          ),
          if (paymentType == PaymentType.credit) ...[
            const SizedBox(height: AppSpacing.sm),
            _CustomerDropdown(selected: selectedCustomer),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Confirmer la vente',
            icon: Icons.check,
            loading: submitState.isLoading,
            onTap: submitState.isLoading || cart.isEmpty
                ? null
                : () => ref.read(orderSubmitProvider.notifier).submit(),
          ),
        ],
      ),
    );
  }
}

class _PayTypeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PayTypeBtn({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 44,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDropdown extends ConsumerWidget {
  final User? selected;

  const _CustomerDropdown({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return users.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Erreur chargement clients', style: TextStyle(color: AppColors.danger, fontSize: 14)),
      data: (list) => DropdownButtonFormField<User>(
        value: selected,
        hint: const Text('Sélectionner un client'),
        decoration: const InputDecoration(isDense: true),
        items: list.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
        onChanged: (u) => ref.read(selectedCustomerProvider.notifier).state = u,
      ),
    );
  }
}
