import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/core/budget_calculator.dart';
import 'package:moneytrack/models/budget.dart';
import 'package:moneytrack/models/expense_category.dart';

void main() {
  final budget = Budget(
    percentages: {
      ExpenseCategory.nourriture.id: 30,
      ExpenseCategory.transport.id: 10,
    },
    savingsPercent: 15,
  );

  group('BudgetCalculator', () {
    test('computes monthly limit from salary percentage', () {
      final calc = BudgetCalculator(
        salary: 100000,
        budget: budget,
        spentByCategory: const {},
      );
      expect(calc.monthlyLimitFor(ExpenseCategory.nourriture), 30000);
    });

    test('flags a category as over budget', () {
      final calc = BudgetCalculator(
        salary: 100000,
        budget: budget,
        spentByCategory: {ExpenseCategory.nourriture.id: 40000},
      );
      final food = calc
          .categories()
          .firstWhere((c) => c.category == ExpenseCategory.nourriture);
      expect(food.isOver, isTrue);
      expect(food.remaining, -10000);
    });

    test('weekly budget total divides the monthly allocation', () {
      final calc = BudgetCalculator(
        salary: 100000,
        budget: budget,
        spentByCategory: const {},
      );
      // 40% of 100000 = 40000 monthly, /4.345 weeks.
      expect(calc.weeklyBudgetTotal, closeTo(40000 / 4.345, 0.01));
    });

    test('savings target follows the savings percentage', () {
      final calc = BudgetCalculator(
        salary: 100000,
        budget: budget,
        spentByCategory: const {},
      );
      expect(calc.monthlySavingsTarget, 15000);
    });
  });
}
