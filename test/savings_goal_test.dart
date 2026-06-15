import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/models/savings_goal.dart';

void main() {
  group('SavingsGoal', () {
    test('progress is the saved/target ratio, clamped to 1', () {
      final goal = SavingsGoal(label: 'PC', targetAmount: 200, savedAmount: 50);
      expect(goal.progress, 0.25);

      final over =
          SavingsGoal(label: 'PC', targetAmount: 100, savedAmount: 150);
      expect(over.progress, 1.0);
    });

    test('remaining never goes below zero', () {
      final goal =
          SavingsGoal(label: 'PC', targetAmount: 100, savedAmount: 120);
      expect(goal.remaining, 0);
    });

    test('isReached when saved meets the target', () {
      final goal =
          SavingsGoal(label: 'PC', targetAmount: 100, savedAmount: 100);
      expect(goal.isReached, isTrue);
    });

    test('progress is zero when no target is set', () {
      final goal = SavingsGoal(label: 'PC', targetAmount: 0, savedAmount: 50);
      expect(goal.progress, 0);
    });
  });
}
