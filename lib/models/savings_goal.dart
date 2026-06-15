import 'package:hive/hive.dart';

/// A savings objective the user works toward (cahier de charge §3.4).
class SavingsGoal extends HiveObject {
  SavingsGoal({
    required this.label,
    required this.targetAmount,
    this.savedAmount = 0,
    this.deadline,
  });

  /// What the user is saving for (e.g. "Ordinateur").
  String label;

  /// Amount the user wants to reach.
  double targetAmount;

  /// Amount saved so far.
  double savedAmount;

  /// Optional target date.
  DateTime? deadline;

  /// Progress ratio in the 0..1 range.
  double get progress {
    if (targetAmount <= 0) return 0;
    return (savedAmount / targetAmount).clamp(0.0, 1.0);
  }

  double get remaining => (targetAmount - savedAmount).clamp(0, double.infinity);

  bool get isReached => savedAmount >= targetAmount && targetAmount > 0;

  SavingsGoal copyWith({
    String? label,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
  }) {
    return SavingsGoal(
      label: label ?? this.label,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: deadline ?? this.deadline,
    );
  }

  static SavingsGoal empty() => SavingsGoal(label: 'Mon épargne', targetAmount: 0);
}
