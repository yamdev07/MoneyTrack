import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/money.dart';

/// Hero card showing the remaining spendable balance for the month.
class BalanceHeader extends StatelessWidget {
  const BalanceHeader({
    super.key,
    required this.remaining,
    required this.salary,
    required this.spent,
    required this.currency,
  });

  final double remaining;
  final double salary;
  final double spent;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final isNegative = remaining < 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reste à dépenser ce mois',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            Money.format(remaining, currency),
            style: TextStyle(
              color: isNegative ? const Color(0xFFFFD2C9) : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniStat(label: 'Salaire', value: Money.compact(salary, currency)),
              const SizedBox(width: 24),
              _MiniStat(label: 'Dépensé', value: Money.compact(spent, currency)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
