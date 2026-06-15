import 'package:flutter/foundation.dart';

import '../data/budget_repository.dart';
import '../models/budget.dart';
import '../models/expense_category.dart';

/// Manages the monthly budget allocation.
class BudgetController extends ChangeNotifier {
  BudgetController(this._repo);

  final BudgetRepository _repo;

  Budget get budget => _repo.getBudget();

  Future<void> setPercent(ExpenseCategory category, double percent) async {
    final updated = Map<int, double>.from(budget.percentages);
    updated[category.id] = percent.clamp(0, 100);
    await _repo.save(budget.copyWith(percentages: updated));
    notifyListeners();
  }

  Future<void> setSavingsPercent(double percent) async {
    await _repo.save(budget.copyWith(savingsPercent: percent.clamp(0, 100)));
    notifyListeners();
  }

  /// Sets a manual weekly budget. Pass `0` to go back to the automatic value.
  Future<void> setWeeklyBudget(double amount) async {
    await _repo.save(
      budget.copyWith(weeklyBudget: amount.clamp(0, double.infinity).toDouble()),
    );
    notifyListeners();
  }

  /// Chooses what happens with the weekly surplus (none / rollover / savings).
  Future<void> setSurplusMode(WeeklySurplusMode mode) async {
    await _repo.save(budget.copyWith(surplusMode: mode));
    notifyListeners();
  }

  /// Records that the surplus up to [weekStart] has been swept into savings,
  /// so it is no longer offered for transfer.
  Future<void> markSurplusSwept(DateTime weekStart) async {
    await _repo.save(budget.copyWith(lastSweepWeekStart: weekStart));
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    await _repo.reset();
    notifyListeners();
  }
}
