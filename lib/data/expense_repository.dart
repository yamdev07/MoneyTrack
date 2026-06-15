import 'package:hive/hive.dart';

import '../core/app_constants.dart';
import '../core/date_helpers.dart';
import '../models/expense.dart';

/// CRUD + queries over the expense box.
class ExpenseRepository {
  Box<Expense> get _box => Hive.box<Expense>(AppConstants.expenseBox);

  /// All expenses, most recent first.
  List<Expense> all() {
    final items = _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  /// Expenses that happened within the month of [ref].
  List<Expense> forMonth(DateTime ref) =>
      all().where((e) => DateHelpers.isSameMonth(e.date, ref)).toList();

  /// Expenses within the week (Mon-Sun) of [ref].
  List<Expense> forWeek(DateTime ref) {
    final start = DateHelpers.startOfWeek(ref);
    final end = start.add(const Duration(days: 7));
    return all()
        .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
        .toList();
  }

  Future<void> add(Expense expense) => _box.put(expense.id, expense);

  Future<void> remove(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();

  /// Sum of every amount in [items].
  static double total(Iterable<Expense> items) =>
      items.fold(0.0, (sum, e) => sum + e.amount);
}
