import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/money.dart';
import '../../state/profile_controller.dart';
import '../../state/savings_controller.dart';
import '../../widgets/amount_input_dialog.dart';
import '../../widgets/section_title.dart';
import 'widgets/savings_progress_card.dart';

/// Savings screen: objectif d'épargne + suivi du montant (cahier §3.4).
class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  Future<void> _deposit(BuildContext context, {required bool withdraw}) async {
    final savings = context.read<SavingsController>();
    final currency = context.read<ProfileController>().currency;
    final amount = await AmountInputDialog.show(
      context,
      title: withdraw ? 'Retirer de l\'épargne' : 'Ajouter à l\'épargne',
      currency: currency,
      confirmLabel: withdraw ? 'Retirer' : 'Ajouter',
    );
    if (amount == null) return;
    if (withdraw) {
      await savings.withdraw(amount);
    } else {
      await savings.deposit(amount);
    }
  }

  Future<void> _editGoal(BuildContext context) async {
    final savings = context.read<SavingsController>();
    final currency = context.read<ProfileController>().currency;
    final labelController = TextEditingController(text: savings.goal.label);
    final amount = await showDialog<_GoalResult>(
      context: context,
      builder: (context) {
        final targetController = TextEditingController(
          text: savings.goal.targetAmount > 0
              ? savings.goal.targetAmount.toStringAsFixed(0)
              : '',
        );
        return AlertDialog(
          title: const Text('Objectif d\'épargne'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Nom de l\'objectif'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Montant cible',
                  suffixText: currency,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                _GoalResult(
                  labelController.text.trim(),
                  Money.tryParse(targetController.text) ?? 0,
                ),
              ),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
    if (amount != null) {
      await savings.setGoal(
        label: amount.label.isEmpty ? 'Mon épargne' : amount.label,
        target: amount.target,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final savings = context.watch<SavingsController>();
    final currency = context.watch<ProfileController>().currency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Épargne'),
        actions: [
          IconButton(
            tooltip: 'Modifier l\'objectif',
            onPressed: () => _editGoal(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SavingsProgressCard(goal: savings.goal, currency: currency),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _deposit(context, withdraw: false),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _deposit(context, withdraw: true),
                  icon: const Icon(Icons.remove),
                  label: const Text('Retirer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('Comment ça marche'),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Définis un objectif (ex. ordinateur), puis ajoute de l\'argent '
                'chaque fois que tu épargnes. La barre te montre ta progression.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalResult {
  const _GoalResult(this.label, this.target);
  final String label;
  final double target;
}
