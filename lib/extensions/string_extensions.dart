import 'package:fraction/fraction.dart';

extension StringExtensions on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  (double, String) parseQuantity() {
    var input = trim();

    if (input.contains('/')) {
      final parts = input.split('/');
      input = parts.first;
    }

    final regex = RegExp(r'^([\d\s\/\.]+)\s*([a-zA-Z]+.*)?$');
    final match = regex.firstMatch(input);

    if (match == null) {
      return (0.0, '');
    }

    String numberPart = match.group(1)?.trim() ?? '';
    String measure = match.group(2)?.trim() ?? 'pieces';

    double count = 0.0;
    try {
      count = Fraction.fromString(numberPart).toDouble();
    } catch (_) {
      count = double.tryParse(numberPart) ?? 0.0;
    }

    return (count, measure.isNotEmpty ? measure : 'pieces');
  }
}
