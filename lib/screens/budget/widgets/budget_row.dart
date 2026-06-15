import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/budget_calculator.dart';
import '../../../core/category_style.dart';
import '../../../core/money.dart';
import '../../../models/expense_category.dart';
import '../../../widgets/progress_bar.dart';

/// One category line in the budget screen: limit, spent and progress.
class BudgetRow extends StatelessWidget {
  const BudgetRow({
    super.key,
    required this.data,
    required this.currency,
    this.onTap,
  });

  final CategoryBudget data;
  final String currency;
  final VoidCallback? onTap;

  Color get _barColor {
    if (data.isOver) return AppColors.danger;
    if (data.isNearLimit) return AppColors.warning;
    return CategoryStyle.of(data.category).color;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(CategoryStyle.of(data.category).icon,
                    size: 18, color: _barColor),
                const SizedBox(width: 8),
                Text(
                  data.category.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '${Money.compact(data.spent, currency)} / ${Money.compact(data.monthlyLimit, currency)}',
                  style: TextStyle(
                    color: data.isOver
                        ? AppColors.danger
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ProgressBar(value: data.ratio, color: _barColor),
            if (data.isOver) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Dépassé de ${Money.compact(-data.remaining, currency)}',
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
