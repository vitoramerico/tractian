import 'colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent, width: 0),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    isDense: true,
    fillColor: const Color(0xFFEAEFF3),
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    prefixIconColor: const Color(0xFF8E98A3),
    suffixIconColor: const Color(0xFF8E98A3),
    hintStyle: const TextStyle(color: Color(0xFF8E98A3)),
    filled: true,
    enabledBorder: _outlineInputBorder,
    disabledBorder: _outlineInputBorder,
    border: _outlineInputBorder,
    focusedBorder: _outlineInputBorder,
  );

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: Colors.white,

    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.brandBlueDark,
      foregroundColor: Colors.white,
    ),
  );
}
