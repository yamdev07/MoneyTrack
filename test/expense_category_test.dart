import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/models/expense_category.dart';

void main() {
  group('ExpenseCategory', () {
    test('fromId round-trips a valid id', () {
      expect(
        ExpenseCategoryX.fromId(ExpenseCategory.transport.id),
        ExpenseCategory.transport,
      );
    });

    test('fromId clamps out-of-range ids', () {
      expect(ExpenseCategoryX.fromId(999), ExpenseCategory.autres);
      expect(ExpenseCategoryX.fromId(-5), ExpenseCategory.nourriture);
    });

    test('every category exposes a non-empty label', () {
      for (final category in ExpenseCategory.values) {
        expect(category.label, isNotEmpty);
      }
    });
  });
}
