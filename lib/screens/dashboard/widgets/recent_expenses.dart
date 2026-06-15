import 'package:flutter/material.dart';

import '../../../models/expense.dart';
import '../../../widgets/expense_tile.dart';

/// Shows the latest few expenses on the dashboard.
class RecentExpenses extends StatelessWidget {
  const RecentExpenses({
    super.key,
    required this.expenses,
    required this.currency,
  });

  final List<Expense> expenses;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final recent = expenses.take(5).toList();
    return Column(
      children: recent
          .map((e) => ExpenseTile(expense: e, currency: currency))
          .toList(),
    );
  }
}
