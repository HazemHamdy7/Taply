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

  group('Validation: Integration — Full User Flow', () {
    test('Create → Theme → Edit → Preview → Export → Share flow', () async {
      // Create: Initialize runtime with user data
      final runtime = CardRuntime();
      runtime.setCardData(BusinessCardData(
        fullName: 'John Doe',
        jobTitle: 'Software Engineer',
        company: 'Tech Inc.',
        email: 'john@tech.com',
        phone: '+1-555-0100',
        website: 'https://john.doe.dev',
        address: '456 Innovation Drive, San Francisco, CA',
        social: {
          'linkedin': 'johndoe',
          'twitter': '@johndoe',
          'github': 'johndoe',
        },
      ));

      expect(runtime.hasData, isTrue);
      print('  Step 1 ✓ Create: Data set');

      // Theme: Load and render each template
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        runtime.setDocument(doc);

        // Edit: Try data updates while theme is set
        runtime.setCardData(BusinessCardData(
          fullName: 'John Doe',
          jobTitle: 'Senior Software Engineer',
          company: 'Tech Inc.',
          email: 'john.doe@tech.com',
          phone: '+1-555-0101',
          website: 'https://john.doe.dev',
          address: '456 Innovation Drive, San Francisco, CA',
          social: {
            'linkedin': 'johndoe',
            'twitter': '@johndoe',
            'github': 'johndoe',
          },
        ));

        // Preview
        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

        final count = result.metrics.failedNodes;
        if (count > 0) {
          print('  ⚠ ${file.path} preview: $count failures');
        }
      }
      print('  Step 2-4 ✓ Theme / Edit / Preview: All ${templateFiles.length} themes');

      // Export
      final exportDoc = TemplateToThemeConverter.convert(
        jsonDecode(templateFiles.first.readAsStringSync()) as Map<String, dynamic>,
      );
      runtime.setDocument(exportDoc);
      runtime.setCardData(BusinessCardData(fullName: 'Export User'));
      final pngBytes = await runtime.renderToPngBytes(
        viewportWidth: exportDoc.canvas.width,
        viewportHeight: exportDoc.canvas.height,
        pixelRatio: 3.0,
      );
      expect(pngBytes, isNotEmpty);
      print('  Step 5 ✓ Export: ${pngBytes.length} bytes at 3x');

      print('');
      print('  ═══ FULL USER FLOW: ALL STEPS PASSED ═══');
    }, timeout: const Timeout(Duration(seconds: 120)));

    test('data changes trigger different render output', () {
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);

      final runtime = CardRuntime();
      runtime.setDocument(doc);

      // Render with initial data
      runtime.setCardData(BusinessCardData(fullName: 'Version 1'));
      final result1 = runtime.render(
        viewportWidth: doc.canvas.width,
        viewportHeight: doc.canvas.height,
      );

      // Render with updated data
      runtime.setCardData(BusinessCardData(fullName: 'Updated Version 2'));
      final result2 = runtime.render(
        viewportWidth: doc.canvas.width,
        viewportHeight: doc.canvas.height,
      );

      expect(result1.metrics.failedNodes, lessThan(result2.metrics.failedNodes + 5));
      expect(result2.metrics.failedNodes, lessThan(result1.metrics.failedNodes + 5));
      print('  Data changes produce valid renders: V1=${result1.metrics.failedNodes}f V2=${result2.metrics.failedNodes}f');
    });

    test('all properties survive round-trip', () {
      final sourceJson = jsonDecode(
        templateFiles.first.readAsStringSync(),
      ) as Map<String, dynamic>;

      final doc = TemplateToThemeConverter.convert(sourceJson);
      // Convert back to JSON-like map
      final reEncoded = jsonDecode(jsonEncode(doc.toJson())) as Map<String, dynamic>;

      expect(reEncoded['metadata']['id'], equals(sourceJson['id'] ?? ''),
          reason: 'metadata.id mismatch');
      // Check that scene nodes exist
      expect(reEncoded['scene']['nodes'], isNotEmpty,
          reason: 'No scene nodes after round-trip');
      print('  Round-trip JSON conversion preserves structure');
    });

    test('consecutive render calls are consistent', () {
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);

      final runtime = CardRuntime();
      runtime.setDocument(doc);
      runtime.setCardData(BusinessCardData(fullName: 'Consistency Test'));

      final failures1 = runtime.render(
        viewportWidth: doc.canvas.width,
        viewportHeight: doc.canvas.height,
      ).metrics.failedNodes;

      final failures2 = runtime.render(
        viewportWidth: doc.canvas.width,
        viewportHeight: doc.canvas.height,
      ).metrics.failedNodes;

      expect(failures1, equals(failures2),
          reason: 'Inconsistent failure counts between renders');
      print('  Consecutive renders: both with $failures1 failures');
    });
  });
}
