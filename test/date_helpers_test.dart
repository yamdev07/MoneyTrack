import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/core/date_helpers.dart';

void main() {
  group('DateHelpers', () {
    test('startOfWeek returns the Monday of the week', () {
      // 2024-06-12 is a Wednesday.
      final monday = DateHelpers.startOfWeek(DateTime(2024, 6, 12));
      expect(monday, DateTime(2024, 6, 10));
    });

    test('isSameDay ignores the time component', () {
      expect(
        DateHelpers.isSameDay(
          DateTime(2024, 6, 12, 9),
          DateTime(2024, 6, 12, 23),
        ),
        isTrue,
      );
    });

    test('isSameMonth compares year and month', () {
      expect(
        DateHelpers.isSameMonth(DateTime(2024, 6, 1), DateTime(2024, 6, 30)),
        isTrue,
      );
      expect(
        DateHelpers.isSameMonth(DateTime(2024, 6, 1), DateTime(2024, 7, 1)),
        isFalse,
      );
    });

    test('startOfMonth zeroes the day', () {
      expect(DateHelpers.startOfMonth(DateTime(2024, 6, 18)), DateTime(2024, 6));
    });
  });
}
