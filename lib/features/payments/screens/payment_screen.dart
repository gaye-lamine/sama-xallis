import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../orders/models/order_model.dart';
import '../../users/models/user_model.dart';
import '../providers/payment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? _selectedCustomer;
  Order? _selectedOrder;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onCustomerChanged(User? customer) {
    setState(() {
      _selectedCustomer = customer;
      _selectedOrder = null;
      _amountController.clear();
    });
    ref.read(selectedOrderProvider.notifier).state = null;
  }

  void _onOrderChanged(Order? order) {
    setState(() {
      _selectedOrder = order;
      _amountController.clear();
    });
    ref.read(selectedOrderProvider.notifier).state = order;
  }

  Future<void> _submit() async {
    if (_selectedOrder == null) return;
    if (!_formKey.currentState!.validate()) return;
    await ref.read(submitPaymentProvider.notifier).submit(
          orderId: _selectedOrder!.id,
          amount: double.parse(_amountController.text),
        );
    final state = ref.read(submitPaymentProvider);
    if (!mounted) return;
    if (state.hasError) {
      AppFeedback.error(context, 'Erreur lors du paiement');
    } else {
      setState(() {
        _selectedOrder = null;
        _selectedCustomer = null;
        _amountController.clear();
      });
      AppFeedback.success(context, 'Paiement enregistré');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(submitPaymentProvider).isLoading;
    final orders = ref.watch(unpaidOrdersProvider);
    final users = ref.watch(usersProvider);

    final customerOrders = orders.whenData((list) => _selectedCustomer == null
        ? <Order>[]
        : list.where((o) => o.customerId == _selectedCustomer!.id).toList());

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Paiement')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepCard(
                step: '1',
                title: 'Client',
                child: users.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erreur', style: TextStyle(color: AppColors.danger)),
                  data: (list) => DropdownButtonFormField<User>(
                    value: _selectedCustomer,
                    hint: const Text('Choisir un client'),
                    isExpanded: true,
                    items: list
                        .map((u) => DropdownMenuItem(
                              value: u,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.primary.withOpacity(0.1),
                                    child: Text(u.name[0].toUpperCase(),
                                        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(u.name),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: _onCustomerChanged,
                  ),
                ),
              ),
              if (_selectedCustomer != null) ...[
                const SizedBox(height: AppSpacing.md),
                _StepCard(
                  step: '2',
                  title: 'Commande impayée',
                  child: customerOrders.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Erreur', style: TextStyle(color: AppColors.danger)),
                    data: (list) => list.isEmpty
                        ? const _EmptyOrders()
                        : Column(
                            children: list
                                .map((o) => _OrderTile(
                                      order: o,
                                      selected: _selectedOrder?.id == o.id,
                                      onTap: () => _onOrderChanged(o),
                                    ))
                                .toList(),
                          ),
                  ),
                ),
              ],
              if (_selectedOrder != null) ...[
                const SizedBox(height: AppSpacing.md),
                _DebtSummary(order: _selectedOrder!),
                const SizedBox(height: AppSpacing.md),
                _StepCard(
                  step: '3',
                  title: 'Montant à payer',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                        autofocus: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.border),
                          suffixText: 'F',
                          suffixStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Entrez un montant';
                          final n = double.tryParse(v);
                          if (n == null || n <= 0) return 'Doit être > 0';
                          if (n > _selectedOrder!.remainingAmount) {
                            return 'Max : ${_selectedOrder!.remainingAmount.toStringAsFixed(0)} F';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _QuickAmounts(
                        remaining: _selectedOrder!.remainingAmount,
                        onTap: (v) => setState(() => _amountController.text = v.toStringAsFixed(0)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Valider le paiement',
                  icon: Icons.check,
                  loading: isLoading,
                  onTap: isLoading ? null : _submit,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final Widget child;

  const _StepCard({required this.step, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final Order order;
  final bool selected;
  final VoidCallback onTap;

  const _OrderTile({required this.order, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.06) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (selected)
              const Icon(Icons.radio_button_checked, color: AppColors.primary, size: 20)
            else
              const Icon(Icons.radio_button_unchecked, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande du ${order.id.substring(0, 8)}',
                    style: AppTextStyles.small.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Total : ${order.totalAmount.toStringAsFixed(0)} F  •  Payé : ${order.paidAmount.toStringAsFixed(0)} F',
                    style: AppTextStyles.small,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${order.remainingAmount.toStringAsFixed(0)} F',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.danger),
                ),
                const Text('restant', style: AppTextStyles.small),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
          SizedBox(width: AppSpacing.sm),
          Text('Aucune commande impayée', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DebtSummary extends StatelessWidget {
  final Order order;
  const _DebtSummary({required this.order});

  @override
  Widget build(BuildContext context) {
    final pct = order.totalAmount > 0
        ? (order.paidAmount / order.totalAmount).clamp(0.0, 1.0)
        : 0.0;

    return AppCard(
      color: AppColors.danger.withOpacity(0.04),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Item(label: 'Total', value: '${order.totalAmount.toStringAsFixed(0)} F', color: AppColors.textPrimary),
              _Item(label: 'Déjà payé', value: '${order.paidAmount.toStringAsFixed(0)} F', color: AppColors.success),
              _Item(label: 'Reste à payer', value: '${order.remainingAmount.toStringAsFixed(0)} F', color: AppColors.danger, large: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.danger.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${(pct * 100).toStringAsFixed(0)}% payé', style: AppTextStyles.small),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool large;
  const _Item({required this.label, required this.value, required this.color, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.small),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: large ? 18 : 15)),
      ],
    );
  }
}

class _QuickAmounts extends StatelessWidget {
  final double remaining;
  final ValueChanged<double> onTap;
  const _QuickAmounts({required this.remaining, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final options = [remaining * 0.25, remaining * 0.5, remaining * 0.75, remaining];
    final labels = ['25%', '50%', '75%', 'Tout'];

    return Row(
      children: List.generate(
        4,
        (i) => Expanded(
          child: GestureDetector(
            onTap: () => onTap(options[i]),
            child: Container(
              margin: EdgeInsets.only(left: i == 0 ? 0 : AppSpacing.sm),
              height: 40,
              decoration: BoxDecoration(
                color: i == 3 ? AppColors.primary : AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: i == 3 ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
