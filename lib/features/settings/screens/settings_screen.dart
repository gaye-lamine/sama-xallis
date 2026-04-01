import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/providers/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth is AuthAuthenticated ? auth.user : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (user != null && user.name.isNotEmpty) ...[
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
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
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          _SectionLabel('Application'),
          const SizedBox(height: AppSpacing.sm),
          _ThemeTile(),
          const SizedBox(height: AppSpacing.sm),
          _VersionTile(),
          const SizedBox(height: AppSpacing.lg),
          _SectionLabel('Compte'),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            onTap: () => _confirmLogout(context, ref),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(AppSpacing.sm)),
                  child: const Icon(Icons.logout, size: 18, color: AppColors.danger),
                ),
                const SizedBox(width: AppSpacing.md),
                const Text('Se déconnecter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.danger)),
                const Spacer(),
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md)),
        title: const Text('Déconnexion', style: AppTextStyles.h3),
        content: const Text('Voulez-vous vraiment vous déconnecter ?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Déconnecter', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), letterSpacing: 1.2),
    );
  }
}

class _ThemeTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    return AppCard(
      onTap: () => ref.read(themeModeProvider.notifier).toggle(),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text('Apparence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(isDark ? 'Sombre' : 'Clair', style: AppTextStyles.small),
          const SizedBox(width: AppSpacing.sm),
          Switch.adaptive(
            value: isDark,
            activeColor: AppColors.primary,
            onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
    );
  }
}

class _VersionTile extends StatefulWidget {
  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = '${info.version} (${info.buildNumber})');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppSpacing.sm)),
            child: const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text('Version', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(_version, style: AppTextStyles.small),
        ],
      ),
    );
  }
}
