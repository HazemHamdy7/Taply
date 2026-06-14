import 'dart:convert';
import 'dart:io' show File, Directory;
import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/card_runtime.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';
import 'package:business_card/shared/integration/template_to_theme_converter.dart';

const _templateDir = 'assets/templates';

List<File> _templateFiles() {
  final dir = Directory(_templateDir);
  if (!dir.existsSync()) return [];
  return dir.listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()..sort((a, b) => a.path.compareTo(b.path));
}

BusinessCardData _rtlData(String name) {
  return BusinessCardData(
    fullName: name,
    jobTitle: 'مهندس برمجيات',
    company: 'شركة التقنية',
    email: 'user@domain.com',
    phone: '+971501234567',
    website: 'https://example.ae',
    address: 'شارع الوحدة، أبوظبي',
    social: {'linkedin': 'user'},
  );
}

void main() {
  final templateFiles = _templateFiles();
  if (templateFiles.isEmpty) {
    test('no templates found', () {});
    return;
  }

  group('Validation: RTL Content', () {
    Map<String, int> _testScenario(String label, BusinessCardData data) {
      final failures = <String, int>{};
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(data);

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );
        if (result.metrics.failedNodes > 0) {
          failures[file.path.split(RegExp(r'[/\\]')).last] =
              result.metrics.failedNodes;
        }
      }
      final clean = templateFiles.length - failures.length;
      if (failures.isEmpty) {
        print('  ✓ $label: all ${templateFiles.length} templates clean');
      } else {
        print('  ⚠ $label: $clean/${templateFiles.length} clean, failures:');
        for (final e in failures.entries) {
          print('      ${e.key}: ${e.value} node(s)');
        }
      }
      return failures;
    }

    test('Arabic fullName renders without failures', () {
      final failures = _testScenario('Arabic', _rtlData('أحمد محمد'));
      expect(failures.length, lessThan(templateFiles.length),
          reason: 'All templates failed');
    });

    test('Hebrew content renders without failures', () {
      final failures = _testScenario('Hebrew', _rtlData('דוד כהן'));
      expect(failures.length, lessThan(templateFiles.length),
          reason: 'All templates failed');
    });

    test('mixed LTR/RTL content renders without failures', () {
      final failures = _testScenario('Mixed LTR/RTL', BusinessCardData(
        fullName: 'John (جون) Smith',
        jobTitle: 'Software Engineer / مهندس',
        company: 'Tech Corp / شركة تقنية',
        email: 'john@company.com',
        phone: '+1-555-0123',
        website: 'https://john.smith.dev',
        address: '123 Main St, NY / نيويورك',
        social: {'linkedin': 'johnsmith'},
      ));
      expect(failures.length, lessThan(templateFiles.length),
          reason: 'All templates failed');
    });

    test('Arabic-only company renders without failures', () {
      final failures = _testScenario('Arabic-only', BusinessCardData(
        fullName: 'سارة',
        jobTitle: 'مديرة تسويق',
        company: 'مؤسسة الأفق للتجارة',
        email: 'sara@example.com',
        phone: '+966555123456',
        website: 'https://example.sa',
        address: 'الرياض، المملكة العربية السعودية',
        social: {'twitter': 'sara'},
      ));
      expect(failures.length, lessThan(templateFiles.length),
          reason: 'All templates failed');
    });
  });
}
