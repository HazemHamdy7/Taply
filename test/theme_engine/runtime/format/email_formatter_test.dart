import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/format/email_formatter.dart';

void main() {
  group('EmailFormatter', () {
    test('format lowercases domain', () {
      final formatter = EmailFormatter();
      expect(formatter.format('John@Example.COM'), 'john@example.com');
    });

    test('format preserves local part case but lowercases', () {
      final formatter = EmailFormatter();
      expect(formatter.format('John.Doe@example.com'), 'john.doe@example.com');
    });

    test('format empty string', () {
      final formatter = EmailFormatter();
      expect(formatter.format(''), '');
    });

    test('isValid', () {
      final formatter = EmailFormatter();
      expect(formatter.isValid('test@example.com'), isTrue);
      expect(formatter.isValid('not-an-email'), isFalse);
      expect(formatter.isValid(''), isFalse);
    });

    test('mask', () {
      final formatter = EmailFormatter();
      expect(formatter.mask('john@example.com'), 'j**n@example.com');
    });

    test('mask short local part', () {
      final formatter = EmailFormatter();
      expect(formatter.mask('ab@c.com'), 'ab@c.com');
    });

    test('mask invalid email', () {
      final formatter = EmailFormatter();
      expect(formatter.mask('invalid'), 'invalid');
    });
  });
}
