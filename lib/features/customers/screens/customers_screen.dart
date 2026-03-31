import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_input.dart';
import '../../users/models/create_user_dto.dart';
import '../../users/models/user_model.dart';
import '../../voice_notes/widgets/voice_note_widget.dart';
import '../providers/customers_provider.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts_outlined, color: AppColors.primary),
            tooltip: 'Importer un contact',
            onPressed: () => _importContact(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_outlined, color: AppColors.primary),
            onPressed: () => _showSheet(context),
          ),
        ],
      ),
      body: const _CustomerList(),
    );
  }

  void _showSheet(BuildContext context, {String? name, String? phone}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      builder: (_) => _AddCustomerSheet(prefillName: name, prefillPhone: phone),
    );
  }

  Future<void> _importContact(BuildContext context, WidgetRef ref) async {
    final granted = await FlutterContacts.requestPermission(readonly: true);
    if (!granted) {
      if (context.mounted) AppFeedback.error(context, 'Permission contacts refusée');
      return;
    }
    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return;
    final full = await FlutterContacts.getContact(contact.id, withProperties: true);
    if (full == null) return;
    final name = full.displayName.trim();
    final phone = full.phones.isNotEmpty ? full.phones.first.number.replaceAll(' ', '') : '';
    if (context.mounted) _showSheet(context, name: name, phone: phone);
  }
}

class _CustomerList extends ConsumerWidget {
  const _CustomerList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return users.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: AppSpacing.md),
            const Text('Erreur de chargement', style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Réessayer', icon: Icons.refresh, onTap: () => ref.invalidate(usersProvider), expanded: false),
          ],
        ),
      ),
      data: (list) => list.isEmpty
          ? const Center(child: Text('Aucun client', style: AppTextStyles.small))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => _CustomerTile(user: list[i]),
            ),
    );
  }
}

class _CustomerTile extends ConsumerWidget {
  final User user;
  const _CustomerTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(customerDebtSummaryProvider(user.id));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(user.name[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Row(children: [
                      Icon(Icons.phone_outlined, size: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(user.phone, style: AppTextStyles.small),
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              summary.when(
                loading: () => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                error: (_, __) => const SizedBox.shrink(),
                data: (s) => s.count == 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
                        child: const Text('Aucune dette', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${s.pending.toStringAsFixed(0)} F',
                              style: TextStyle(color: s.pending > 0 ? AppColors.danger : AppColors.success, fontWeight: FontWeight.w700, fontSize: 16)),
                          Text('${s.count} dette${s.count > 1 ? 's' : ''}', style: AppTextStyles.small),
                        ],
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          VoiceNoteWidget(entityType: 'customer', entityId: user.id),
        ],
      ),
    );
  }
}

class _AddCustomerSheet extends ConsumerStatefulWidget {
  final String? prefillName;
  final String? prefillPhone;

  const _AddCustomerSheet({this.prefillName, this.prefillPhone});

  @override
  ConsumerState<_AddCustomerSheet> createState() => _AddCustomerSheetState();
}

class _AddCustomerSheetState extends ConsumerState<_AddCustomerSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.prefillName ?? '');
    _phone = TextEditingController(text: widget.prefillPhone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(createUserProvider.notifier).create(
      CreateUserDto(name: _name.text.trim(), phone: _phone.text.trim()),
    );
    if (!mounted) return;
    final state = ref.read(createUserProvider);
    if (state.hasError) {
      final msg = state.error.toString();
      final friendly = msg.contains('already exists')
          ? 'Ce numéro est déjà utilisé'
          : msg.contains('Missing required')
              ? 'Nom et téléphone requis'
              : 'Erreur lors de la création';
      AppFeedback.error(context, friendly);
    } else if (!state.isLoading) {
      AppFeedback.success(context, 'Client ajouté');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createUserProvider).isLoading;

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
                const Text('Nouveau client', style: AppTextStyles.h2),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              label: 'Nom complet',
              controller: _name,
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(
              label: 'Numéro de téléphone',
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Ajouter le client', icon: Icons.person_add_outlined, loading: isLoading, onTap: _submit),
          ],
        ),
      ),
    );
  }
}
