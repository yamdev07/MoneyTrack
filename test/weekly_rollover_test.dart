import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/core/weekly_rollover.dart';
import 'package:moneytrack/models/expense.dart';

Expense _exp(String id, double amount, DateTime date) =>
    Expense(id: id, amount: amount, categoryId: 0, date: date);

void main() {
  group('WeeklyRollover.carryover', () {
    // Reference "now" in the week of Mon 2024-06-17 .. Sun 2024-06-23.
    final now = DateTime(2024, 6, 18); // a Tuesday

    test('is zero without expenses', () {
      expect(
        WeeklyRollover.carryover(
          expenses: const [],
          weeklyAllowance: 20000,
          now: now,
        ),
        0,
      );
    });

    test('is zero when allowance is not set', () {
      expect(
        WeeklyRollover.carryover(
          expenses: [_exp('a', 5000, DateTime(2024, 6, 10))],
          weeklyAllowance: 0,
          now: now,
        ),
        0,
      );
    });

    test('accumulates the unspent part of the previous week', () {
      // Previous week (Mon 2024-06-10): spent 12000 of 20000 -> +8000 carried.
      final carry = WeeklyRollover.carryover(
        expenses: [_exp('a', 12000, DateTime(2024, 6, 12))],
        weeklyAllowance: 20000,
        now: now,
      );
      expect(carry, 8000);
    });

    test('goes negative when a past week overspent', () {
      // Previous week spent 26000 of 20000 -> -6000 carried.
      final carry = WeeklyRollover.carryover(
        expenses: [_exp('a', 26000, DateTime(2024, 6, 12))],
        weeklyAllowance: 20000,
        now: now,
      );
      expect(carry, -6000);
    });

    test('ignores spending of the current week', () {
      // Only a current-week expense -> no completed past week -> 0.
      final carry = WeeklyRollover.carryover(
        expenses: [_exp('a', 5000, now)],
        weeklyAllowance: 20000,
        now: now,
      );
      expect(carry, 0);
    });

    test('since excludes already-swept weeks (savings mode)', () {
      // Two past weeks with surplus, but counting only from the 2nd one.
      final expenses = [
        _exp('a', 12000, DateTime(2024, 6, 5)), // week of Mon 2024-06-03
        _exp('b', 15000, DateTime(2024, 6, 12)), // week of Mon 2024-06-10
      ];
      final fromSecondWeek = WeeklyRollover.carryover(
        expenses: expenses,
        weeklyAllowance: 20000,
        now: now,
        since: DateTime(2024, 6, 10),
      );
      // Only week of 06-10 counts: 20000 - 15000 = 5000.
      expect(fromSecondWeek, 5000);
    });
  });
}
