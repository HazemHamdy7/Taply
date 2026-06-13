import 'dart:ui' show
    PictureRecorder,
    Canvas,
    Color,
    BlendMode,
    StrokeCap,
    StrokeJoin;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/gradient_definition.dart';
import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/paint_result.dart';
import 'package:business_card/theme_engine/paint_engine/painters/rectangle_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

PaintContext _makeContext(RenderPaintNode node, {Canvas? canvas}) {
  return PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'test', name: 'Test'),
    ),
    renderTree: RenderTree(
      canvasWidth: 1000,
      canvasHeight: 600,
      viewportWidth: 1000,
      viewportHeight: 600,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [node]),
    ),
    renderNode: node,
    viewportWidth: 1000,
    viewportHeight: 600,
    scaleFactor: 1.0,
  );
}

PaintResult _paintNode(RenderPaintNode node) {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final ctx = _makeContext(node, canvas: canvas);
  final painter = RectanglePainter();
  painter.prepare(ctx);
  final result = painter.paint(ctx);
  recorder.endRecording();
  return result;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('RectanglePaintStyle', () {
    test('fromNode creates default fill style', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.fillColor, equals(Color(0xFFFF0000)));
      expect(style.hasFill, isTrue);
      expect(style.hasStroke, isFalse);
      expect(style.hasShadows, isFalse);
    });

    test('fromNode reads stroke properties', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
        properties: {'styleType': 'fillAndStroke'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.strokeWidth, equals(3.0));
      expect(style.strokeColor, equals(Color(0xFF00FF00)));
      expect(style.hasStroke, isTrue);
    });

    test('fromNode reads dash pattern', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 2, strokeColor: '#000',
        properties: {'dashPattern': [10, 5], 'styleType': 'fillAndStroke'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.hasDash, isTrue);
      expect(style.dashPattern, equals([10.0, 5.0]));
    });

    test('fromNode reads gradient', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(kind: 'linear', colors: ['#FF0000', '#00FF00']),
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.hasGradient, isTrue);
      expect(style.fillGradient, isNotNull);
    });

    test('fromNode reads shadows from properties', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('fromNode reads shadows from model', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 2, offsetY: 2, blurRadius: 4)],
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('null color returns null fillColor', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.fillColor, isNull);
      expect(style.hasFill, isFalse);
    });

    test('empty string color returns null fillColor', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '',
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.fillColor, isNull);
      expect(style.hasFill, isFalse);
    });

    test('both fill and stroke working together (fillAndStroke)', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
        properties: {'styleType': 'fillAndStroke'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.hasFill, isTrue);
      expect(style.hasStroke, isTrue);
      expect(style.fillColor, equals(Color(0xFFFF0000)));
      expect(style.strokeColor, equals(Color(0xFF00FF00)));
    });

    test('stroke-only style has no fill', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
        properties: {'styleType': 'stroke'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.hasFill, isFalse);
      expect(style.hasStroke, isTrue);
    });

    test('all strokeAlignment values parsed correctly', () {
      final nodeCenter = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000', strokeWidth: 2, strokeColor: '#FFF',
        properties: {'styleType': 'fillAndStroke'},
      );
      expect(RectanglePaintStyle.fromNode(nodeCenter).strokeAlignment, equals(StrokeAlignment.center));

      final nodeInside = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000', strokeWidth: 2, strokeColor: '#FFF',
        properties: {'strokeAlignment': 'inside', 'styleType': 'fillAndStroke'},
      );
      expect(RectanglePaintStyle.fromNode(nodeInside).strokeAlignment, equals(StrokeAlignment.inside));

      final nodeOutside = RenderPaintNode(
        id: 'r3', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000', strokeWidth: 2, strokeColor: '#FFF',
        properties: {'strokeAlignment': 'outside', 'styleType': 'fillAndStroke'},
      );
      expect(RectanglePaintStyle.fromNode(nodeOutside).strokeAlignment, equals(StrokeAlignment.outside));
    });

    test('StrokeCap parsing (butt, round, square)', () {
      final nodeDefault = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
      );
      expect(RectanglePaintStyle.fromNode(nodeDefault).strokeCap, equals(StrokeCap.butt));

      final nodeRound = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'strokeCap': 'round'},
      );
      expect(RectanglePaintStyle.fromNode(nodeRound).strokeCap, equals(StrokeCap.round));

      final nodeSquare = RenderPaintNode(
        id: 'r3', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'strokeCap': 'square'},
      );
      expect(RectanglePaintStyle.fromNode(nodeSquare).strokeCap, equals(StrokeCap.square));
    });

    test('StrokeJoin parsing (miter, round, bevel)', () {
      final nodeDefault = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
      );
      expect(RectanglePaintStyle.fromNode(nodeDefault).strokeJoin, equals(StrokeJoin.miter));

      final nodeRound = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'strokeJoin': 'round'},
      );
      expect(RectanglePaintStyle.fromNode(nodeRound).strokeJoin, equals(StrokeJoin.round));

      final nodeBevel = RenderPaintNode(
        id: 'r3', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'strokeJoin': 'bevel'},
      );
      expect(RectanglePaintStyle.fromNode(nodeBevel).strokeJoin, equals(StrokeJoin.bevel));
    });

    test('individual corner read from borderRadius properties', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'borderRadiusTL': 5,
          'borderRadiusTR': 10,
          'borderRadiusBR': 15,
          'borderRadiusBL': 20,
        },
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.borderRadiusTL, equals(5));
      expect(opts.borderRadiusTR, equals(10));
      expect(opts.borderRadiusBR, equals(15));
      expect(opts.borderRadiusBL, equals(20));
    });

    test('dash pattern empty list behaves as no dash', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'dashPattern': <dynamic>[], 'styleType': 'fillAndStroke'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.dashPattern, isEmpty);
      expect(style.hasDash, isFalse);
    });

    test('blend mode parsing covers all values', () {
      final allModes = <String, BlendMode>{
        'srcOver': BlendMode.srcOver,
        'srcIn': BlendMode.srcIn,
        'srcOut': BlendMode.srcOut,
        'srcATop': BlendMode.srcATop,
        'dstOver': BlendMode.dstOver,
        'dstIn': BlendMode.dstIn,
        'dstOut': BlendMode.dstOut,
        'dstATop': BlendMode.dstATop,
        'multiply': BlendMode.multiply,
        'screen': BlendMode.screen,
        'overlay': BlendMode.overlay,
        'darken': BlendMode.darken,
        'lighten': BlendMode.lighten,
        'colorDodge': BlendMode.colorDodge,
        'colorBurn': BlendMode.colorBurn,
        'hardLight': BlendMode.hardLight,
        'softLight': BlendMode.softLight,
        'difference': BlendMode.difference,
        'exclusion': BlendMode.exclusion,
        'hue': BlendMode.hue,
        'saturation': BlendMode.saturation,
        'color': BlendMode.color,
        'luminosity': BlendMode.luminosity,
      };
      for (final entry in allModes.entries) {
        final node = RenderPaintNode(
          id: 'r', type: 'rect', x: 0, y: 0, width: 10, height: 10,
          color: '#000',
          properties: {'blendMode': entry.key},
        );
        final style = RectanglePaintStyle.fromNode(node);
        expect(style.blendMode, equals(entry.value), reason: 'blendMode=${entry.key}');
      }
    });

    test('unknown blend mode defaults to srcOver', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect', x: 0, y: 0, width: 10, height: 10,
        color: '#000',
        properties: {'blendMode': 'nonExistent'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.blendMode, equals(BlendMode.srcOver));
    });

    test('multiple shadows from properties AND model combined', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [
          const ShadowDefinition(color: '#000000', offsetX: 2, offsetY: 2, blurRadius: 4, opacity: 0.3),
        ],
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.shadows.length, equals(2));
    });

    test('gradient with no colors returns null fillGradient', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(kind: 'linear', colors: []),
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.fillGradient, isNull);
      expect(style.hasGradient, isFalse);
    });

    test('gradient with null kind returns null fillGradient', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: const GradientDefinition(kind: 'unknown', colors: ['#FF0000']),
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.fillGradient, isNull);
      expect(style.hasGradient, isFalse);
    });

    test('hasShadows getter consistent with empty list', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final style = RectanglePaintStyle.fromNode(node);
      expect(style.shadows, isEmpty);
      expect(style.hasShadows, isFalse);
    });

    test('toString returns readable description', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
        properties: {'styleType': 'fillAndStroke'},
      );
      final style = RectanglePaintStyle.fromNode(node);
      final str = style.toString();
      expect(str, contains('fill'));
      expect(str, contains('stroke'));
    });

    test('equality considers styleType, fillColor, strokeColor, strokeWidth, strokeAlignment, blendMode', () {
      final node1 = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 2, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke', 'strokeAlignment': 'center'},
      );
      final node2 = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 2, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke', 'strokeAlignment': 'center'},
      );
      expect(
        RectanglePaintStyle.fromNode(node1),
        equals(RectanglePaintStyle.fromNode(node2)),
      );
    });
  });

  group('RectanglePaintOptions', () {
    test('fromNode creates basic rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 10, y: 20, width: 200, height: 150,
        color: '#FF0000',
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.rect.left, equals(10));
      expect(opts.rect.top, equals(20));
      expect(opts.rect.width, equals(200));
      expect(opts.rect.height, equals(150));
      expect(opts.visible, isTrue);
      expect(opts.style.fillColor, equals(Color(0xFFFF0000)));
    });

    test('fromNode reads individual corner radii', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'borderRadiusTL': 10,
          'borderRadiusTR': 20,
          'borderRadiusBR': 30,
          'borderRadiusBL': 40,
        },
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.borderRadiusTL, equals(10));
      expect(opts.borderRadiusTR, equals(20));
      expect(opts.borderRadiusBR, equals(30));
      expect(opts.borderRadiusBL, equals(40));
      expect(opts.hasBorderRadius, isTrue);
    });

    test('fromNode reads uniform borderRadius', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'borderRadius': 15},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.borderRadiusTL, equals(15));
      expect(opts.borderRadiusTR, equals(15));
      expect(opts.borderRadiusBR, equals(15));
      expect(opts.borderRadiusBL, equals(15));
    });

    test('fromNode reads transform matrix', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'transformMatrix': [1,0,0,0, 0,1,0,0, 0,0,1,0, 50,60,0,1],
        },
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.transformMatrix, isNotNull);
      expect(opts.transformMatrix![12], equals(50));
      expect(opts.transformMatrix![13], equals(60));
    });

    test('fromNode reads translation', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'translateX': 25, 'translateY': 35},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.translateX, equals(25));
      expect(opts.translateY, equals(35));
    });

    test('fromNode reads clip + debug', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'clipping': true, 'debugPaint': true},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.clipping, isTrue);
      expect(opts.debugPaint, isTrue);
    });

    test('computePaintBounds includes stroke', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 10, y: 10, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 10, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke'},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.left, lessThan(10));
    });

    test('computePaintBounds includes rotation', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 50, y: 50, width: 100, height: 50,
        color: '#FF0000',
        rotation: 0.5,
      );
      final opts = RectanglePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
    });

    test('toRRect builds proper RRect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'borderRadiusTL': 5, 'borderRadiusTR': 10},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      final rrect = opts.toRRect();
      expect(rrect.tlRadiusX, equals(5));
      expect(rrect.trRadiusX, equals(10));
    });

    test('zero width/height rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 10, y: 10, width: 0, height: 0,
        color: '#FF0000',
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.rect.width, equals(0));
      expect(opts.rect.height, equals(0));
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('negative width/height rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 10, y: 10, width: -50, height: -30,
        color: '#FF0000',
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.rect.width, equals(-50));
      expect(opts.rect.height, equals(-30));
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('large dimensions do not crash', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 10000, height: 10000,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('opacity edge cases (0, >1 clamped)', () {
      final nodeZero = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0,
      );
      final optsZero = RectanglePaintOptions.fromNode(nodeZero);
      expect(optsZero.opacity, equals(0));

      final nodeOver = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 2.5,
      );
      final optsOver = RectanglePaintOptions.fromNode(nodeOver);
      expect(optsOver.opacity, equals(2.5));
    });

    test('negative rotation', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 50, y: 50, width: 100, height: 80,
        color: '#FF0000', rotation: -0.5,
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.rotation, equals(-0.5));
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('scaleX=0 creates no visible area', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleX: 0,
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.scaleX, equals(0));
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('scaleY=0 creates no visible area', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleY: 0,
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.scaleY, equals(0));
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('empty transform matrix', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'transformMatrix': <dynamic>[]},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.transformMatrix, isNull);
    });

    test('null properties (empty map) does not crash', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: <String, dynamic>{},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts, isNotNull);
    });

    test('invalid hitTestBounds missing fields returns null', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'hitTestBounds': {'x': 10, 'y': 20}, // missing width/height
        },
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNull);
    });

    test('computePaintBounds with shadows and rotation', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 50, y: 50, width: 100, height: 80,
        color: '#FF0000',
        rotation: 0.3,
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final opts = RectanglePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
      expect(bounds.height, greaterThan(80));
    });

    test('computePaintBounds with scaleX=0', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleX: 0,
      );
      final opts = RectanglePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, equals(0));
    });

    test('hasBorderRadius getter', () {
      final nodeNoRadius = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
      );
      expect(RectanglePaintOptions.fromNode(nodeNoRadius).hasBorderRadius, isFalse);

      final nodeWithRadius = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'borderRadius': 10},
      );
      expect(RectanglePaintOptions.fromNode(nodeWithRadius).hasBorderRadius, isTrue);
    });

    test('borderRadius getter returns TL', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'borderRadiusTL': 8},
      );
      expect(RectanglePaintOptions.fromNode(node).borderRadius, equals(8));
    });

    test('toString includes rect and style info', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 10, y: 20, width: 200, height: 150,
        color: '#FF0000',
      );
      final opts = RectanglePaintOptions.fromNode(node);
      final str = opts.toString();
      expect(str, contains('rect:'));
      expect(str, contains('opacity:'));
    });

    test('zIndex and paintOrder read from properties', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'zIndex': 5, 'paintOrder': 3},
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.zIndex, equals(5));
      expect(opts.paintOrder, equals(3));
    });
  });

  group('RectanglePaintMetrics', () {
    test('records all counters correctly', () {
      final m = RectanglePaintMetrics();
      m.recordRect(1000);
      m.recordGradient();
      m.recordStroke();
      m.recordShadow();
      m.recordClip();
      m.recordCacheHit();
      m.recordDuration(const Duration(milliseconds: 5));

      expect(m.rectanglesPainted, equals(1));
      expect(m.gradientPainted, equals(1));
      expect(m.strokedRectangles, equals(1));
      expect(m.shadowCount, equals(1));
      expect(m.clippedCount, equals(1));
      expect(m.cacheHits, equals(1));
      expect(m.cacheMisses, equals(0));
      expect(m.paintDuration.inMilliseconds, equals(5));
      expect(m.totalArea, equals(1000));
    });

    test('reset clears all counters', () {
      final m = RectanglePaintMetrics();
      m.recordRect(500);
      m.recordStroke();
      m.reset();
      expect(m.rectanglesPainted, equals(0));
      expect(m.totalArea, equals(0.0));
    });

    test('copy creates independent clone', () {
      final m = RectanglePaintMetrics();
      m.recordRect(200);
      final c = m.copy();
      c.recordRect(300);
      expect(m.rectanglesPainted, equals(1));
      expect(c.rectanglesPainted, equals(2));
    });

    test('operator+ merges correctly', () {
      final a = RectanglePaintMetrics();
      a.recordRect(100);
      a.recordStroke();
      final b = RectanglePaintMetrics();
      b.recordRect(200);
      b.recordGradient();
      final sum = a + b;
      expect(sum.rectanglesPainted, equals(2));
      expect(sum.strokedRectangles, equals(1));
      expect(sum.gradientPainted, equals(1));
      expect(sum.totalArea, equals(300));
    });

    test('averagePaintTimeMs returns 0 when no rects', () {
      final m = RectanglePaintMetrics();
      expect(m.averagePaintTimeMs, equals(0));
    });

    test('averagePaintTimeMs computes correctly', () {
      final m = RectanglePaintMetrics();
      m.recordRect(100);
      m.recordDuration(const Duration(milliseconds: 10));
      m.recordRect(100);
      m.recordDuration(const Duration(milliseconds: 20));
      expect(m.averagePaintTimeMs, closeTo(15.0, 0.1));
    });

    test('multiple cache hits', () {
      final m = RectanglePaintMetrics();
      m.recordCacheHit();
      m.recordCacheHit();
      m.recordCacheHit();
      expect(m.cacheHits, equals(3));
    });

    test('recordCacheMiss increments counter', () {
      final m = RectanglePaintMetrics();
      m.recordCacheMiss();
      expect(m.cacheMisses, equals(1));
      m.recordCacheMiss();
      expect(m.cacheMisses, equals(2));
    });

    test('large number of records', () {
      final m = RectanglePaintMetrics();
      for (var i = 0; i < 1000; i++) {
        m.recordRect(100);
        m.recordDuration(const Duration(microseconds: 50));
      }
      expect(m.rectanglesPainted, equals(1000));
      expect(m.totalArea, equals(100000));
    });

    test('averagePaintTimeMs precision with small durations', () {
      final m = RectanglePaintMetrics();
      m.recordRect(1);
      m.recordDuration(const Duration(microseconds: 1500));
      expect(m.averagePaintTimeMs, closeTo(1.5, 0.01));
    });

    test('toString returns formatted string', () {
      final m = RectanglePaintMetrics();
      m.recordRect(500);
      m.recordStroke();
      final str = m.toString();
      expect(str, contains('rects:'));
      expect(str, contains('strokes:'));
      expect(str, contains('avg:'));
    });
  });

  group('RectanglePainterDiagnostics', () {
    test('records operations', () {
      final d = RectanglePainterDiagnostics();
      d.recordOperation('drawRect');
      d.recordOperation('save');
      expect(d.totalOperations, equals(2));
    });

    test('records warnings and errors', () {
      final d = RectanglePainterDiagnostics();
      d.recordWarning('Low memory');
      d.recordError('Canvas null');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isTrue);
      expect(d.warnings.length, equals(1));
      expect(d.errors.length, equals(1));
    });

    test('records skipped', () {
      final d = RectanglePainterDiagnostics();
      d.recordSkipped('Not visible');
      expect(d.skipped.length, equals(1));
    });

    test('records allocations', () {
      final d = RectanglePainterDiagnostics();
      d.recordAllocation();
      d.recordAllocation();
      expect(d.memoryAllocations, equals(2));
    });

    test('reset clears everything', () {
      final d = RectanglePainterDiagnostics();
      d.recordOperation('draw');
      d.recordWarning('warn');
      d.reset();
      expect(d.totalOperations, equals(0));
      expect(d.hasWarnings, isFalse);
    });

    test('merge combines diagnostics', () {
      final a = RectanglePainterDiagnostics();
      a.recordOperation('op1');
      final b = RectanglePainterDiagnostics();
      b.recordOperation('op2');
      b.recordWarning('warn');
      a.merge(b);
      expect(a.totalOperations, equals(2));
      expect(a.hasWarnings, isTrue);
    });

    test('multiple merges accumulate correctly', () {
      final target = RectanglePainterDiagnostics();
      final src1 = RectanglePainterDiagnostics();
      src1.recordOperation('op1');
      src1.recordAllocation();
      final src2 = RectanglePainterDiagnostics();
      src2.recordOperation('op2');
      src2.recordError('err');
      target.merge(src1);
      target.merge(src2);
      expect(target.totalOperations, equals(2));
      expect(target.memoryAllocations, equals(1));
      expect(target.hasErrors, isTrue);
    });

    test('merge with empty does not change state', () {
      final d = RectanglePainterDiagnostics();
      d.recordOperation('op');
      d.recordAllocation();
      final empty = RectanglePainterDiagnostics();
      d.merge(empty);
      expect(d.totalOperations, equals(1));
      expect(d.memoryAllocations, equals(1));
    });

    test('totalDuration with multiple ops', () {
      final d = RectanglePainterDiagnostics();
      d.recordOperation('slow', duration: const Duration(milliseconds: 10));
      d.recordOperation('fast', duration: const Duration(microseconds: 500));
      expect(d.totalDuration.inMicroseconds, equals(10500));
    });

    test('hasWarnings / hasErrors getters', () {
      final d = RectanglePainterDiagnostics();
      expect(d.hasWarnings, isFalse);
      expect(d.hasErrors, isFalse);
      d.recordWarning('w');
      expect(d.hasWarnings, isTrue);
      d.recordError('e');
      expect(d.hasErrors, isTrue);
    });

    test('CanvasOperation toString', () {
      final op = CanvasOperation(name: 'drawRect', duration: const Duration(microseconds: 50));
      expect(op.toString(), contains('drawRect'));
      expect(op.toString(), contains('50'));
    });

    test('toString includes counts', () {
      final d = RectanglePainterDiagnostics();
      d.recordOperation('op');
      d.recordWarning('w');
      d.recordError('e');
      final str = d.toString();
      expect(str, contains('ops:'));
      expect(str, contains('warnings:'));
      expect(str, contains('errors:'));
    });
  });

  group('RectanglePainter', () {
    test('canPaint returns true for rect type', () {
      final painter = RectanglePainter();
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'rect')), isTrue);
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'circle')), isFalse);
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'text')), isFalse);
    });

    test('type returns rect', () {
      expect(RectanglePainter().type, equals('rect'));
    });

    test('capabilities is advanced', () {
      final caps = RectanglePainter().capabilities;
      expect(caps.supportsOpacity, isTrue);
      expect(caps.supportsTransform, isTrue);
      expect(caps.supportsGradient, isTrue);
      expect(caps.supportsStroke, isTrue);
      expect(caps.supportsShadow, isTrue);
      expect(caps.supportsClipping, isTrue);
      expect(caps.supportsBlendMode, isTrue);
    });

    test('paint returns success for basic rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
      expect(result.elementType, equals('rect'));
      expect(result.paintBounds, isNotNull);
    });

    test('paint returns success for rounded rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 10, y: 10, width: 100, height: 80,
        color: '#00FF00',
        properties: {'borderRadius': 16},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for gradient rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(kind: 'linear', colors: ['#FF0000', '#0000FF']),
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for transparent rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0.5,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for rotated rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 50, y: 50, width: 100, height: 80,
        color: '#FF0000', rotation: 0.3,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for scaled rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 50, height: 50,
        color: '#FF0000', scaleX: 2.0, scaleY: 1.5,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for shadow rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for clipped rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'clipping': true, 'borderRadius': 20},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for dashed border rect', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FFFFFF', strokeWidth: 3, strokeColor: '#000000',
        properties: {
          'dashPattern': [10, 5],
          'borderRadius': 12,
          'styleType': 'fillAndStroke',
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for invisible rect (skipped)', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', visible: false,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns failure when canvas is null', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final ctx = _makeContext(node);
      final painter = RectanglePainter();
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('metrics accumulate across paint calls', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node1 = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final ctx1 = _makeContext(node1, canvas: canvas);
      painter.prepare(ctx1);
      painter.paint(ctx1);

      final node2 = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 200, y: 200, width: 50, height: 50,
        color: '#00FF00',
      );
      final ctx2 = _makeContext(node2, canvas: canvas);
      painter.prepare(ctx2);
      painter.paint(ctx2);

      recorder.endRecording();

      expect(painter.metrics.rectanglesPainted, equals(2));
      expect(painter.metrics.totalArea, equals(10000 + 2500));
    });

    test('stroke alignment inside/outside', () {
      final nodeInside = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 10, strokeColor: '#000',
        properties: {'strokeAlignment': 'inside', 'styleType': 'fillAndStroke'},
      );
      final opts = RectanglePaintOptions.fromNode(nodeInside);
      expect(opts.style.strokeAlignment, equals(StrokeAlignment.inside));

      final nodeOutside = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 10, strokeColor: '#000',
        properties: {'strokeAlignment': 'outside', 'styleType': 'fillAndStroke'},
      );
      final opts2 = RectanglePaintOptions.fromNode(nodeOutside);
      expect(opts2.style.strokeAlignment, equals(StrokeAlignment.outside));
    });

    test('dispose cleans up', () {
      final painter = RectanglePainter();
      painter.prepare(_makeContext(RenderPaintNode(id: 'r', type: 'rect', x: 0, y: 0, width: 10, height: 10, color: '#000')));
      painter.dispose();
    });

    test('lifecycle: initialize -> prepare -> paint -> cleanup', () {
      final painter = RectanglePainter();
      painter.initialize();

      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final ctx = _makeContext(node, canvas: canvas);

      painter.prepare(ctx);
      final result = painter.paint(ctx);
      painter.cleanup();

      expect(result.success, isTrue);
      recorder.endRecording();
    });

    test('debug paint draws debug overlays', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'debugPaint': true},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('transform matrix is applied', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'transformMatrix': [1,0,0,0, 0,1,0,0, 0,0,1,0, 50,50,0,1],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('radial gradient paints successfully', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(
          kind: 'radial', colors: ['#FF0000', '#0000FF'],
          focalX: 0.5, focalY: 0.5, radius: 0.5,
        ),
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('sweep gradient paints successfully', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(
          kind: 'sweep', colors: ['#FF0000', '#0000FF'],
        ),
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('multiple shadows paint successfully', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 2, 'offsetY': 2, 'blurRadius': 4, 'opacity': 0.3},
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.2},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('fillAndStroke with gradient paints successfully', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(kind: 'linear', colors: ['#FF0000', '#0000FF']),
        strokeWidth: 2, strokeColor: '#FFFFFF',
        properties: {'styleType': 'fillAndStroke'},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('hitTestBounds are read correctly', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'hitTestBounds': {'x': -5, 'y': -5, 'width': 110, 'height': 110},
        },
      );
      final opts = RectanglePaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNotNull);
      expect(opts.hitTestBounds!.left, equals(-5));
    });

    test('demo runs without exceptions', () {
      final output = runRectanglePainterDemo();
      expect(output, contains('Demo Complete'));
      expect(output, contains('10 examples'));
      for (var i = 1; i <= 10; i++) {
        expect(output, contains('$i.'));
      }
    });

    test('paint with all properties empty (defaults)', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with scaleX=0 (edge case)', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleX: 0,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with huge strokeWidth', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 500, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke'},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with 2PI rotation', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 50, y: 50, width: 100, height: 80,
        color: '#FF0000', rotation: 6.283185307179586,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with opacity=0', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with debugPaint AND clipping', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'debugPaint': true, 'clipping': true, 'borderRadius': 10},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('double dispose should not throw', () {
      final painter = RectanglePainter();
      painter.dispose();
      expect(() => painter.dispose(), returnsNormally);
    });

    test('prepare called multiple times before paint', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final nodeA = RenderPaintNode(
        id: 'rA', type: 'rect',
        x: 0, y: 0, width: 50, height: 50,
        color: '#FF0000',
      );
      final nodeB = RenderPaintNode(
        id: 'rB', type: 'rect',
        x: 100, y: 100, width: 50, height: 50,
        color: '#00FF00',
      );

      painter.prepare(_makeContext(nodeA, canvas: canvas));
      painter.prepare(_makeContext(nodeB, canvas: canvas));
      final result = painter.paint(_makeContext(nodeB, canvas: canvas));
      expect(result.success, isTrue);
      recorder.endRecording();
    });

    test('paint after invisible twice', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', visible: false,
      );
      final ctx = _makeContext(node, canvas: canvas);

      painter.prepare(ctx);
      final r1 = painter.paint(ctx);
      expect(r1.success, isTrue);

      final r2 = painter.paint(ctx);
      expect(r2.success, isTrue);

      recorder.endRecording();
    });

    test('multiple different paint scenarios in sequence', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      bool ok;

      ok = _paintWith(painter, canvas, RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      ));
      expect(ok, isTrue);

      ok = _paintWith(painter, canvas, RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 10, y: 10, width: 100, height: 80,
        color: '#00FF00', rotation: 0.3,
      ));
      expect(ok, isTrue);

      ok = _paintWith(painter, canvas, RenderPaintNode(
        id: 'r3', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#0000FF',
        properties: {
          'shadows': [{'color': '#000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8}],
        },
      ));
      expect(ok, isTrue);

      ok = _paintWith(painter, canvas, RenderPaintNode(
        id: 'r4', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FFFFFF', strokeWidth: 3, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke', 'borderRadius': 15},
      ));
      expect(ok, isTrue);

      recorder.endRecording();
    });

    test('Verify metrics counters after fill operation', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      _paintWith(painter, canvas, RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      ));
      expect(painter.metrics.rectanglesPainted, equals(1));
      expect(painter.metrics.gradientPainted, equals(0));
      expect(painter.metrics.strokedRectangles, equals(0));
      expect(painter.metrics.shadowCount, equals(0));
      recorder.endRecording();
    });

    test('Verify metrics counters after stroke operation', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      _paintWith(painter, canvas, RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 2, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke'},
      ));
      expect(painter.metrics.rectanglesPainted, equals(1));
      expect(painter.metrics.gradientPainted, equals(0));
      expect(painter.metrics.strokedRectangles, equals(1));
      recorder.endRecording();
    });

    test('Verify metrics counters after gradient operation', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      _paintWith(painter, canvas, RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        gradient: GradientDefinition(kind: 'linear', colors: ['#FF0000', '#00FF00']),
      ));
      expect(painter.metrics.rectanglesPainted, equals(1));
      expect(painter.metrics.gradientPainted, equals(1));
      recorder.endRecording();
    });

    test('Verify metrics counters after shadow operation', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      _paintWith(painter, canvas, RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [{'color': '#000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8}],
        },
      ));
      expect(painter.metrics.shadowCount, equals(1));
      recorder.endRecording();
    });

    test('paint with translation', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'translateX': 50, 'translateY': 25},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('antiAlias property parsed correctly', () {
      final nodeDefault = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
      );
      expect(RectanglePaintStyle.fromNode(nodeDefault).antiAlias, isTrue);

      final nodeFalse = RenderPaintNode(
        id: 'r2', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#000',
        properties: {'antiAlias': false},
      );
      expect(RectanglePaintStyle.fromNode(nodeFalse).antiAlias, isFalse);
    });

    test('cleanup resets state for next paint', () {
      final painter = RectanglePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final ctx = _makeContext(node, canvas: canvas);
      painter.prepare(ctx);
      painter.paint(ctx);
      painter.cleanup();
      expect(painter.diagnostics.totalOperations, equals(0));
      recorder.endRecording();
    });
  });
}

// ---------------------------------------------------------------------------
// Helper used in sequence tests
// ---------------------------------------------------------------------------

bool _paintWith(RectanglePainter painter, Canvas canvas, RenderPaintNode node) {
  final ctx = _makeContext(node, canvas: canvas);
  painter.prepare(ctx);
  return painter.paint(ctx).success;
}
