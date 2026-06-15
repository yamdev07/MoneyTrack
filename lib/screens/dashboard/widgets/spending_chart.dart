import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/category_style.dart';
import '../../../core/money.dart';
import '../../../models/expense_category.dart';

/// Donut chart breaking down spending by category for the month.
class SpendingChart extends StatelessWidget {
  const SpendingChart({
    super.key,
    required this.byCategory,
    required this.currency,
  });

  /// categoryId -> amount spent.
  final Map<int, double> byCategory;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final total = byCategory.values.fold(0.0, (s, v) => s + v);
    if (total <= 0) {
      return const SizedBox.shrink();
    }

    final entries = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Row(
      children: [
        SizedBox(
          height: 140,
          width: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 44,
                  sections: entries.map((e) {
                    final category = ExpenseCategoryX.fromId(e.key);
                    return PieChartSectionData(
                      value: e.value,
                      color: CategoryStyle.of(category).color,
                      radius: 18,
                      showTitle: false,
                    );
                  }).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text(
                    Money.compact(total, currency),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.take(5).map((e) {
              final category = ExpenseCategoryX.fromId(e.key);
              final pct = (e.value / total * 100).round();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: CategoryStyle.of(category).color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.label,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('$pct%',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
