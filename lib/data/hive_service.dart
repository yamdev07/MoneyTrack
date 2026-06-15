import 'package:hive_flutter/hive_flutter.dart';

import '../core/app_constants.dart';
import '../models/budget.dart';
import '../models/budget_adapter.dart';
import '../models/expense.dart';
import '../models/expense_adapter.dart';
import '../models/savings_goal.dart';
import '../models/savings_goal_adapter.dart';
import '../models/user_profile.dart';
import '../models/user_profile_adapter.dart';

/// Initializes Hive, registers adapters and opens the typed boxes.
class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapter(ExpenseAdapter());
    _registerAdapter(UserProfileAdapter());
    _registerAdapter(BudgetAdapter());
    _registerAdapter(SavingsGoalAdapter());

    await Hive.openBox<Expense>(AppConstants.expenseBox);
    await Hive.openBox<UserProfile>(AppConstants.profileBox);
    await Hive.openBox<Budget>(AppConstants.budgetBox);
    await Hive.openBox<SavingsGoal>(AppConstants.savingsBox);
  }

  static void _registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}
