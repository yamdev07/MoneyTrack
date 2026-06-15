import 'budget_calculator.dart';
import 'money.dart';
import '../models/expense_category.dart';

/// Severity levels for a budget alert.
enum AlertSeverity { info, warning, danger }

/// A single alert message surfaced to the user (cahier §3.6).
class BudgetAlert {
  const BudgetAlert(this.message, this.severity);

  final String message;
  final AlertSeverity severity;
}

/// Derives budget alerts from the current spending state.
class AlertService {
  const AlertService._();

  /// Builds the list of alerts to show on the dashboard.
  static List<BudgetAlert> build({
    required BudgetCalculator calc,
    required double weeklySpent,
    required String currency,
  }) {
    final alerts = <BudgetAlert>[];

    // 1. Per-category overruns (dépassement budget).
    for (final cat in calc.overspentCategories) {
      alerts.add(BudgetAlert(
        '${cat.category.label} : budget dépassé de '
        '${Money.compact(-cat.remaining, currency)}',
        AlertSeverity.danger,
      ));
    }

    // 2. Categories close to their limit.
    final nearLimit = calc
        .categories()
        .where((c) => c.isNearLimit)
        .map((c) => c.category.label)
        .toList();
    if (nearLimit.isNotEmpty) {
      alerts.add(BudgetAlert(
        'Bientôt à la limite : ${nearLimit.join(', ')}',
        AlertSeverity.warning,
      ));
    }

    // 3. Weekly budget overrun (fin de semaine bilan).
    if (calc.weeklyBudgetTotal > 0 && weeklySpent > calc.weeklyBudgetTotal) {
      alerts.add(BudgetAlert(
        'Tu as dépassé ton budget hebdomadaire '
        '(${Money.compact(weeklySpent, currency)} / '
        '${Money.compact(calc.weeklyBudgetTotal, currency)})',
        AlertSeverity.warning,
      ));
    }

    return alerts;
  }
}
