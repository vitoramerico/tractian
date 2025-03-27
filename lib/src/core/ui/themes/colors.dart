import 'package:flutter/material.dart';

abstract final class AppColors {
  static const brandBlueDark = Color(0xff17192d);
  static const brandBlueLight = Color(0xff2188ff);

  static final lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: brandBlueDark,
  );
}
