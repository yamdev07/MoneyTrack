import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/models/budget.dart';
import 'package:moneytrack/models/expense_category.dart';

void main() {
  group('Budget.defaults', () {
    final budget = Budget.defaults();

    test('allocates a reasonable share to food and housing', () {
      expect(budget.percentFor(ExpenseCategory.nourriture), 30);
      expect(budget.percentFor(ExpenseCategory.logement), 25);
    });

    test('spending allocation stays within 100%', () {
      expect(budget.totalAllocatedPercent, lessThanOrEqualTo(100));
    });

    test('reserves a savings percentage', () {
      expect(budget.savingsPercent, greaterThan(0));
    });

    test('copyWith overrides only the given fields', () {
      final updated = budget.copyWith(savingsPercent: 25);
      expect(updated.savingsPercent, 25);
      expect(updated.percentFor(ExpenseCategory.nourriture), 30);
    });
  });
}
