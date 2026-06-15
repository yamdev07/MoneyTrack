import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/money.dart';
import '../../../models/savings_goal.dart';
import '../../../widgets/progress_bar.dart';

/// Visual summary of the savings goal: saved vs target with progress.
class SavingsProgressCard extends StatelessWidget {
  const SavingsProgressCard({
    super.key,
    required this.goal,
    required this.currency,
  });

  final SavingsGoal goal;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final percent = (goal.progress * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.savings, Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            Money.format(goal.savedAmount, currency),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (goal.targetAmount > 0) ...[
            const SizedBox(height: 4),
            Text(
              'sur ${Money.format(goal.targetAmount, currency)} ($percent%)',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            ProgressBar(value: goal.progress, color: Colors.white, height: 8),
            const SizedBox(height: 8),
            Text(
              goal.isReached
                  ? '🎉 Objectif atteint !'
                  : 'Encore ${Money.format(goal.remaining, currency)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
