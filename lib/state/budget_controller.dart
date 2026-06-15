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

  Future<void> resetToDefaults() async {
    await _repo.reset();
    notifyListeners();
  }
}
