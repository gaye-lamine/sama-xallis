import 'package:flutter/material.dart';
import '../design/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  factory StatusBadge.stock(int stock) {
    if (stock == 0) return StatusBadge(label: 'Rupture', color: AppColors.danger);
    if (stock < 5) return StatusBadge(label: 'Faible', color: AppColors.warning);
    return StatusBadge(label: 'OK', color: AppColors.success);
  }

  factory StatusBadge.debt(String status) {
    switch (status) {
      case 'paid':
        return const StatusBadge(label: 'Payé', color: AppColors.success);
      case 'overdue':
        return const StatusBadge(label: 'En retard', color: AppColors.danger);
      default:
        return const StatusBadge(label: 'En attente', color: AppColors.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
