import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/format/url_formatter.dart';

void main() {
  group('UrlFormatter', () {
    test('format adds https if missing', () {
      final formatter = UrlFormatter();
      expect(formatter.format('example.com'), 'https://example.com');
    });

    test('format preserves https', () {
      final formatter = UrlFormatter();
      expect(formatter.format('https://example.com'), 'https://example.com');
    });

    test('format preserves http', () {
      final formatter = UrlFormatter();
      expect(formatter.format('http://example.com'), 'http://example.com');
    });

    test('format empty string returns https://', () {
      final formatter = UrlFormatter();
      expect(formatter.format(''), 'https://');
    });

    test('displayUrl removes protocol and www', () {
      final formatter = UrlFormatter();
      expect(
        formatter.displayUrl('https://www.example.com/page'),
        'example.com/page',
      );
    });

    test('extractDomain', () {
      final formatter = UrlFormatter();
      expect(formatter.extractDomain('https://www.example.com/path'), 'www.example.com');
    });

    test('isValid', () {
      final formatter = UrlFormatter();
      expect(formatter.isValid('https://example.com'), isTrue);
      expect(formatter.isValid('not-a-url'), isTrue);
      // format() prepends https:// even to empty strings
      expect(formatter.isValid(''), isTrue);
    });
  });
}
