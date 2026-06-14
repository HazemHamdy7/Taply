import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/runtime/field/field_binding.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';

void main() {
  group('FieldBinding', () {
    test('bind resolves template properties', () {
      final binding = FieldBinding();
      final data = BusinessCardData(
        fullName: 'John Doe',
        jobTitle: 'Engineer',
      );

      final node = RenderPaintNode(
        id: 'test',
        type: 'text',
        properties: {'text': r'Hello ${fullName}', 'label': r'${jobTitle}'},
      );

      final bound = binding.bindNode(node, data);
      expect(bound.properties['text'], 'Hello John Doe');
      expect(bound.properties['label'], 'Engineer');
    });

    test('bind preserves non-template properties', () {
      final binding = FieldBinding();
      final data = BusinessCardData(fullName: 'John');

      final node = RenderPaintNode(
        id: 'test',
        type: 'rect',
        properties: {'color': '#FF0000', 'width': '100'},
      );

      final bound = binding.bindNode(node, data);
      expect(bound.properties['color'], '#FF0000');
      expect(bound.properties['width'], '100');
    });

    test('bind handles nested children via RenderGroup', () {
      final binding = FieldBinding();
      final data = BusinessCardData(fullName: 'John');

      final child = RenderPaintNode(
        id: 'child',
        type: 'text',
        properties: {'text': r'${fullName}'},
      );
      final parent = RenderGroup(
        id: 'parent',
        properties: {},
        children: [child],
      );

      final bound = binding.bind(parent, data) as RenderGroup;
      expect(bound.children.length, 1);
      expect(
        (bound.children[0] as RenderPaintNode).properties['text'],
        'John',
      );
    });

    test('bindWidgetNode resolves widget properties', () {
      final binding = FieldBinding();
      final data = BusinessCardData(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
      );

      final node = RenderWidgetNode(
        id: 'avatar',
        type: 'avatar',
        properties: {'name': r'${fullName}'},
      );

      final bound = binding.bindWidgetNode(node, data);
      expect(bound.properties['name'], 'Jane Doe');
    });

    test('bind handles empty properties map', () {
      final binding = FieldBinding();
      final data = BusinessCardData();

      final node = RenderPaintNode(
        id: 'empty',
        type: 'container',
        properties: {},
      );

      final bound = binding.bindNode(node, data);
      expect(bound.properties, isEmpty);
    });

    test('bind handles list properties', () {
      final binding = FieldBinding();
      final data = BusinessCardData(fullName: 'John');

      final node = RenderPaintNode(
        id: 'list',
        type: 'row',
        properties: {'items': [r'Hello ${fullName}', 'static']},
      );

      final bound = binding.bindNode(node, data);
      expect(
        (bound.properties['items'] as List)[0],
        'Hello John',
      );
      expect((bound.properties['items'] as List)[1], 'static');
    });

    test('resolve resolves a single template string', () {
      final binding = FieldBinding();
      final data = BusinessCardData(fullName: 'Alice');
      expect(binding.resolve(r'Hello ${fullName}', data), 'Hello Alice');
    });

    test('resolve with expression', () {
      final binding = FieldBinding();
      final data = BusinessCardData(fullName: 'Alice');
      expect(
        binding.resolve(r'${uppercase(fullName)}', data),
        'ALICE',
      );
    });
  });
}
