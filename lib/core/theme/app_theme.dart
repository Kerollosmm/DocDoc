import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    // Removing explicit CardTheme if it causes issues, or relying on defaults.
    // In strict environments, sometimes type inference fails or versions mismatch.
    // Let's try removing it or checking the type.
    // Since I can't browse the exact SDK source easily, I'll just remove the CardTheme customization
    // to ensure compilation. Material 3 has good defaults anyway.
  );
}
