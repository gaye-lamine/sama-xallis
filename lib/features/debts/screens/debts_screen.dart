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
import '../../orders/models/order_model.dart';
import '../../payments/models/create_payment_dto.dart';
import '../../users/models/user_model.dart';
import '../../voice_notes/widgets/voice_note_widget.dart';
import '../models/create_debt_dto.dart';
import '../models/debt_model.dart';
import '../models/debt_payment.dart';
import '../providers/debts_provider.dart';

class DebtsScreen extends ConsumerStatefulWidget {
  const DebtsScreen({super.key});

  @override
  ConsumerState<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends ConsumerState<DebtsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dettes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddDebtSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [
            Tab(text: 'Dettes manuelles'),
            Tab(text: 'Commandes crédit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _ManualDebtsList(),
          _CreditOrdersList(),
        ],
      ),
    );
  }

  void _showAddDebtSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      builder: (_) => const _AddDebtSheet(),
    );
  }
}

class _ManualDebtsList extends ConsumerWidget {
  const _ManualDebtsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(debtsProvider);
    final users = ref.watch(usersProvider);
    final userMap = users.whenData((l) => {for (final u in l) u.id: u});

    return debts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(onRetry: () => ref.invalidate(debtsProvider)),
      data: (list) {
        final unpaid = list.where((d) => d.status != 'paid').toList();
        final paid = list.where((d) => d.status == 'paid').toList();
        final all = [...unpaid, ...paid];
        if (all.isEmpty) return const _EmptyView(message: 'Aucune dette manuelle');
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: all.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => _DebtTile(
            debt: all[i],
            user: userMap.valueOrNull?[all[i].customerId],
          ),
        );
      },
    );
  }
}

class _CreditOrdersList extends ConsumerWidget {
  const _CreditOrdersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(creditOrdersProvider);
    final users = ref.watch(usersProvider);
    final userMap = users.whenData((l) => {for (final u in l) u.id: u});

    return orders.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(onRetry: () => ref.invalidate(ordersProvider)),
      data: (list) {
        if (list.isEmpty) return const _EmptyView(message: 'Aucune commande à crédit');
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => _OrderTile(
            order: list[i],
            user: userMap.valueOrNull?[list[i].customerId ?? ''],
          ),
        );
      },
    );
  }
}

class _DebtTile extends ConsumerWidget {
  final Debt debt;
  final User? user;
  const _DebtTile({required this.debt, required this.user});

