import 'package:hive/hive.dart';

import 'expense_category.dart';

/// A single spending record.
class Expense extends HiveObject {
  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.description = '',
  });

  /// Unique identifier (uuid v4).
  final String id;

  /// Amount spent, in the user's currency.
  final double amount;

  /// Stable id of the [ExpenseCategory].
  final int categoryId;

  /// When the expense happened.
  final DateTime date;

  /// Optional free-text note.
  final String description;

  ExpenseCategory get category => ExpenseCategoryX.fromId(categoryId);

  Expense copyWith({
    double? amount,
    int? categoryId,
    DateTime? date,
    String? description,
  }) {
    return Expense(
      id: id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
