import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/cache/hive_boxes.dart';
import 'core/cache/sync_service.dart';
import 'core/design/app_theme.dart';
import 'core/design/app_colors.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/repository_providers.dart';
import 'core/providers/unauthorized_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/sales/screens/sales_screen.dart';
import 'features/products/screens/products_screen.dart';
import 'features/customers/screens/customers_screen.dart';
import 'features/debts/screens/debts_screen.dart';
import 'features/stats/screens/stats_screen.dart';
import 'features/settings/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncServiceProvider);
    final auth = ref.watch(authProvider);

    ref.listen(unauthorizedProvider, (_, __) {
      ref.read(authProvider.notifier).logout();
    });

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Sama Xaalis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: switch (auth) {
        AuthInitial() => const Scaffold(body: Center(child: CircularProgressIndicator())),
        AuthLoading() => const Scaffold(body: Center(child: CircularProgressIndicator())),
        AuthUnauthenticated() => const LoginScreen(),
        AuthError() => const LoginScreen(),
        AuthAuthenticated() => const AppShell(),
      },
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  final _screens = const [
    SalesScreen(),
    ProductsScreen(),
    CustomersScreen(),
    DebtsScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  void _onTap(int i) {
    if (i == 4) {
      ref.invalidate(ordersProvider);
      ref.invalidate(debtsProvider);
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.card,
          border: Border(top: BorderSide(color: context.borderColor)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(icon: Icons.point_of_sale, label: 'Ventes', selected: _index == 0, onTap: () => _onTap(0)),
                _NavItem(icon: Icons.inventory_2_outlined, label: 'Produits', selected: _index == 1, onTap: () => _onTap(1)),
                _NavItem(icon: Icons.people_outline, label: 'Clients', selected: _index == 2, onTap: () => _onTap(2)),
                _NavItem(icon: Icons.account_balance_wallet_outlined, label: 'Dettes', selected: _index == 3, onTap: () => _onTap(3)),
                _NavItem(icon: Icons.bar_chart, label: 'Stats', selected: _index == 4, onTap: () => _onTap(4)),
                _NavItem(icon: Icons.settings_outlined, label: 'Réglages', selected: _index == 5, onTap: () => _onTap(5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary;
    final inactive = context.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: selected ? primary : inactive),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? primary : inactive,
            )),
          ],
        ),
      ),
    );
  }
}
