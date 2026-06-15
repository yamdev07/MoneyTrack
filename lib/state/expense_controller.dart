import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/expense_repository.dart';
import '../models/expense.dart';

/// Manages the list of expenses and exposes derived totals.
class ExpenseController extends ChangeNotifier {
  ExpenseController(this._repo);

  final ExpenseRepository _repo;
  static const _uuid = Uuid();

  List<Expense> get all => _repo.all();

  List<Expense> monthExpenses([DateTime? ref]) =>
      _repo.forMonth(ref ?? DateTime.now());

  List<Expense> weekExpenses([DateTime? ref]) =>
      _repo.forWeek(ref ?? DateTime.now());

  double get monthTotal => ExpenseRepository.total(monthExpenses());
  double get weekTotal => ExpenseRepository.total(weekExpenses());

  /// Sum spent this month, grouped by category id.
  Map<int, double> monthByCategory([DateTime? ref]) {
    final map = <int, double>{};
    for (final e in monthExpenses(ref)) {
      map.update(e.categoryId, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    return map;
  }

  Future<Expense> addExpense({
    required double amount,
    required int categoryId,
    required DateTime date,
    String description = '',
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      categoryId: categoryId,
      date: date,
      description: description,
    );
    await _repo.add(expense);
    notifyListeners();
    return expense;
  }

  Future<void> delete(String id) async {
    await _repo.remove(id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _repo.clear();
    notifyListeners();
  }
}
