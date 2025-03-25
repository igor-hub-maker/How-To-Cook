import 'package:flutter/material.dart';

extension BuildContextExtention on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get bottomSaveArea => MediaQuery.of(this).viewPadding.bottom;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
