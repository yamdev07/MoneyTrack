import 'app_constants.dart';
import '../models/budget.dart';
import '../models/expense_category.dart';

/// Computed budget vs. actual spending for a single category.
class CategoryBudget {
  const CategoryBudget({
    required this.category,
    required this.monthlyLimit,
    required this.spent,
  });

  final ExpenseCategory category;
  final double monthlyLimit;
  final double spent;

  double get weeklyLimit => monthlyLimit / AppConstants.weeksPerMonth;
  double get remaining => monthlyLimit - spent;

  /// Spending ratio in the 0..1+ range (can exceed 1 when over budget).
  double get ratio => monthlyLimit > 0 ? spent / monthlyLimit : 0;

  bool get isOver => monthlyLimit > 0 && spent > monthlyLimit;
  bool get isNearLimit => !isOver && ratio >= 0.8;
}

/// Turns a [Budget] allocation + salary + actual spending into per-category
/// limits, and exposes weekly budget figures (cahier §3.1, §3.2).
class BudgetCalculator {
  const BudgetCalculator({
    required this.salary,
    required this.budget,
    required this.spentByCategory,
  });

  final double salary;
  final Budget budget;

  /// categoryId -> amount actually spent this month.
  final Map<int, double> spentByCategory;

  double monthlyLimitFor(ExpenseCategory category) =>
      salary * budget.percentFor(category) / 100;

  /// One row per category that has a limit or some spending.
  List<CategoryBudget> categories() {
    final result = <CategoryBudget>[];
    for (final category in ExpenseCategory.values) {
      final limit = monthlyLimitFor(category);
      final spent = spentByCategory[category.id] ?? 0;
      if (limit <= 0 && spent <= 0) continue;
      result.add(CategoryBudget(
        category: category,
        monthlyLimit: limit,
        spent: spent,
      ));
    }
    return result;
  }

  /// Total monthly money allocated to spending categories.
  double get monthlyBudgetTotal => salary * budget.totalAllocatedPercent / 100;

  /// Weekly allowance: the user's manual amount when set, otherwise derived
  /// from the monthly allocation.
  double get weeklyBudgetTotal => budget.hasManualWeeklyBudget
      ? budget.weeklyBudget
      : monthlyBudgetTotal / AppConstants.weeksPerMonth;

  /// Amount earmarked for savings each month.
  double get monthlySavingsTarget => salary * budget.savingsPercent / 100;

  /// Categories currently over their limit.
  List<CategoryBudget> get overspentCategories =>
      categories().where((c) => c.isOver).toList();
}
