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

  group('Validation: Export', () {
    test('render produces non-empty picture', () {
      final runtime = CardRuntime();
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);

      runtime.setDocument(doc);
      runtime.setCardData(BusinessCardData(
        fullName: 'Test User',
        jobTitle: 'Engineer',
        company: 'Test Corp',
        email: 'test@test.com',
        phone: '+1234567890',
        website: 'https://test.com',
        address: '123 Test St',
        social: {'linkedin': 'testuser'},
      ));

      final result = runtime.render(viewportWidth: 1000, viewportHeight: 600);
      expect(result.picture, isNotNull);
      print('  Render produced Picture: ${result.boundNodes} nodes, '
          '${result.metrics.failedNodes} failures');
    });

    test('renderToPngBytes produces non-empty PNG data', () async {
      final runtime = CardRuntime();
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);

      runtime.setDocument(doc);
      runtime.setCardData(BusinessCardData(fullName: 'Export Test'));

      final pngBytes = await runtime.renderToPngBytes(
        viewportWidth: 1000,
        viewportHeight: 600,
        pixelRatio: 2.0,
      );

      expect(pngBytes, isNotEmpty);
      expect(pngBytes.length, greaterThan(100),
          reason: 'PNG output too small');
      print('  PNG export: ${pngBytes.length} bytes at 2x');
    });

    test('renderToPngBytes at different pixel ratios', () async {
      final runtime = CardRuntime();
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);

      runtime.setDocument(doc);
      runtime.setCardData(BusinessCardData(fullName: 'PR Test'));

      for (final pr in [1.0, 2.0, 3.0, 4.0]) {
        final pngBytes = await runtime.renderToPngBytes(
          viewportWidth: 1000,
          viewportHeight: 600,
          pixelRatio: pr,
        );
        expect(pngBytes, isNotEmpty,
            reason: 'Empty at ${pr}x');
        print('  PNG at ${pr}x: ${pngBytes.length} bytes');
      }
    });

    test('all templates export successfully', () async {
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(BusinessCardData(
          fullName: file.path.split(RegExp(r'[/\\]')).last,
        ));

        final pngBytes = await runtime.renderToPngBytes(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
          pixelRatio: 2.0,
        );

        expect(pngBytes, isNotEmpty,
            reason: '${file.path} export empty');
        print('  ✓ ${file.path.split(RegExp(r'[/\\]')).last}: '
            '${pngBytes.length} bytes');
      }
    }, timeout: const Timeout(Duration(seconds: 120)));
  });
}
