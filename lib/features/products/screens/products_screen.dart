import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/create_product_dto.dart';
import '../models/product_model.dart';
import '../providers/products_provider.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(),
          const Expanded(child: _ProductList()),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      builder: (_) => const _AddProductSheet(),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
      child: TextField(
        onChanged: (v) => ref.read(productSearchProvider.notifier).state = v,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: 'Rechercher un produit...',
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 20),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(filteredProductsProvider);

    return products.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: AppSpacing.md),
            const Text('Erreur de chargement', style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Réessayer', icon: Icons.refresh, onTap: () => ref.invalidate(productsProvider), expanded: false),
          ],
        ),
      ),
      data: (list) => list.isEmpty
          ? const Center(child: Text('Aucun produit', style: AppTextStyles.small))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => _ProductTile(product: list[i]),
            ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  Color get _stockColor {
    if (product.stock == 0) return AppColors.danger;
    if (product.stock < 5) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 52,
            decoration: BoxDecoration(
              color: _stockColor,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${product.sellingPrice.toStringAsFixed(0)} F', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    const SizedBox(width: AppSpacing.sm),
                    Text('coût ${product.purchasePrice.toStringAsFixed(0)} F', style: AppTextStyles.small),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${product.stock}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _stockColor)),
              StatusBadge.stock(product.stock),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddProductSheet extends ConsumerStatefulWidget {
  const _AddProductSheet();

  @override
  ConsumerState<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends ConsumerState<_AddProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _purchasePrice = TextEditingController();
  final _sellingPrice = TextEditingController();
  final _stock = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _purchasePrice.dispose();
    _sellingPrice.dispose();
    _stock.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(createProductProvider.notifier).create(CreateProductDto(
      name: _name.text.trim(),
      purchasePrice: double.parse(_purchasePrice.text),
      sellingPrice: double.parse(_sellingPrice.text),
      stock: int.parse(_stock.text),
    ));
    final state = ref.read(createProductProvider);
    if (!mounted) return;
    if (state.hasError) {
      AppFeedback.error(context, 'Erreur lors de l\'ajout');
    } else {
      AppFeedback.success(context, 'Produit ajouté');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createProductProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nouveau produit', style: AppTextStyles.h2),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              label: 'Nom du produit',
              controller: _name,
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    label: 'Prix achat',
                    controller: _purchasePrice,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requis';
                      if (double.tryParse(v) == null) return 'Invalide';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppInput(
                    label: 'Prix vente',
                    controller: _sellingPrice,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Requis';
                      final sell = double.tryParse(v);
                      final buy = double.tryParse(_purchasePrice.text);
                      if (sell == null) return 'Invalide';
                      if (buy != null && sell < buy) return '≥ prix achat';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(
              label: 'Stock initial',
              controller: _stock,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requis';
                final n = int.tryParse(v);
                if (n == null || n < 0) return 'Doit être ≥ 0';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Ajouter le produit', icon: Icons.add, loading: isLoading, onTap: _submit),
          ],
        ),
      ),
    );
  }
}
