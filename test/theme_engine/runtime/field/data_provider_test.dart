import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';

void main() {
  group('BusinessCardData', () {
    test('default constructor sets null values', () {
      final data = BusinessCardData();
      expect(data.fullName, isNull);
      expect(data.email, isNull);
    });

    test('constructor sets values', () {
      final data = BusinessCardData(
        fullName: 'John Doe',
        email: 'john@example.com',
      );
      expect(data.fullName, 'John Doe');
      expect(data.email, 'john@example.com');
    });

    test('merge combines two datasets', () {
      final a = BusinessCardData(fullName: 'John', email: 'john@example.com');
      final b = BusinessCardData(fullName: 'Jane', phone: '555-0100');
      final merged = a.merge(b);
      expect(merged.fullName, 'Jane');
      expect(merged.email, 'john@example.com');
      expect(merged.phone, '555-0100');
    });

    test('resolve returns direct field by name', () {
      final data = BusinessCardData(fullName: 'John Doe');
      expect(data.resolve('fullName'), 'John Doe');
    });

    test('resolve returns social field with prefix', () {
      final data = BusinessCardData(social: {'github': 'johndoe'});
      expect(data.resolve('social.github'), 'johndoe');
    });

    test('resolve returns custom field with prefix', () {
      final data = BusinessCardData(custom: {'color': 'blue'});
      expect(data.resolve('custom.color'), 'blue');
    });

    test('resolve returns extra field as fallback', () {
      final data = BusinessCardData(extra: {'theme': 'dark'});
      expect(data.resolve('theme'), 'dark');
    });

    test('resolve prefer direct field over extra', () {
      final data = BusinessCardData(
        fullName: 'John',
        extra: {'fullName': 'Jane'},
      );
      expect(data.resolve('fullName'), 'John');
    });

    test('resolve returns null for missing field', () {
      final data = BusinessCardData();
      expect(data.resolve('nonexistent'), isNull);
    });

    test('merge keeps all extra fields', () {
      final a = BusinessCardData(fullName: 'John', extra: {'misc': 'info'});
      final b = BusinessCardData(jobTitle: 'Engineer', extra: {'misc': 'info2'});
      final merged = a.merge(b);
      expect(merged.fullName, 'John');
      expect(merged.jobTitle, 'Engineer');
      expect(merged.extra['misc'], 'info2');
    });
  });

  group('DataProvider', () {
    test('setData stores data', () {
      final provider = DataProvider();
      provider.setData(BusinessCardData(fullName: 'Jane'));
      expect(provider.resolve('fullName'), 'Jane');
    });

    test('updateField updates extra field', () {
      final provider = DataProvider();
      provider.setData(BusinessCardData(fullName: 'Jane'));
      provider.updateField('fullName', 'Janet');
      expect(provider.data.extra['fullName'], 'Janet');
    });

    test('allFields returns complete map', () {
      final provider = DataProvider();
      provider.setData(BusinessCardData(
        fullName: 'John',
        company: 'Acme',
      ));
      final fields = provider.allFields();
      expect(fields['fullName'], 'John');
      expect(fields['company'], 'Acme');
    });
  });
}
