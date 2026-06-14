import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/field/field_resolver.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';
import 'package:business_card/theme_engine/runtime/field/expression_resolver.dart';

void main() {
  late FieldResolver resolver;
  late ExpressionResolver expressionResolver;
  late BusinessCardData data;

  setUp(() {
    resolver = FieldResolver();
    expressionResolver = ExpressionResolver();
    data = BusinessCardData(
      fullName: 'John Doe',
      jobTitle: 'Software Engineer',
      company: 'Acme Corp',
      email: 'john@example.com',
      phone: '123-456-7890',
      website: 'https://johndoe.com',
      address: '123 Main St',
    );
  });

  group('FieldResolver', () {
    test('containsTemplate detects template', () {
      expect(resolver.containsTemplate(r'Hello ${fullName}'), isTrue);
      expect(resolver.containsTemplate('Hello World'), isFalse);
      expect(resolver.containsTemplate(r'${name}'), isTrue);
    });

    test('extractFieldRefs extracts template names', () {
      final refs = resolver.extractFieldRefs(r'${fullName} ${jobTitle}');
      expect(refs, contains('fullName'));
      expect(refs, contains('jobTitle'));
      expect(refs.length, 2);
    });

    test('extractFieldRefs with expression', () {
      final refs = resolver.extractFieldRefs(r'${uppercase(fullName)}');
      expect(refs, contains('uppercase(fullName)'));
    });

    test('extractFieldRefs returns empty list for no templates', () {
      expect(resolver.extractFieldRefs('Hello World'), isEmpty);
    });

    test('stripTemplateSyntax removes template markers', () {
      expect(resolver.stripTemplateSyntax(r'${fullName}'), 'fullName');
      expect(
        resolver.stripTemplateSyntax(r'Hello ${fullName}!'),
        'Hello fullName!',
      );
    });

    test('resolve returns template-wrapped strings as-is without binding', () {
      expect(resolver.resolve('fullName', data), 'fullName');
    });

    test('resolve requires template syntax to resolve', () {
      // resolve() with no ${} patterns returns the string unchanged
      expect(resolver.resolve('fullName', data), 'fullName');
      expect(resolver.resolve(r'${fullName}', data), 'John Doe');
    });

    test('resolveExpression resolves expression', () {
      expect(
        resolver.resolve(r'${uppercase(fullName)}', data, expressionResolver),
        'JOHN DOE',
      );
    });

    test('resolveTemplate resolves template string', () {
      expect(
        resolver.resolve(r'Hello ${fullName}', data),
        'Hello John Doe',
      );
      expect(
        resolver.resolve(r'${fullName} - ${jobTitle} at ${company}', data),
        'John Doe - Software Engineer at Acme Corp',
      );
    });

    test('resolveTemplate with expression', () {
      expect(
        resolver.resolve(r'Contact: ${formatEmail(email)}', data, expressionResolver),
        'Contact: john@example.com',
      );
    });

    test('resolve preserves non-template text', () {
      expect(resolver.resolve('Plain text', data), 'Plain text');
    });

    test('resolve handles empty string', () {
      expect(resolver.resolve('', data), '');
    });

    test('resolve handles missing field', () {
      expect(resolver.resolve(r'${nonexistent}', data), '');
    });

    test('resolve with default expression for empty field returns fallback field', () {
      expect(
        resolver.resolve(r'${default(,company)}', data, expressionResolver),
        'Acme Corp',
      );
    });

    test('resolve multiple fields', () {
      expect(
        resolver.resolve(r'${fullName} <${email}>', data),
        'John Doe <john@example.com>',
      );
    });
  });
}
