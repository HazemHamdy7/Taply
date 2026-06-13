import 'dart:ui' show PictureRecorder, Canvas, Offset, Rect, Color, BlendMode;

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

    test('blend mode parsing covers all values', () {
      for (final entry in [
        ('multiply', BlendMode.multiply),
        ('screen', BlendMode.screen),
        ('overlay', BlendMode.overlay),
        ('darken', BlendMode.darken),
        ('srcOver', BlendMode.srcOver),
      ]) {
        final node = RenderPaintNode(
          id: 'r', type: 'rect', x: 0, y: 0, width: 10, height: 10,
          color: '#000',
          properties: {'blendMode': entry.$1},
        );
        final style = RectanglePaintStyle.fromNode(node);
        expect(style.blendMode, equals(entry.$2), reason: 'blendMode=${entry.$1}');
      }
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
  });
}