  Color get _color {
    switch (debt.status) {
      case 'paid': return AppColors.success;
      case 'overdue': return AppColors.danger;
      default: return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = debt.status == 'paid';
    return AppCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.md),
                  bottomLeft: Radius.circular(AppSpacing.md),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(user?.name ?? 'Client inconnu',
                              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        Text('${debt.amount.toStringAsFixed(0)} F',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _color)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(debt.description,
                              style: AppTextStyles.small, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        StatusBadge.debt(debt.status),
                      ],
                    ),
                    if (debt.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Text('Échéance : ${debt.dueDate!.substring(0, 10)}', style: AppTextStyles.small),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    VoiceNoteWidget(entityType: 'debt', entityId: debt.id),
                    _DebtHistoryInline(debtId: debt.id),
                    if (!isPaid) ...[
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Theme.of(context).cardColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
                          ),
                          builder: (_) => _DebtPaySheet(debt: debt, userName: user?.name ?? 'Client'),
                        ),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(AppSpacing.sm),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payments_outlined, size: 16, color: AppColors.primary),
                              SizedBox(width: 6),
                              Text('Enregistrer un paiement',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTile extends ConsumerWidget {
  final Order order;
  final User? user;
  const _OrderTile({required this.order, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = order.remainingAmount <= 0;
    final pct = order.totalAmount > 0
        ? (order.paidAmount / order.totalAmount).clamp(0.0, 1.0)
        : 0.0;

    return AppCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: isPaid ? AppColors.success : AppColors.warning,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.md),
                  bottomLeft: Radius.circular(AppSpacing.md),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(user?.name ?? 'Client inconnu',
                              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        Text('${order.remainingAmount.toStringAsFixed(0)} F restant',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isPaid ? AppColors.success : AppColors.danger,
                            )),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Total : ${order.totalAmount.toStringAsFixed(0)} F',
                            style: AppTextStyles.small),
                        const SizedBox(width: AppSpacing.sm),
                        Text('Payé : ${order.paidAmount.toStringAsFixed(0)} F',
                            style: AppTextStyles.small.copyWith(color: AppColors.success)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: AppColors.danger.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                      ),
                    ),
                    if (!isPaid) ...[
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Theme.of(context).cardColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
                          ),
                          builder: (_) => _OrderPaySheet(order: order, userName: user?.name ?? 'Client'),
                        ),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(AppSpacing.sm),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payments_outlined, size: 16, color: AppColors.primary),
                              SizedBox(width: 6),
                              Text('Payer une tranche',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebtPaySheet extends ConsumerStatefulWidget {
  final Debt debt;
  final String userName;
  const _DebtPaySheet({required this.debt, required this.userName});

  @override
  ConsumerState<_DebtPaySheet> createState() => _DebtPaySheetState();
}

class _DebtPaySheetState extends ConsumerState<_DebtPaySheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final paid = double.parse(_controller.text);
    await ref.read(markDebtPaidProvider(widget.debt.id).notifier).payAmount(paid);
    if (!mounted) return;
    final state = ref.read(markDebtPaidProvider(widget.debt.id));
    if (state.hasError) {
      AppFeedback.error(context, 'Erreur lors du paiement');
    } else {
      AppFeedback.success(context, 'Paiement enregistré');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(markDebtPaidProvider(widget.debt.id)).isLoading;

    return _PaySheetBody(
      title: 'Paiement dette',
      userName: widget.userName,
      totalAmount: widget.debt.amount,
      controller: _controller,
      formKey: _formKey,
      isLoading: isLoading,
      onSubmit: _submit,
    );
  }
}

class _OrderPaySheet extends ConsumerStatefulWidget {
  final Order order;
  final String userName;
  const _OrderPaySheet({required this.order, required this.userName});

  @override
  ConsumerState<_OrderPaySheet> createState() => _OrderPaySheetState();
}

class _OrderPaySheetState extends ConsumerState<_OrderPaySheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_controller.text);
    await ref.read(orderPaymentProvider.notifier).pay(
          orderId: widget.order.id,
          amount: amount,
        );
    if (!mounted) return;
    final state = ref.read(orderPaymentProvider);
    if (state.hasError) {
      AppFeedback.error(context, 'Erreur lors du paiement');
    } else {
      AppFeedback.success(context, 'Paiement enregistré');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(orderPaymentProvider).isLoading;
    return _PaySheetBody(
      title: 'Payer une tranche',
      userName: widget.userName,
      totalAmount: widget.order.remainingAmount,
      controller: _controller,
      formKey: _formKey,
      isLoading: isLoading,
      onSubmit: _submit,
    );
  }
}

class _PaySheetBody extends StatelessWidget {
  final String title;
  final String userName;
  final double totalAmount;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _PaySheetBody({
    required this.title,
    required this.userName,
    required this.totalAmount,
    required this.controller,
    required this.formKey,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.h2),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            Text(userName, style: AppTextStyles.small),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.06),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Montant dû', style: AppTextStyles.small),
                  Text('${totalAmount.toStringAsFixed(0)} F',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.danger)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
              autofocus: true,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface),
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.border),
                suffixText: 'F',
                suffixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requis';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'Doit être > 0';
                if (n > totalAmount) return 'Max : ${totalAmount.toStringAsFixed(0)} F';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _Quick(label: '25%', value: totalAmount * 0.25, controller: controller),
                const SizedBox(width: AppSpacing.sm),
                _Quick(label: '50%', value: totalAmount * 0.5, controller: controller),
                const SizedBox(width: AppSpacing.sm),
                _Quick(label: '75%', value: totalAmount * 0.75, controller: controller),
                const SizedBox(width: AppSpacing.sm),
                _Quick(label: 'Tout', value: totalAmount, controller: controller, primary: true),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Valider', icon: Icons.check, loading: isLoading, onTap: onSubmit),
          ],
        ),
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  final String label;
  final double value;
  final TextEditingController controller;
  final bool primary;
  const _Quick({required this.label, required this.value, required this.controller, this.primary = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.text = value.toStringAsFixed(0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: primary ? AppColors.primary : AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: primary ? Colors.white : AppColors.primary)),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          const SizedBox(height: AppSpacing.md),
          const Text('Erreur de chargement', style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: 'Réessayer', icon: Icons.refresh, onTap: onRetry, expanded: false),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;
  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: AppTextStyles.small));
  }
}

