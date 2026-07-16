import 'package:flutter/material.dart';

/// Centralized design tokens.
///
/// BEFORE: the old home_screen.dart called `Colors.green[800]`,
/// `Colors.green[50]`, `Colors.purple`, `Colors.orange[900]` etc. directly,
/// dozens of times, with no single source of truth. Changing the brand
/// color meant hunting through 600+ lines of widget code. There was also no
/// dark mode support at all.
///
/// AFTER: one ColorScheme-driven theme, semantic risk colors kept separate
/// (they're data-driven, not brand colors), and both light + dark variants.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF2E7D32); // Colors.green[800] equivalent

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          minimumSize: const Size.fromHeight(56),
        ),
      ),
    );
  }
}

/// Risk-level colors are semantic (driven by backend data, e.g.
/// 'VERY LOW'..'EXTREME'), not brand colors, so they stay independent of the
/// light/dark ColorScheme and are looked up by the domain layer instead.
class RiskColors {
  RiskColors._();

  static Color forLevel(String risk) {
    final r = risk.toLowerCase();
    if (r.contains('very low') || r.contains('low')) return Colors.green;
    if (r.contains('moderate')) return Colors.orange;
    if (r.contains('extreme')) return Colors.red.shade900;
    if (r.contains('high')) return Colors.red.shade600;
    return Colors.grey;
  }
}
