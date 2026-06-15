import 'package:hive/hive.dart';

import 'expense_category.dart';

/// What to do with the money left unspent at the end of a week.
enum WeeklySurplusMode {
  /// Keep a fixed weekly budget; the surplus is just ignored.
  none,

  /// Carry the surplus (or deficit) over to the next week's allowance.
  rollover,

  /// Make the surplus available to transfer into the savings goal.
  savings,
}

/// Monthly budget split across categories, expressed as percentages of salary.
///
/// Percentages are stored per [ExpenseCategory.id]. They do not have to sum to
/// 100 — the remainder is treated as un-allocated / free money.
class Budget extends HiveObject {
  Budget({
    required this.percentages,
    this.savingsPercent = 10,
    this.weeklyBudget = 0,
    this.surplusMode = WeeklySurplusMode.none,
    this.lastSweepWeekStart,
  });

  /// categoryId -> percentage of salary (0..100).
  final Map<int, double> percentages;

  /// Percentage of salary automatically earmarked for savings.
  final double savingsPercent;

  /// Manual weekly spending allowance set by the user.
  ///
  /// `0` means "automatic": the weekly budget is derived from the monthly
  /// allocation. Any value `> 0` overrides that and is used as-is.
  final double weeklyBudget;

  /// User's choice for the weekly leftover (report vs savings vs nothing).
  final WeeklySurplusMode surplusMode;

  /// Monday of the last week already swept into savings (savings mode only).
  /// Surplus before this date has been moved out and must not be counted again.
  final DateTime? lastSweepWeekStart;

  bool get hasManualWeeklyBudget => weeklyBudget > 0;
  bool get isRollover => surplusMode == WeeklySurplusMode.rollover;
  bool get isSavingsMode => surplusMode == WeeklySurplusMode.savings;

  double percentFor(ExpenseCategory category) => percentages[category.id] ?? 0;

  /// Total percentage allocated to spending categories (excludes savings).
  double get totalAllocatedPercent =>
      percentages.values.fold(0.0, (sum, value) => sum + value);

  Budget copyWith({
    Map<int, double>? percentages,
    double? savingsPercent,
    double? weeklyBudget,
    WeeklySurplusMode? surplusMode,
    DateTime? lastSweepWeekStart,
  }) {
    return Budget(
      percentages: percentages ?? Map<int, double>.from(this.percentages),
      savingsPercent: savingsPercent ?? this.savingsPercent,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      surplusMode: surplusMode ?? this.surplusMode,
      lastSweepWeekStart: lastSweepWeekStart ?? this.lastSweepWeekStart,
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
