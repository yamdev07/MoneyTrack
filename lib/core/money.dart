import 'package:intl/intl.dart';

/// Currency formatting helpers.
///
/// We keep formatting simple and locale-agnostic (fr_FR style grouping) so it
/// reads well for FCFA as well as €/\$.
class Money {
  Money._();

  static final NumberFormat _whole = NumberFormat('#,##0', 'fr_FR');
  static final NumberFormat _decimal = NumberFormat('#,##0.##', 'fr_FR');

  /// Formats [amount] with the given [currency] symbol appended.
  ///
  /// Whole numbers are shown without decimals (typical for FCFA); otherwise up
  /// to two decimals are shown.
  static String format(double amount, String currency) {
    final isWhole = amount == amount.roundToDouble();
    final number = isWhole ? _whole.format(amount) : _decimal.format(amount);
    return '$number $currency';
  }

  /// Compact form for tight spaces (e.g. 12,5k FCFA).
  static String compact(double amount, String currency) {
    if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M $currency';
    }
    if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}k $currency';
    }
    return format(amount, currency);
  }

  /// Parses a user-typed amount, tolerating spaces and commas as decimals.
  static double? tryParse(String input) {
    final cleaned = input.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
}
