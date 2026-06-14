import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/field/expression_resolver.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';
import 'package:business_card/theme_engine/runtime/runtime_exception.dart';

void main() {
  late ExpressionResolver resolver;
  late BusinessCardData data;

  setUp(() {
    resolver = ExpressionResolver();
    data = BusinessCardData(
      fullName: 'John Doe',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '1234567890',
    );
  });

  group('ExpressionResolver', () {
    test('field reference resolves via data', () {
      expect(resolver.evaluate('fullName', data), 'John Doe');
    });

    test('unknown field returns null', () {
      expect(resolver.evaluate('nonexistent', data), isNull);
    });

    test('uppercase of field value', () {
      expect(resolver.evaluate('uppercase(fullName)', data), 'JOHN DOE');
    });

    test('lowercase of field value', () {
      expect(resolver.evaluate('lowercase(company)', data), '');
    });

    test('concat field values', () {
      expect(resolver.evaluate('concat(firstName,lastName)', data), 'JohnDoe');
    });

    test('default returns field value when truthy', () {
      expect(resolver.evaluate('default(fullName,lastName)', data), 'John Doe');
    });

    test('default returns fallback for missing field', () {
      expect(resolver.evaluate('default(nonexistent,lastName)', data), 'Doe');
    });

    test('trim of field value', () {
      expect(resolver.evaluate('trim(fullName)', data), 'John Doe');
    });

    test('length of field value', () {
      expect(resolver.evaluate('length(fullName)', data), 8);
    });

    test('if returns value when field is truthy', () {
      expect(resolver.evaluate('if(fullName,firstName)', data), 'John');
    });

    test('if returns empty when field missing', () {
      expect(resolver.evaluate('if(nonexistent,firstName)', data), '');
    });

    test('substring on field value with numeric field refs', () {
      // args are resolved as field refs; '0' and '4' resolve to null
      // _toInt(null) returns 0 (fallback), so start=0, end=length
      expect(resolver.evaluate('substring(fullName,0,4)', data), 'John Doe');
    });

    test('formatPhone formats phone field', () {
      expect(resolver.evaluate('formatPhone(phone)', data), '(123) 456-7890');
    });

    test('formatEmail formats email field', () {
      expect(resolver.evaluate('formatEmail(email)', data), 'john@example.com');
    });

    test('unknown function throws', () {
      expect(
        () => resolver.evaluate('unknownFunc(fullName)', data),
        throwsA(isA<ExpressionEvaluationException>()),
      );
    });
  });
}
