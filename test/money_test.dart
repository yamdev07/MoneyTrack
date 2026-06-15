import 'package:flutter_test/flutter_test.dart';
import 'package:moneytrack/core/money.dart';

void main() {
  group('Money.format', () {
    test('whole numbers have no decimals', () {
      expect(Money.format(500, 'FCFA'), '500 FCFA');
    });

    test('appends the currency symbol', () {
      expect(Money.format(42, '€'), '42 €');
    });
  });

  group('Money.compact', () {
    test('shortens thousands with a k suffix', () {
      expect(Money.compact(1500, 'FCFA'), '1.5k FCFA');
    });

    test('keeps round thousands without decimals', () {
      expect(Money.compact(2000, 'FCFA'), '2k FCFA');
    });

    test('shortens millions with an M suffix', () {
      expect(Money.compact(2000000, 'FCFA'), '2.0M FCFA');
    });
  });

  group('Money.tryParse', () {
    test('parses a plain integer', () {
      expect(Money.tryParse('1500'), 1500);
    });

    test('treats comma as decimal separator and ignores spaces', () {
      expect(Money.tryParse('1 000,50'), 1000.5);
    });

    test('returns null for invalid input', () {
      expect(Money.tryParse('abc'), isNull);
      expect(Money.tryParse(''), isNull);
    });
  });
}
