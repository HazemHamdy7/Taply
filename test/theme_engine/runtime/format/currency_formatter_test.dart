import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/format/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('format USD', () {
      final formatter = CurrencyFormatter();
      expect(formatter.format(1234.56, currency: 'USD'), '\$1,234.56');
    });

    test('format EUR', () {
      final formatter = CurrencyFormatter();
      expect(formatter.format(1234.56, currency: 'EUR'), '€1,234.56');
    });

    test('formatWithCode USD', () {
      final formatter = CurrencyFormatter();
      expect(
        formatter.formatWithCode(1234.56, currency: 'USD'),
        '\$1,234.56 USD',
      );
    });

    test('format zero', () {
      final formatter = CurrencyFormatter();
      expect(formatter.format(0, currency: 'USD'), '\$0.00');
    });

    test('format negative', () {
      final formatter = CurrencyFormatter();
      final result = formatter.format(-50.5, currency: 'USD');
      expect(result, contains('\$50'));
      expect(result, contains('-'));
    });
  });
}
