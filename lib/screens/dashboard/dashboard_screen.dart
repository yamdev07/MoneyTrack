import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/alerts.dart';
import '../../core/app_colors.dart';
import '../../core/budget_calculator.dart';
import '../../core/money.dart';
import '../../state/budget_controller.dart';
import '../../state/expense_controller.dart';
import '../../state/profile_controller.dart';
import '../../state/savings_controller.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/amount_input_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_title.dart';
import '../../widgets/summary_card.dart';
import 'widgets/balance_header.dart';
import 'widgets/recent_expenses.dart';
import 'widgets/spending_chart.dart';

/// Home dashboard: salaire total, dépenses, reste, épargne (cahier §3.5).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _promptSalary(BuildContext context) async {
    final profile = context.read<ProfileController>();
    final value = await AmountInputDialog.show(
      context,
      title: 'Ton salaire mensuel',
      currency: profile.currency,
      initialValue: profile.salary,
    );
    if (value != null) await profile.setSalary(value);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileController>();
    final expenses = context.watch<ExpenseController>();
    final savings = context.watch<SavingsController>();
    final budget = context.watch<BudgetController>().budget;

    final currency = profile.currency;
    final salary = profile.salary;
    final spent = expenses.monthTotal;
    final remaining = salary - spent;
    final saved = savings.saved;

    final calc = BudgetCalculator(
      salary: salary,
      budget: budget,
      spentByCategory: expenses.monthByCategory(),
    );
    final alerts = profile.hasSalary
        ? AlertService.build(
            calc: calc,
            weeklySpent: expenses.weekTotal,
            currency: currency,
          )
        : const <BudgetAlert>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyTrack'),
        actions: [
          IconButton(
            tooltip: 'Modifier le salaire',
            onPressed: () => _promptSalary(context),
            icon: const Icon(Icons.account_balance_wallet_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          ...alerts.map((a) => AlertBanner(alert: a)),
          if (!profile.hasSalary)
            _SalaryCta(onTap: () => _promptSalary(context))
          else
            BalanceHeader(
              remaining: remaining,
              salary: salary,
              spent: spent,
              currency: currency,
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  label: 'Dépenses',
                  value: Money.compact(spent, currency),
                  icon: Icons.shopping_bag_outlined,
                  color: AppColors.expense,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  label: 'Reste',
                  value: Money.compact(remaining, currency),
                  icon: Icons.savings_outlined,
                  color: remaining < 0 ? AppColors.danger : AppColors.income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  label: 'Épargne',
                  value: Money.compact(saved, currency),
                  icon: Icons.flag_outlined,
                  color: AppColors.savings,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('Répartition des dépenses'),
          const SizedBox(height: 12),
          if (expenses.monthTotal > 0)
            SpendingChart(
              byCategory: expenses.monthByCategory(),
              currency: currency,
            )
          else
            const EmptyState(
              icon: Icons.pie_chart_outline,
              title: 'Pas encore de dépenses ce mois',
              message: 'Ajoute ta première dépense avec le bouton +',
            ),
          const SizedBox(height: 24),
          const SectionTitle('Dépenses récentes'),
          const SizedBox(height: 4),
          RecentExpenses(expenses: expenses.all, currency: currency),
        ],
      ),
    );
  }
}

class _SalaryCta extends StatelessWidget {
  const _SalaryCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading:
            const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
        title: const Text('Ajoute ton salaire mensuel'),
        subtitle: const Text('Pour calculer ton budget et ton reste'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
