/// Centralized constant values: app metadata and Hive box names.
class AppConstants {
  AppConstants._();

  static const String appName = 'MoneyTrack';
  static const String appTagline = 'Gère ton salaire, maîtrise tes dépenses';

  // Hive box names.
  static const String profileBox = 'profile_box';
  static const String expenseBox = 'expense_box';
  static const String budgetBox = 'budget_box';
  static const String savingsBox = 'savings_box';

  // Well-known keys for single-record boxes.
  static const String profileKey = 'me';
  static const String budgetKey = 'current';
  static const String savingsKey = 'main';

  /// Average number of weeks in a month, used for weekly budget splitting.
  static const double weeksPerMonth = 4.345;

  /// Currencies offered in settings.
  static const List<String> currencies = [
    'FCFA',
    '€',
    '\$',
    'CHF',
    'MAD',
    'DH'
  ];
}
