import 'package:hive/hive.dart';

import '../core/app_constants.dart';
import '../models/budget.dart';

/// Persists the user's monthly [Budget] allocation.
class BudgetRepository {
  Box<Budget> get _box => Hive.box<Budget>(AppConstants.budgetBox);

  /// Returns the saved budget, or sensible defaults the first time.
  Budget getBudget() => _box.get(AppConstants.budgetKey) ?? Budget.defaults();

  Future<void> save(Budget budget) => _box.put(AppConstants.budgetKey, budget);

  Future<void> reset() => save(Budget.defaults());
}
