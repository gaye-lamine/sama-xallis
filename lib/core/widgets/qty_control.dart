import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_spacing.dart';

class QtyControl extends StatelessWidget {
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool canAdd;

  const QtyControl({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onRemove,
    this.canAdd = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Btn(
          icon: Icons.remove,
          onTap: onRemove,
          color: AppColors.danger,
        ),
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        _Btn(
          icon: Icons.add,
          onTap: canAdd ? onAdd : null,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _Btn({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.3 : 1.0,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class AppRadius {
  static const double small = 6;
  static const double medium = 10;
  static const double large = 16;
  static const double pill = 999;
}
