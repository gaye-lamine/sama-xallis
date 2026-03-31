import 'package:flutter/material.dart';

class AppColors {
  // Semantic — same in both modes
  static const primary = Color(0xFF0A84FF);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  // Light mode statics (used in theme definition only)
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
}

// Context-aware colors — use these in widgets
extension AppColorsX on BuildContext {
  Color get bg => Theme.of(this).colorScheme.surface;
  Color get card => Theme.of(this).cardColor;
  Color get textPrimary => Theme.of(this).colorScheme.onSurface;
  Color get textSecondary => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF8E8E93)
      : const Color(0xFF6B7280);
  Color get borderColor => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF2C2C2E)
      : const Color(0xFFE5E7EB);
  Color get surfaceColor => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF1C1C1E)
      : const Color(0xFFF5F5F5);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
