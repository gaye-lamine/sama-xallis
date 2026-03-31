import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_spacing.dart';
import '../design/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, danger, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool loading;
  final bool expanded;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.expanded = true,
  });

  Color get _bg {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.surface;
      case AppButtonVariant.danger:
        return AppColors.danger;
      case AppButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _fg {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }

  Border? get _border {
    if (variant == AppButtonVariant.secondary) {
      return Border.all(color: AppColors.border);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null || loading;

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _fg,
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20, color: _fg),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(label, style: AppTextStyles.button.copyWith(color: _fg)),
        ],
      ],
    );

    if (expanded) child = SizedBox(width: double.infinity, child: child);

    return Opacity(
      opacity: disabled ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: _border,
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
