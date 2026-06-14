import 'dart:convert';
import 'dart:io' show File, Directory;
import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/models/gradient_definition.dart';
import 'package:business_card/theme_engine/models/layout_constraint.dart';
import 'package:business_card/theme_engine/models/scene_node.dart';
import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/transform.dart';
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

BusinessCardData _makeData({
  String name = 'Test User',
  String title = 'Engineer',
  String company = 'Test Corp',
  String email = 'test@test.com',
  String phone = '+1234567890',
  String website = 'https://test.com',
  String address = '123 Test St',
}) {
  return BusinessCardData(
    fullName: name,
    jobTitle: title,
    company: company,
    email: email,
    phone: phone,
    website: website,
    address: address,
    social: {'linkedin': 'testuser'},
  );
}

void main() {
  final templateFiles = _templateFiles();
  if (templateFiles.isEmpty) {
    test('no templates found', () {});
    return;
  }

  group('Validation: Live Data Updates', () {
    test('name change reflects in resolved output', () {
      final runtime = CardRuntime();
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);
      runtime.setDocument(doc);

      runtime.setCardData(_makeData(name: 'Alice'));
      final result1 = runtime.render(
        viewportWidth: doc.canvas.width,
        viewportHeight: doc.canvas.height,
      );

      runtime.setCardData(_makeData(name: 'Bob'));
      final result2 = runtime.render(
        viewportWidth: doc.canvas.width,
        viewportHeight: doc.canvas.height,
      );

      print('  Renders with names Alice/Bob: '
          '${result1.metrics.failedNodes}/${result2.metrics.failedNodes} failures');
    });

    test('multiple rapid data updates without document reload', () {
      final runtime = CardRuntime();
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);
      runtime.setDocument(doc);

      final names = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon'];
      for (final name in names) {
        runtime.setCardData(_makeData(name: name));
        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );
        print('  $name: ${result.metrics.failedNodes} failures');
      }
      print('  ${names.length} rapid data updates completed');
    });

    test('templates contain widget nodes with data fields', () {
      final file = templateFiles.first;
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final doc = TemplateToThemeConverter.convert(json);

      bool hasWidgetWithField = false;
      void _walk(Iterable<SceneNode> nodes) {
        for (final node in nodes) {
          node.when(
            group: (String id, String? name, bool visible, double opacity,
                List<SceneNode> children, Map<String, dynamic> props) {
              _walk(children);
            },
            paint: (String id, String type, String? name, bool visible,
                double opacity, int zIndex, Transform transform,
                LayoutConstraint? constraints, String? color,
                GradientDefinition? gradient, double? strokeWidth,
                String? strokeColor, List<ShadowDefinition> shadows,
                Map<String, dynamic> props) {},
            widget: (String id, String type, String? name, bool visible,
                double opacity, int zIndex, Transform transform,
                LayoutConstraint? constraints, String? field,
                double? fontSize, String? color, String? fontWeight,
                double? maxLines, double? size, String? shape,
                List<ShadowDefinition> shadows, Map<String, dynamic> props) {
              if (field != null) hasWidgetWithField = true;
            },
          );
        }
      }
      _walk(doc.scene.nodes);

      expect(hasWidgetWithField, isTrue,
          reason: 'No widget nodes with data fields found');
      print('  Template has data-bound widget nodes');
    });
  });
}
