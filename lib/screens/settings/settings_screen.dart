import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../core/money.dart';
import '../../state/budget_controller.dart';
import '../../state/expense_controller.dart';
import '../../state/profile_controller.dart';
import '../../widgets/amount_input_dialog.dart';
import '../../widgets/section_title.dart';

/// App settings: salaire, devise, réinitialisation (cahier §4 "Paramètres").
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _editSalary(BuildContext context) async {
    final profile = context.read<ProfileController>();
    final value = await AmountInputDialog.show(
      context,
      title: 'Salaire mensuel',
      currency: profile.currency,
      initialValue: profile.salary,
    );
    if (value != null) await profile.setSalary(value);
  }

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les dépenses ?'),
        content: const Text(
          'Toutes les dépenses enregistrées seront définitivement supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ExpenseController>().clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const SectionTitle('Compte'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payments_outlined,
                      color: AppColors.primary),
                  title: const Text('Salaire mensuel'),
                  subtitle: Text(Money.format(profile.salary, profile.currency)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editSalary(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.currency_exchange,
                      color: AppColors.primary),
                  title: const Text('Devise'),
                  trailing: DropdownButton<String>(
                    value: AppConstants.currencies.contains(profile.currency)
                        ? profile.currency
                        : AppConstants.currencies.first,
                    underline: const SizedBox.shrink(),
                    items: AppConstants.currencies
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) profile.setCurrency(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Données'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restart_alt,
                      color: AppColors.warning),
                  title: const Text('Réinitialiser le budget'),
                  subtitle: const Text('Revenir à la répartition par défaut'),
                  onTap: () => context.read<BudgetController>().resetToDefaults(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline,
                      color: AppColors.danger),
                  title: const Text('Effacer toutes les dépenses'),
                  onTap: () => _confirmClear(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('À propos'),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.primary),
              title: Text(AppConstants.appName),
              subtitle: Text('${AppConstants.appTagline}\nVersion 1.0.0'),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}
