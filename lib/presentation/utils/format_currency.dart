import 'package:intl/intl.dart';

// Formats an integer amount as a compact currency string.
String formatCurrency({required int amount}) {
  final formattedCurrency = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 0,
  ).format(amount);

  return formattedCurrency;
}
