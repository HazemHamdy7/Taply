import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/runtime_cache.dart';

void main() {
  group('RuntimeCache', () {
    test('set and get stores and retrieves values', () {
      final cache = RuntimeCache();
      cache.set('name', 'John');
      expect(cache.get('name'), 'John');
    });

    test('get returns null for missing key', () {
      final cache = RuntimeCache();
      expect(cache.get('missing'), isNull);
    });

    test('remove deletes value', () {
      final cache = RuntimeCache();
      cache.set('key', 'value');
      cache.remove('key');
      expect(cache.get('key'), isNull);
    });

    test('invalidateAll clears cache', () {
      final cache = RuntimeCache();
      cache.set('a', '1');
      cache.set('b', '2');
      cache.invalidateAll();
      expect(cache.get('a'), isNull);
      expect(cache.get('b'), isNull);
    });

    test('set overrides existing key', () {
      final cache = RuntimeCache();
      cache.set('key', 'old');
      cache.set('key', 'new');
      expect(cache.get('key'), 'new');
    });
  });
}
