import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
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
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            Column(children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: const Text('SX', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text('Sama Xaalis', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.xs),
              const Text('Gérez vos ventes simplement', style: AppTextStyles.small),
            ]),
            const SizedBox(height: AppSpacing.xl),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(AppSpacing.sm)),
              child: TabBar(
                controller: _tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSpacing.sm)),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                tabs: const [Tab(text: 'Connexion'), Tab(text: 'Inscription')],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _LoginTab(),
                  _RegisterTab(onSuccess: () => _tab.animateTo(0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOGIN ───────────────────────────────────────────────────────────────────

class _LoginTab extends ConsumerStatefulWidget {
  const _LoginTab();
  @override
  ConsumerState<_LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends ConsumerState<_LoginTab> {
  final _phoneCtrl = TextEditingController();
  String _pin = '';
  bool _phoneEntered = false;
  String? _phoneError;

  @override
  void dispose() { _phoneCtrl.dispose(); super.dispose(); }

  void _next() {
    final p = _phoneCtrl.text.trim();
    if (p.isEmpty) { setState(() => _phoneError = 'Entrez votre numéro'); return; }
    if (p.length < 6) { setState(() => _phoneError = 'Numéro trop court'); return; }
    setState(() { _phoneError = null; _phoneEntered = true; });
  }

  void _key(String d) {
    if (_pin.length < 4) {
      setState(() => _pin += d);
      if (_pin.length == 4) _submit();
    }
  }

  void _del() { if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1)); }

  Future<void> _submit() async {
    final error = await ref.read(authProvider.notifier).login(_phoneCtrl.text.trim(), _pin);
    if (!mounted) return;
    if (error != null) {
      setState(() { _pin = ''; _phoneEntered = false; _phoneError = _msg(error); });
    }
  }

  String _msg(String r) {
    if (r.contains('Invalid phone or PIN')) return 'Numéro ou PIN incorrect';
    if (r.contains('Phone and PIN')) return 'Remplissez tous les champs';
    if (r.contains('Token expired')) return 'Session expirée';
    if (r.contains('network') || r.contains('connect')) return 'Vérifiez votre connexion';
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider) is AuthLoading;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          if (!_phoneEntered) ...[
            const Text('Votre numéro', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 3),
              onChanged: (_) => setState(() => _phoneError = null),
              onSubmitted: (_) => _next(),
              decoration: InputDecoration(
                hintText: '77 000 00 00',
                hintStyle: const TextStyle(color: AppColors.border, fontSize: 20, letterSpacing: 2),
                filled: true, fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm), borderSide: const BorderSide(color: AppColors.danger)),
                errorText: _phoneError,
                prefixIcon: Icon(Icons.phone_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _Btn(label: 'Continuer', onTap: _next),
          ] else ...[
            GestureDetector(
              onTap: () => setState(() { _phoneEntered = false; _pin = ''; }),
              child: Row(children: [
                const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(_phoneCtrl.text, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Center(child: Text('Entrez votre PIN', style: AppTextStyles.h3)),
            const SizedBox(height: AppSpacing.lg),
            Center(child: _Dots(length: _pin.length)),
            const SizedBox(height: AppSpacing.xl),
            if (loading) const Center(child: CircularProgressIndicator())
            else _Keypad(onKey: _key, onDelete: _del),
          ],
        ],
      ),
    );
  }
}

// ─── REGISTER ────────────────────────────────────────────────────────────────

class _RegisterTab extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;
  const _RegisterTab({required this.onSuccess});
  @override
  ConsumerState<_RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends ConsumerState<_RegisterTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _pin = '';
  bool _pinTouched = false;

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); super.dispose(); }

  void _key(String d) { if (_pin.length < 4) setState(() => _pin += d); }
  void _del() { if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1)); }

  Future<void> _submit() async {
    setState(() => _pinTouched = true);
    if (!_formKey.currentState!.validate()) return;
    if (_pin.length != 4) return;
    final ok = await ref.read(authProvider.notifier).register(_nameCtrl.text.trim(), _phoneCtrl.text.trim(), _pin);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Compte créé — connectez-vous'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ));
      widget.onSuccess();
    }
  }

  String _msg(String r) {
    if (r.contains('already exists')) return 'Ce numéro est déjà utilisé';
    if (r.contains('PIN must be exactly 4')) return 'PIN doit contenir 4 chiffres';
    if (r.contains('Missing required')) return 'Remplissez tous les champs';
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final loading = authState is AuthLoading;
    final error = authState is AuthError ? _msg(authState.message) : null;
    final pinError = _pinTouched && _pin.length != 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            _Field(label: 'Nom complet', hint: 'Ex: Awa Diallo', icon: Icons.person_outline, ctrl: _nameCtrl,
              validator: (v) { if (v == null || v.trim().isEmpty) return 'Requis'; if (v.trim().length < 2) return 'Trop court'; return null; }),
            const SizedBox(height: AppSpacing.md),
            _Field(label: 'Téléphone', hint: 'Ex: 771234567', icon: Icons.phone_outlined, ctrl: _phoneCtrl,
              type: TextInputType.phone,
              validator: (v) { if (v == null || v.trim().isEmpty) return 'Requis'; if (v.trim().length < 6) return 'Trop court'; return null; }),
            const SizedBox(height: AppSpacing.xl),
            const Text('PIN à 4 chiffres', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.xs),
            const Text('Pour vous connecter', style: AppTextStyles.small),
            const SizedBox(height: AppSpacing.lg),
            Center(child: _Dots(length: _pin.length, error: pinError)),
            if (pinError) ...[
              const SizedBox(height: AppSpacing.sm),
              const Center(child: Text('4 chiffres requis', style: TextStyle(color: AppColors.danger, fontSize: 13))),
            ],
            const SizedBox(height: AppSpacing.lg),
            _Keypad(onKey: _key, onDelete: _del),
            if (error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.08), borderRadius: BorderRadius.circular(AppSpacing.sm)),
                child: Row(children: [
                  const Icon(Icons.error_outline, size: 16, color: AppColors.danger),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(error, style: const TextStyle(color: AppColors.danger, fontSize: 14))),
                ]),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            _Btn(label: 'Créer mon compte', loading: loading, onTap: _submit),
          ],
        ),
      ),
    );
  }
}

// ─── WIDGETS ─────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String label, hint;
  final IconData icon;
  final TextEditingController ctrl;
  final TextInputType? type;
  final String? Function(String?)? validator;
  const _Field({required this.label, required this.hint, required this.icon, required this.ctrl, this.type, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: ctrl, keyboardType: type, validator: validator,
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 15),
            prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 20),
            filled: true, fillColor: Theme.of(context).scaffoldBackgroundColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm), borderSide: const BorderSide(color: AppColors.danger)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int length;
  final bool error;
  const _Dots({required this.length, this.error = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final filled = i < length;
        final color = error ? AppColors.danger : (filled ? AppColors.primary : AppColors.border);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: filled ? 20 : 16, height: filled ? 20 : 16,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onKey;
  final VoidCallback onDelete;
  const _Keypad({required this.onKey, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final keys = ['1','2','3','4','5','6','7','8','9','','0','⌫'];
    return GridView.count(
      crossAxisCount: 3, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: AppSpacing.sm, crossAxisSpacing: AppSpacing.sm,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => k == '⌫' ? onDelete() : onKey(k),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(AppSpacing.sm), border: Border.all(color: AppColors.border)),
            alignment: Alignment.center,
            child: k == '⌫'
                ? Icon(Icons.backspace_outlined, size: 22, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                : Text(k, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          ),
        );
      }).toList(),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;
  const _Btn({required this.label, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
