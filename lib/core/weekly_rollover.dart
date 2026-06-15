import 'date_helpers.dart';
import '../models/expense.dart';

/// Computes the carry-over of a "rolling" weekly budget.
///
/// For every completed week between the first recorded expense and the current
/// week, the unspent part of the allowance (`allowance - spent`) accumulates.
/// A positive result means extra money to spend this week; a negative result
/// means past overspending eats into it.
class WeeklyRollover {
  const WeeklyRollover._();

  /// Maximum number of past weeks scanned, as a safety bound.
  static const int _maxWeeks = 520; // ~10 years

  /// Sums `allowance - spent` over completed weeks.
  ///
  /// Counting starts at the week of [since] when given (e.g. the last sweep to
  /// savings), otherwise at the week of the first recorded expense.
  static double carryover({
    required List<Expense> expenses,
    required double weeklyAllowance,
    required DateTime now,
    DateTime? since,
  }) {
    if (weeklyAllowance <= 0 || expenses.isEmpty) return 0;

    final firstDate = expenses
        .map((e) => e.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final startDate = since != null && since.isAfter(firstDate) ? since : firstDate;
    var weekStart = DateHelpers.startOfWeek(startDate);
    final currentStart = DateHelpers.startOfWeek(now);

    var carry = 0.0;
    var guard = 0;
    while (weekStart.isBefore(currentStart) && guard < _maxWeeks) {
      final weekEnd = weekStart.add(const Duration(days: 7));
      final spent = expenses
          .where((e) => !e.date.isBefore(weekStart) && e.date.isBefore(weekEnd))
          .fold(0.0, (sum, e) => sum + e.amount);
      carry += weeklyAllowance - spent;
      weekStart = weekEnd;
      guard++;
    }
    return carry;
  }
}
