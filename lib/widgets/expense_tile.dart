import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/date_helpers.dart';
import '../core/money.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import 'category_avatar.dart';

/// A single expense row used in history and dashboard lists.
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    required this.currency,
    this.onTap,
  });

  final Expense expense;
  final String currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = expense.description.isNotEmpty
        ? expense.description
        : DateHelpers.formatDay(expense.date);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: CategoryAvatar(category: expense.category),
      title: Text(
        expense.category.label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: Text(
        '- ${Money.format(expense.amount, currency)}',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.expense,
        ),
      ),
    );
  }
}
