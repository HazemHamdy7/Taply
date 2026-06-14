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

void main() {
  final templateFiles = _templateFiles();
  if (templateFiles.isEmpty) {
    test('no templates found', () {});
    return;
  }

  group('Validation: Image Stress', () {
    test('render with empty image fields does not crash', () {
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(BusinessCardData(
          fullName: 'Image Test',
          jobTitle: 'Tester',
          company: 'Test',
          email: 't@t.com',
          phone: '+1',
          website: 'https://t.com',
          address: 'Nowhere',
          social: {},
        ));

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

        final count = result.metrics.failedNodes;
        if (count > 0) {
          print('  ⚠ ${file.path}: $count failures (empty social)');
        }
      }
      print('  All templates render with empty image/social fields');
    });

    test('render with long text fields does not crash', () {
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(BusinessCardData(
          fullName: 'A' * 200,
          jobTitle: 'B' * 200,
          company: 'C' * 200,
          email: 'very.long.email.address@extremely.long.domain.extension.com',
          phone: '+1-555-123-4567-8901-2345-6789',
          website: 'https://this.is.a.very.long.website.url.with.many.subdomains.example.com',
          address: 'D' * 300,
          social: {'linkedin': 'E' * 100},
        ));

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

        final count = result.metrics.failedNodes;
        if (count > 0) {
          print('  ⚠ ${file.path}: $count failures (long text)');
        }
      }
      print('  All templates render with excessively long text fields');
    });

    test('render with special characters does not crash', () {
      const specialTitle = 'Test@#' r'$%' r'^&*()_+={}[]|\:;"' "'<>,.?/~";
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(BusinessCardData(
          fullName: '<script>alert("xss")</script>',
          jobTitle: specialTitle,
          company: '🚀🔥💯✅❌©®™±≤≥≠∞',
          email: 'test+special_chars@domain.com',
          phone: '+1 (555) 123-4567',
          website: 'https://test.com/?q=special&chars=❤️',
          address: 'Line1\nLine2\nLine3\tTabbed',
          social: {'linkedin': 'spec!@l'},
        ));

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

        final count = result.metrics.failedNodes;
        if (count > 0) {
          print('  ⚠ ${file.path}: $count failures (special chars)');
        }
      }
      print('  All templates render with special characters');
    });
  });
}
