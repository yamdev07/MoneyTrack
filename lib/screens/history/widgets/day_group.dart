import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/date_helpers.dart';
import '../../../core/money.dart';
import '../../../data/expense_repository.dart';
import '../../../models/expense.dart';
import '../../../widgets/expense_tile.dart';

/// A dated group of expenses with the day's total, used in history.
class DayGroup extends StatelessWidget {
  const DayGroup({
    super.key,
    required this.day,
    required this.expenses,
    required this.currency,
    required this.onDelete,
  });

  final DateTime day;
  final List<Expense> expenses;
  final String currency;
  final ValueChanged<Expense> onDelete;

  @override
  Widget build(BuildContext context) {
    final total = ExpenseRepository.total(expenses);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateHelpers.formatDay(day),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                Money.format(total, currency),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        ...expenses.map(
          (e) => Dismissible(
            key: ValueKey(e.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => onDelete(e),
            child: ExpenseTile(expense: e, currency: currency),
          ),
        ),
      ],
    );
  }
}
