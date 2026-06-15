import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/budget_calculator.dart';
import '../../core/money.dart';
import '../../models/expense_category.dart';
import '../../state/budget_controller.dart';
import '../../state/expense_controller.dart';
import '../../state/profile_controller.dart';
import '../../widgets/amount_input_dialog.dart';
import '../../widgets/progress_bar.dart';
import '../../widgets/section_title.dart';
import 'widgets/budget_row.dart';

/// Budget screen: répartition par catégorie + budget hebdomadaire (cahier §3.1/§3.2).
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  Future<void> _editPercent(
    BuildContext context,
    ExpenseCategory category,
    double current,
  ) async {
    var value = current;
    final result = await showDialog<double>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(category.label),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${value.round()} % du salaire',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Slider(
                    value: value,
                    max: 100,
                    divisions: 100,
                    label: '${value.round()}%',
                    onChanged: (v) => setState(() => value = v),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, value),
                  child: const Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && context.mounted) {
      await context.read<BudgetController>().setPercent(category, result);
    }
  }

  Future<void> _editWeeklyBudget(BuildContext context) async {
    final controller = context.read<BudgetController>();
    final currency = context.read<ProfileController>().currency;
    final amount = await AmountInputDialog.show(
      context,
      title: 'Budget alloué par semaine',
      currency: currency,
      confirmLabel: 'Définir',
      initialValue: controller.budget.weeklyBudget,
    );
    if (amount != null) await controller.setWeeklyBudget(amount);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileController>();
    final expenses = context.watch<ExpenseController>();
    final budget = context.watch<BudgetController>().budget;

    final currency = profile.currency;
    final calc = BudgetCalculator(
      salary: profile.salary,
      budget: budget,
      spentByCategory: expenses.monthByCategory(),
    );
    final rows = calc.categories();
    final weeklySpent = expenses.weekTotal;
    final weeklyRatio =
        calc.weeklyBudgetTotal > 0 ? weeklySpent / calc.weeklyBudgetTotal : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _WeeklyCard(
                  budget: calc.weeklyBudgetTotal,
                  spent: weeklySpent,
                  ratio: weeklyRatio,
                  currency: currency,
                  isManual: budget.hasManualWeeklyBudget,
                  onEdit: () => _editWeeklyBudget(context),
                ),
                const SizedBox(height: 20),
                if (!profile.hasSalary)
                  const _NoSalaryHint()
                else ...[
                  SectionTitle(
                    'Par catégorie',
                    action: Text(
                      'Épargne ${budget.savingsPercent.round()}%',
                      style: const TextStyle(
                        color: AppColors.savings,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...rows.map(
                    (r) => BudgetRow(
                      data: r,
                      currency: currency,
                      onTap: () => _editPercent(
                        context,
                        r.category,
                        budget.percentFor(r.category),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                const Text(
                  'Astuce : touche une catégorie pour ajuster son pourcentage.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
    );
  }
}

class _WeeklyCard extends StatelessWidget {
  const _WeeklyCard({
    required this.budget,
    required this.spent,
    required this.ratio,
    required this.currency,
    required this.isManual,
    required this.onEdit,
  });

  final double budget;
  final double spent;
  final double ratio;
  final String currency;
  final bool isManual;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final over = spent > budget && budget > 0;
    final remaining = budget - spent;
    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Budget de la semaine',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isManual ? AppColors.primary : AppColors.savings)
                          .withAlpha(28),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isManual ? 'alloué' : 'auto',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isManual ? AppColors.primary : AppColors.savings,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.edit_outlined,
                      size: 18, color: AppColors.textSecondary),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                Money.format(budget, currency),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ProgressBar(
                value: ratio,
                color: over ? AppColors.danger : AppColors.primary,
              ),
              const SizedBox(height: 6),
              Text(
                over
                    ? 'Dépassé de ${Money.format(-remaining, currency)}'
                    : 'Dépensé ${Money.format(spent, currency)} · reste ${Money.format(remaining, currency)}',
                style: TextStyle(
                  color: over ? AppColors.danger : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoSalaryHint extends StatelessWidget {
  const _NoSalaryHint();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Ajoute ton salaire (onglet Accueil) pour répartir le budget par '
          'catégorie. Le budget hebdomadaire ci-dessus, lui, fonctionne même '
          'sans salaire.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
