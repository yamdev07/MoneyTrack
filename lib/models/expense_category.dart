/// Spending categories used across budgets, expenses and the dashboard.
///
/// The order is stable: the [index] is what gets persisted, so never reorder
/// existing values — only append new ones at the end.
enum ExpenseCategory {
  nourriture,
  transport,
  logement,
  internet,
  sante,
  loisirs,
  education,
  imprevus,
  autres,
}

extension ExpenseCategoryX on ExpenseCategory {
  /// Human readable French label shown in the UI.
  String get label {
    switch (this) {
      case ExpenseCategory.nourriture:
        return 'Nourriture';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.logement:
        return 'Logement';
      case ExpenseCategory.internet:
        return 'Internet';
      case ExpenseCategory.sante:
        return 'Santé';
      case ExpenseCategory.loisirs:
        return 'Loisirs';
      case ExpenseCategory.education:
        return 'Éducation';
      case ExpenseCategory.imprevus:
        return 'Imprévus';
      case ExpenseCategory.autres:
        return 'Autres';
    }
  }

  /// Stable key persisted in Hive.
  int get id => index;

  static ExpenseCategory fromId(int id) =>
      ExpenseCategory.values[id.clamp(0, ExpenseCategory.values.length - 1)];
}