class _AddDebtSheet extends ConsumerStatefulWidget {
  const _AddDebtSheet();

  @override
  ConsumerState<_AddDebtSheet> createState() => _AddDebtSheetState();
}

class _AddDebtSheetState extends ConsumerState<_AddDebtSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  User? _selectedUser;
  DateTime? _dueDate;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedUser == null) {
      AppFeedback.error(context, 'Sélectionnez un client');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final error = await ref.read(createDebtProvider.notifier).create(CreateDebtDto(
      customerId: _selectedUser!.id,
      amount: double.parse(_amount.text),
      description: _description.text.trim(),
      dueDate: _dueDate?.toIso8601String(),
    ));

    if (error != null) {
      if (!mounted) return;
      AppFeedback.error(context, error.contains('customerId') ? 'Client requis' : 'Erreur lors de l\'ajout');
    } else {
      navigator.pop();
      messenger.showSnackBar(SnackBar(
        content: const Text('Dette enregistrée'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createDebtProvider).isLoading;
    final users = ref.watch(usersProvider);

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
                const Text('Nouvelle dette', style: AppTextStyles.h2),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Client', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: AppSpacing.xs),
            users.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Erreur', style: TextStyle(color: AppColors.danger)),
              data: (list) => DropdownButtonFormField<User>(
                value: _selectedUser,
                hint: const Text('Sélectionner un client'),
                validator: (v) => v == null ? 'Requis' : null,
                items: list.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
                onChanged: (u) => setState(() => _selectedUser = u),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(
              label: 'Montant',
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requis';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'Doit être > 0';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(
              label: 'Description',
              controller: _description,
              maxLines: 2,
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _DatePickerField(selected: _dueDate, onChanged: (d) => setState(() => _dueDate = d)),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Enregistrer la dette', icon: Icons.save_outlined, loading: isLoading, onTap: _submit),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime? selected;
  final ValueChanged<DateTime?> onChanged;
  const _DatePickerField({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date d\'échéance (optionnel)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selected ?? DateTime.now().add(const Duration(days: 7)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: AppColors.primary),
                ),
                child: child!,
              ),
            );
            onChanged(picked);
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: selected != null ? AppColors.primary : AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 18,
                    color: selected != null ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    selected != null
                        ? '${selected!.day.toString().padLeft(2, '0')}/${selected!.month.toString().padLeft(2, '0')}/${selected!.year}'
                        : 'Aucune date',
                    style: TextStyle(fontSize: 16,
                        color: selected != null ? AppColors.textPrimary : AppColors.textSecondary),
                  ),
                ),
                if (selected != null)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: Icon(Icons.close, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DebtHistoryInline extends ConsumerStatefulWidget {
  final String debtId;
  const _DebtHistoryInline({required this.debtId});

  @override
  ConsumerState<_DebtHistoryInline> createState() => _DebtHistoryInlineState();
}

class _DebtHistoryInlineState extends ConsumerState<_DebtHistoryInline> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(debtPaymentHistoryProvider(widget.debtId));

    return historyAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (history) {
        if (history.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${history.length} paiement${history.length > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: AppSpacing.sm),
              ...history.map((e) => _HistoryRow(entry: e)),
            ],
          ],
        );
      },
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final DebtPayment entry;
  const _HistoryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(entry.isFinal ? Icons.check_circle : Icons.check_circle_outline,
              size: 16, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.formattedDate,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      entry.isFinal ? 'Dette soldée' : 'Reste : ${entry.remainingAfter.toStringAsFixed(0)} F',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: entry.isFinal ? AppColors.success : null,
                      ),
                    ),
                    if (entry.isFinal) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(999)),
                        child: const Text('SOLDÉ',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text('+${entry.amount.toStringAsFixed(0)} F',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.success)),
        ],
      ),
    );
  }
}
