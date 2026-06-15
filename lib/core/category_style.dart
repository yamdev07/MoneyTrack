import 'package:flutter/material.dart';

import '../models/expense_category.dart';

/// Visual style (icon + color) attached to each [ExpenseCategory].
class CategoryStyle {
  const CategoryStyle(this.icon, this.color);

  final IconData icon;
  final Color color;

  static CategoryStyle of(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.nourriture:
        return const CategoryStyle(Icons.restaurant, Color(0xFFE0533D));
      case ExpenseCategory.transport:
        return const CategoryStyle(Icons.directions_bus, Color(0xFF3B82F6));
      case ExpenseCategory.logement:
        return const CategoryStyle(Icons.home, Color(0xFF8B5CF6));
      case ExpenseCategory.internet:
        return const CategoryStyle(Icons.wifi, Color(0xFF06B6D4));
      case ExpenseCategory.sante:
        return const CategoryStyle(Icons.favorite, Color(0xFFEC4899));
      case ExpenseCategory.loisirs:
        return const CategoryStyle(Icons.sports_esports, Color(0xFFF59E0B));
      case ExpenseCategory.education:
        return const CategoryStyle(Icons.school, Color(0xFF6366F1));
      case ExpenseCategory.imprevus:
        return const CategoryStyle(Icons.bolt, Color(0xFFEF4444));
      case ExpenseCategory.autres:
        return const CategoryStyle(Icons.category, Color(0xFF6B7785));
    }
  }
}
