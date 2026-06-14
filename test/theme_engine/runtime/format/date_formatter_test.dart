import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/format/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('format with pattern yyyy-MM-dd', () {
      final formatter = DateFormatter();
      final date = DateTime(2023, 12, 25);
      expect(formatter.format(date, pattern: 'yyyy-MM-dd'), '2023-12-25');
    });

    test('format with pattern MM/dd/yyyy', () {
      final formatter = DateFormatter();
      final date = DateTime(2023, 12, 25);
      expect(formatter.format(date, pattern: 'MM/dd/yyyy'), '12/25/2023');
    });

    test('format with time', () {
      final formatter = DateFormatter();
      final date = DateTime(2023, 12, 25, 14, 30, 0);
      expect(
        formatter.format(date, pattern: 'yyyy-MM-dd HH:mm'),
        '2023-12-25 14:30',
      );
    });

    test('relative returns just now for current time', () {
      final formatter = DateFormatter();
      final result = formatter.relative(DateTime.now());
      expect(result, 'just now');
    });

    test('relative returns days ago', () {
      final formatter = DateFormatter();
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final result = formatter.relative(twoDaysAgo);
      expect(result, '2 days ago');
    });

    test('relative returns 1 day ago', () {
      final formatter = DateFormatter();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final result = formatter.relative(yesterday);
      expect(result, '1 day ago');
    });

    test('relative returns hours ago', () {
      final formatter = DateFormatter();
      final threeHoursAgo = DateTime.now().subtract(const Duration(hours: 3));
      final result = formatter.relative(threeHoursAgo);
      expect(result, '3 hours ago');
    });

    test('relative returns minutes ago', () {
      final formatter = DateFormatter();
      final fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
      final result = formatter.relative(fiveMinAgo);
      expect(result, '5 minutes ago');
    });
  });
}
