import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../exports/providers/export_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/stats_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(ordersProvider);
              ref.invalidate(debtsProvider);
            },
          ),
        ],
      ),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              const SizedBox(height: AppSpacing.md),
              const Text('Erreur de chargement', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () {
                  ref.invalidate(ordersProvider);
                  ref.invalidate(debtsProvider);
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (s) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(ordersProvider);
            ref.invalidate(debtsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _BigCard(label: 'Chiffre d\'affaires', value: '${s.revenue.toStringAsFixed(0)} F', color: AppColors.primary, icon: Icons.trending_up),
              const SizedBox(height: AppSpacing.md),
              _BigCard(label: 'Total encaissé', value: '${s.totalCollected.toStringAsFixed(0)} F', color: AppColors.success, icon: Icons.account_balance_wallet),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Cash', value: '${s.cashCollected.toStringAsFixed(0)} F', color: AppColors.success, icon: Icons.payments_outlined)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _StatCard(label: 'Crédit encaissé', value: '${s.creditCollected.toStringAsFixed(0)} F', color: AppColors.warning, icon: Icons.credit_card_outlined)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _CollectionCard(rate: s.collectionRate),
              const SizedBox(height: AppSpacing.xl),
              _SectionLabel('Dettes'),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Total dettes', value: '${s.totalDebt.toStringAsFixed(0)} F', color: AppColors.danger, icon: Icons.account_balance_wallet_outlined)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _StatCard(label: 'En retard', value: '${s.overdueDebt.toStringAsFixed(0)} F', color: AppColors.danger, icon: Icons.warning_amber_outlined)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionLabel('Commandes'),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Total', value: '${s.totalOrders}', color: AppColors.primary, icon: Icons.receipt_long_outlined)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _StatCard(label: 'Payées', value: '${s.paidOrders}', color: AppColors.success, icon: Icons.check_circle_outline)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _StatCard(label: 'Impayées', value: '${s.unpaidOrders}', color: AppColors.danger, icon: Icons.pending_outlined)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionLabel('Exports'),
              const SizedBox(height: AppSpacing.md),
              const _ExportSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), letterSpacing: 1.2),
      );
}

class _BigCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _BigCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSpacing.md)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 40),
          const SizedBox(width: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.small),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final double rate;
  const _CollectionCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    final pct = rate.clamp(0.0, 1.0);
    final color = pct >= 0.8 ? AppColors.success : pct >= 0.5 ? AppColors.warning : AppColors.danger;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Taux de recouvrement', style: AppTextStyles.body),
              Text('${(pct * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: AppColors.border, valueColor: AlwaysStoppedAnimation<Color>(color)),
          ),
        ],
      ),
    );
  }
}

class _ExportSection extends StatelessWidget {
  const _ExportSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ExportTile(type: ExportType.orders, icon: Icons.receipt_long_outlined, label: 'Commandes', subtitle: 'Toutes les commandes'),
        const SizedBox(height: AppSpacing.sm),
        _ExportTile(type: ExportType.debts, icon: Icons.account_balance_wallet_outlined, label: 'Dettes', subtitle: 'Toutes les dettes clients'),
        const SizedBox(height: AppSpacing.sm),
        _ExportTile(type: ExportType.summary, icon: Icons.bar_chart, label: 'Rapport global', subtitle: 'Résumé complet'),
      ],
    );
  }
}

class _ExportTile extends ConsumerWidget {
  final ExportType type;
  final IconData icon;
  final String label;
  final String subtitle;

  const _ExportTile({required this.type, required this.icon, required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportProvider(type));

    ref.listen(exportProvider(type), (_, next) {
      if (next.hasError) {
        AppFeedback.error(context, 'Export impossible momentanément');
      }
    });

    return AppCard(
      onTap: state.isLoading ? null : () => _launch(context, ref),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppSpacing.sm)),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.small),
              ],
            ),
          ),
          state.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
              : const Icon(Icons.download_outlined, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }

  Future<void> _launch(BuildContext context, WidgetRef ref) async {
    final url = await ref.read(exportProvider(type).notifier).launch();
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      AppFeedback.error(context, 'Impossible d\'ouvrir le fichier');
    }
  }
}
