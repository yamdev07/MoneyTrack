import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/date_helpers.dart';
import '../../models/expense.dart';
import '../../state/expense_controller.dart';
import '../../state/profile_controller.dart';
import '../../widgets/empty_state.dart';
import 'widgets/day_group.dart';

/// Full chronological history of expenses, grouped by day (cahier §3.3).
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  /// Groups expenses by calendar day, preserving recent-first order.
  Map<DateTime, List<Expense>> _groupByDay(List<Expense> expenses) {
    final groups = <DateTime, List<Expense>>{};
    for (final e in expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      groups.putIfAbsent(day, () => []).add(e);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseController>();
    final currency = context.watch<ProfileController>().currency;
    final groups = _groupByDay(expenses.all);
    final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: days.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Aucune dépense enregistrée',
              message: 'Tes dépenses apparaîtront ici',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return DayGroup(
                  day: day,
                  expenses: groups[day]!,
                  currency: currency,
                  onDelete: (e) {
                    expenses.delete(e.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Dépense du ${DateHelpers.formatDayShort(e.date)} supprimée',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
