import 'package:flutter/material.dart';

class AppColors {
  static ColorScheme colorScheme = const ColorScheme.light();

  static void initializeColors(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
  }
}
