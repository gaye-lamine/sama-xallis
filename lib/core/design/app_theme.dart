import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.background,
        surface: AppColors.surface,
        textPrimary: AppColors.textPrimary,
        textSecondary: AppColors.textSecondary,
        border: AppColors.border,
        cardColor: AppColors.background,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: const Color(0xFF111111),
        surface: const Color(0xFF1C1C1E),
        textPrimary: const Color(0xFFF2F2F7),
        textSecondary: const Color(0xFF8E8E93),
        border: const Color(0xFF2C2C2E),
        cardColor: const Color(0xFF1C1C1E),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
    required Color cardColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: surface,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primary,
        onSecondary: Colors.white,
        error: AppColors.danger,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
      ),
      cardColor: cardColor,
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.medium), borderSide: BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.medium), borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.medium), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.medium), borderSide: const BorderSide(color: AppColors.danger)),
        labelStyle: TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: TextStyle(color: textSecondary, fontSize: 16),
      ),
    );
  }
}

class AppRadius {
  static const double small = 6;
  static const double medium = 10;
  static const double large = 16;
}
