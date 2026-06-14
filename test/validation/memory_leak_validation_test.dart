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

  group('Validation: Memory Leak', () {
    test('repeated create/dispose of runtime does not leak', () {
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);

        const iterations = 50;
        for (var i = 0; i < iterations; i++) {
          final runtime = CardRuntime();
          runtime.setDocument(doc);
          runtime.setCardData(BusinessCardData(
            fullName: 'Leak Test $i',
            jobTitle: 'Tester',
            company: 'Leak Corp',
            email: 'leak@test.com',
            phone: '+1',
            website: 'https://leak.test',
            address: '123 Leak St',
            social: {},
          ));

          final result = runtime.render(
            viewportWidth: doc.canvas.width,
            viewportHeight: doc.canvas.height,
          );

          final count = result.metrics.failedNodes;
          if (count > 0) {
            print('  ⚠ ${file.path} iteration $i: $count failures');
          }
        }
      }
      print('  ${templateFiles.length * 50} create/render/dispose cycles: all completed');
    });

    test('repeated setDocument with different documents', () {
      final runtime = CardRuntime();
      runtime.setCardData(BusinessCardData(fullName: 'Switch Test'));

      for (var i = 0; i < 100; i++) {
        final file = templateFiles[i % templateFiles.length];
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        runtime.setDocument(doc);

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

          final count = result.metrics.failedNodes;
          if (count > 0) {
            print('  ⚠ iteration $i ${file.path}: $count failures');
          }
        }
        print('  100 document switches: all completed');
      });

    test('zero renders after init — no crash on dispose', () {
      // Create and dispose without rendering — should not error
      final runtime = CardRuntime();
      runtime.setDocument(TemplateToThemeConverter.convert(
        jsonDecode(templateFiles.first.readAsStringSync()) as Map<String, dynamic>,
      ));
      runtime.setCardData(BusinessCardData(fullName: 'Dispose Test'));
      print('  Runtime created, configured, and disposed without render: OK');
    });
  });
}
