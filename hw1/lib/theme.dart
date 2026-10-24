import 'package:flutter/material.dart';

const ink = Color(0xFF182E28);
const forest = Color(0xFF215C43);
const paper = Color(0xFFF8F8F2);
const muted = Color(0xFF6A756D);
const line = Color(0xFFE1E5DB);
const lime = Color(0xFFD5EF8A);

final campusTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Manrope',
  scaffoldBackgroundColor: paper,
  colorScheme: ColorScheme.fromSeed(
    seedColor: forest,
    primary: forest,
    surface: paper,
    onSurface: ink,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: paper,
    foregroundColor: ink,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  dividerColor: line,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: ink,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
);
