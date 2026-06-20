import 'package:flutter/material.dart';

import 'forge_colors.dart';

/// ThemeData for The Forge — inherits FLUBBER language.
abstract final class ForgeTheme {
  static ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: ForgeColors.void_,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: ForgeColors.periwinkle,
        onPrimary: ForgeColors.white,
        secondary: ForgeColors.night,
        onSecondary: ForgeColors.white,
        error: ForgeColors.critical,
        onError: ForgeColors.white,
        surface: ForgeColors.surface,
        onSurface: ForgeColors.white,
        outline: ForgeColors.divider,
      ),
      cardTheme: CardThemeData(
        color: ForgeColors.night,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ForgeColors.divider.withAlpha(40)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ForgeColors.surface,
        foregroundColor: ForgeColors.white,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ForgeColors.surface,
        selectedItemColor: ForgeColors.periwinkle,
        unselectedItemColor: ForgeColors.muted,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ForgeColors.surface,
        contentTextStyle: const TextStyle(color: ForgeColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ForgeColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ForgeColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ForgeColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ForgeColors.periwinkle, width: 2),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ForgeColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: ForgeColors.cloud,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ForgeColors.periwinkle,
        brightness: Brightness.light,
      ).copyWith(
        primary: ForgeColors.periwinkle,
        error: ForgeColors.critical,
      ),
      cardTheme: CardThemeData(
        color: ForgeColors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ForgeColors.ink3),
        ),
      ),
    );
  }
}
