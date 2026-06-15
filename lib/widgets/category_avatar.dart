import 'package:flutter/material.dart';

import '../core/category_style.dart';
import '../models/expense_category.dart';

/// Round colored icon representing an [ExpenseCategory].
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.category, this.size = 44});

  final ExpenseCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(category);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.color.withAlpha(36),
        shape: BoxShape.circle,
      ),
      child: Icon(style.icon, color: style.color, size: size * 0.5),
    );
  }
}
