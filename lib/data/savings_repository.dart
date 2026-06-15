import 'package:hive/hive.dart';

import '../core/app_constants.dart';
import '../models/savings_goal.dart';

/// Persists the user's [SavingsGoal].
class SavingsRepository {
  Box<SavingsGoal> get _box => Hive.box<SavingsGoal>(AppConstants.savingsBox);

  SavingsGoal getGoal() =>
      _box.get(AppConstants.savingsKey) ?? SavingsGoal.empty();

  Future<void> save(SavingsGoal goal) =>
      _box.put(AppConstants.savingsKey, goal);

  /// Adds [amount] to the saved total (negative to withdraw).
  Future<void> deposit(double amount) async {
    final goal = getGoal();
    final updated = goal.copyWith(
      savedAmount: (goal.savedAmount + amount).clamp(0, double.infinity),
    );
    await save(updated);
  }
}
