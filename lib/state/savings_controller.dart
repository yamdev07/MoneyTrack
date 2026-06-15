import 'package:flutter/foundation.dart';

import '../data/savings_repository.dart';
import '../models/savings_goal.dart';

/// Manages the savings goal and its running total.
class SavingsController extends ChangeNotifier {
  SavingsController(this._repo);

  final SavingsRepository _repo;

  SavingsGoal get goal => _repo.getGoal();
  double get saved => goal.savedAmount;
  double get progress => goal.progress;

  Future<void> setGoal({required String label, required double target, DateTime? deadline}) async {
    final updated = goal.copyWith(
      label: label,
      targetAmount: target,
      deadline: deadline,
    );
    await _repo.save(updated);
    notifyListeners();
  }

  Future<void> deposit(double amount) async {
    await _repo.deposit(amount);
    notifyListeners();
  }

  Future<void> withdraw(double amount) async {
    await _repo.deposit(-amount);
    notifyListeners();
  }
}
