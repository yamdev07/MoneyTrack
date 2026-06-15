import 'package:hive/hive.dart';

import 'expense_category.dart';

/// Monthly budget split across categories, expressed as percentages of salary.
///
/// Percentages are stored per [ExpenseCategory.id]. They do not have to sum to
/// 100 — the remainder is treated as un-allocated / free money.
class Budget extends HiveObject {
  Budget({required this.percentages, this.savingsPercent = 10});

  /// categoryId -> percentage of salary (0..100).
  final Map<int, double> percentages;

  /// Percentage of salary automatically earmarked for savings.
  final double savingsPercent;

  double percentFor(ExpenseCategory category) =>
      percentages[category.id] ?? 0;

  /// Total percentage allocated to spending categories (excludes savings).
  double get totalAllocatedPercent =>
      percentages.values.fold(0.0, (sum, value) => sum + value);

  Budget copyWith({Map<int, double>? percentages, double? savingsPercent}) {
    return Budget(
      percentages: percentages ?? Map<int, double>.from(this.percentages),
      savingsPercent: savingsPercent ?? this.savingsPercent,
    );
  }

  /// Sensible starting allocation for a young salaried user.
  static Budget defaults() {
    return Budget(
      percentages: {
        ExpenseCategory.nourriture.id: 30,
        ExpenseCategory.transport.id: 10,
        ExpenseCategory.logement.id: 25,
        ExpenseCategory.internet.id: 5,
        ExpenseCategory.sante.id: 5,
        ExpenseCategory.loisirs.id: 5,
        ExpenseCategory.imprevus.id: 5,
      },
      savingsPercent: 15,
    );
  }
}
