import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/format/phone_formatter.dart';

void main() {
  group('PhoneFormatter', () {
    test('format US number', () {
      final formatter = PhoneFormatter();
      expect(formatter.format('1234567890', locale: 'en'), '(123) 456-7890');
    });

    test('format US number with country code', () {
      final formatter = PhoneFormatter();
      expect(
        formatter.format('+11234567890', locale: 'en'),
        '+1 (123) 456-7890',
      );
    });

    test('format FR number', () {
      final formatter = PhoneFormatter();
      expect(
        formatter.format('0123456789', locale: 'fr'),
        '+33 01 23 45 67 89',
      );
    });

    test('format DE number', () {
      final formatter = PhoneFormatter();
      expect(
        formatter.format('030123456', locale: 'de'),
        '+49 03 012 3456',
      );
    });

    test('format international fallback', () {
      final formatter = PhoneFormatter();
      final result = formatter.format('+441234567890', locale: 'xx');
      expect(result, contains('+44'));
      expect(result, contains('441'));
    });

    test('format empty string returns empty', () {
      final formatter = PhoneFormatter();
      expect(formatter.format(''), '');
    });
  });
}
