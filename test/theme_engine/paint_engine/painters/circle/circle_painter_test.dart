import 'dart:ui' show PictureRecorder, Canvas, Color, BlendMode;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/paint_result.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_painter.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_paint_metrics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_paint_options.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_paint_style.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_painter_diagnostics.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

PaintContext _makeContext(RenderPaintNode node, {Canvas? canvas}) {
  return PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'test', name: 'Test'),
    ),
    renderTree: RenderTree(
      canvasWidth: 1000, canvasHeight: 600,
      viewportWidth: 1000, viewportHeight: 600,
      layoutMode: LayoutMode.centered, scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [node]),
    ),
    renderNode: node,
    viewportWidth: 1000, viewportHeight: 600, scaleFactor: 1.0,
  );
}

PaintResult _paintNode(RenderPaintNode node) {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final ctx = _makeContext(node, canvas: canvas);
  final painter = CirclePainter();
  painter.prepare(ctx);
  final result = painter.paint(ctx);
  recorder.endRecording();
  return result;
}

void main() {
  group('CirclePaintStyle', () {
    test('fromNode creates default fill style with color', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final style = CirclePaintStyle.fromNode(node);
      expect(style.fillColor, equals(Color(0xFFFF0000)));
      expect(style.hasFill, isTrue);
      expect(style.hasStroke, isFalse);
      expect(style.hasShadows, isFalse);
    });

    test('fromNode with null color returns null fillColor', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
      );
      final style = CirclePaintStyle.fromNode(node);
      expect(style.fillColor, isNull);
      expect(style.hasFill, isFalse);
    });

    test('fromNode with empty string color returns null fillColor', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '',
      );
      final style = CirclePaintStyle.fromNode(node);
      expect(style.fillColor, isNull);
      expect(style.hasFill, isFalse);
    });

    test('fromNode reads stroke properties (strokeWidth, strokeColor)', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
      );
      final style = CirclePaintStyle.fromNode(node);
      expect(style.strokeWidth, equals(3.0));
      expect(style.strokeColor, equals(Color(0xFF00FF00)));
      expect(style.hasStroke, isTrue);
    });

    test('fromNode reads shadows from properties', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = CirclePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('fromNode reads shadows from model', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 2, offsetY: 2, blurRadius: 4)],
      );
      final style = CirclePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('hasFill returns false when color is null', () {
      const style = CirclePaintStyle();
      expect(style.hasFill, isFalse);
      expect(style.fillColor, isNull);
    });

    test('hasStroke returns true only when strokeWidth > 0 AND strokeColor is not null', () {
      expect(const CirclePaintStyle(strokeWidth: 5, strokeColor: Color(0xFF000000)).hasStroke, isTrue);
      expect(const CirclePaintStyle(strokeWidth: 0, strokeColor: Color(0xFF000000)).hasStroke, isFalse);
      expect(const CirclePaintStyle(strokeWidth: 5).hasStroke, isFalse);
      expect(const CirclePaintStyle(strokeWidth: 0).hasStroke, isFalse);
      expect(const CirclePaintStyle().hasStroke, isFalse);
    });

    test('equality operator works correctly', () {
      final a = const CirclePaintStyle(fillColor: Color(0xFFFF0000), strokeWidth: 2);
      final b = const CirclePaintStyle(fillColor: Color(0xFFFF0000), strokeWidth: 2);
      final c = const CirclePaintStyle(fillColor: Color(0xFF00FF00), strokeWidth: 2);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString returns descriptive string', () {
      const style = CirclePaintStyle(fillColor: Color(0xFFFF0000), strokeWidth: 3);
      final str = style.toString();
      expect(str, contains('CirclePaintStyle'));
      expect(str, contains('fill:'));
      expect(str, contains('stroke:'));
      expect(str, contains('shadows:'));
    });
  });

  group('CirclePaintOptions', () {
    test('fromNode computes center from x,y,width,height', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.cx, equals(50));
      expect(opts.cy, equals(50));
      expect(opts.radius, equals(50));
      expect(opts.visible, isTrue);
    });

    test('fromNode reads explicit cx/cy/radius from properties', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'cx': 100, 'cy': 200, 'radius': 75},
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.cx, equals(100));
      expect(opts.cy, equals(200));
      expect(opts.radius, equals(75));
    });

    test('center computation uses width/2, height/2 correctly', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 10, y: 20, width: 100, height: 200,
        color: '#FF0000',
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.cx, equals(60));
      expect(opts.cy, equals(120));
      expect(opts.radius, equals(50));
    });

    test('computePaintBounds includes stroke inflation', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 50, y: 50, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 10, strokeColor: '#000',
      );
      final opts = CirclePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
      expect(bounds.height, greaterThan(100));
    });

    test('computePaintBounds includes shadows', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000', offsetX: 10, offsetY: 10, blurRadius: 5)],
      );
      final opts = CirclePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.right, greaterThan(100));
      expect(bounds.bottom, greaterThan(100));
    });

    test('computePaintBounds includes rotation', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        rotation: 0.5,
      );
      final opts = CirclePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
      expect(bounds.height, greaterThan(100));
    });

    test('computePaintBounds with scaleX', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleX: 2.0,
      );
      final opts = CirclePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, closeTo(200, 1));
    });

    test('computePaintBounds with scaleY', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleY: 2.0,
      );
      final opts = CirclePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.height, closeTo(200, 1));
    });

    test('debugPaint flag read from properties', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'debugPaint': true},
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.debugPaint, isTrue);
    });

    test('hitTestBounds read correctly from properties', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'hitTestBounds': {'x': -5, 'y': -5, 'width': 110, 'height': 110},
        },
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNotNull);
      expect(opts.hitTestBounds!.left, equals(-5));
      expect(opts.hitTestBounds!.width, equals(110));
    });

    test('hitTestBounds returns null when properties missing', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNull);
    });

    test('hitTestBounds returns null when properties missing coordinates', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'hitTestBounds': {'x': 10}},
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNull);
    });

    test('visible defaults to true', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.visible, isTrue);
    });

    test('visible false when node visible is false', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', visible: false,
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.visible, isFalse);
    });

    test('opacity from node', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0.5,
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.opacity, equals(0.5));
    });

    test('opacity defaults to 1.0', () {
      const opts = CirclePaintOptions(cx: 50, cy: 50, radius: 50, style: CirclePaintStyle());
      expect(opts.opacity, equals(1.0));
    });

    test('rotation from node', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', rotation: 0.3,
      );
      final opts = CirclePaintOptions.fromNode(node);
      expect(opts.rotation, equals(0.3));
    });

    test('toString returns descriptive string', () {
      const style = CirclePaintStyle(fillColor: Color(0xFFFF0000));
      const opts = CirclePaintOptions(cx: 50, cy: 50, radius: 30, style: style);
      final str = opts.toString();
      expect(str, contains('CirclePaintOptions'));
      expect(str, contains('center:'));
      expect(str, contains('radius:'));
    });
  });

  group('CirclePaintMetrics', () {
    test('records all counters correctly', () {
      final m = CirclePaintMetrics();
      m.recordCircle(1000);
      m.recordStroke();
      m.recordShadow();
      m.recordCacheHit();
      m.recordCacheMiss();
      m.recordDuration(const Duration(milliseconds: 5));
      expect(m.circlesPainted, equals(1));
      expect(m.strokedCircles, equals(1));
      expect(m.shadowCount, equals(1));
      expect(m.cacheHits, equals(1));
      expect(m.cacheMisses, equals(1));
      expect(m.paintDuration.inMilliseconds, equals(5));
    });

    test('reset clears all counters', () {
      final m = CirclePaintMetrics();
      m.recordCircle(500);
      m.recordStroke();
      m.recordDuration(const Duration(milliseconds: 10));
      m.reset();
      expect(m.circlesPainted, equals(0));
      expect(m.strokedCircles, equals(0));
      expect(m.paintDuration, equals(Duration.zero));
    });

    test('copy creates independent clone', () {
      final m = CirclePaintMetrics();
      m.recordCircle(200);
      final c = m.copy();
      c.recordCircle(300);
      expect(m.circlesPainted, equals(1));
      expect(c.circlesPainted, equals(2));
    });

    test('operator+ merges correctly', () {
      final a = CirclePaintMetrics();
      a.recordCircle(100);
      a.recordStroke();
      final b = CirclePaintMetrics();
      b.recordCircle(200);
      b.recordShadow();
      final sum = a + b;
      expect(sum.circlesPainted, equals(2));
      expect(sum.strokedCircles, equals(1));
      expect(sum.shadowCount, equals(1));
    });

    test('operator+ does not modify operands', () {
      final a = CirclePaintMetrics();
      a.recordCircle(100);
      final b = CirclePaintMetrics();
      b.recordCircle(200);
      a + b;
      expect(a.circlesPainted, equals(1));
      expect(b.circlesPainted, equals(1));
    });

    test('averagePaintTimeMs returns 0 when no circles', () {
      final m = CirclePaintMetrics();
      expect(m.averagePaintTimeMs, equals(0));
    });

    test('averagePaintTimeMs computes correctly', () {
      final m = CirclePaintMetrics();
      m.recordCircle(100);
      m.recordDuration(const Duration(milliseconds: 10));
      m.recordCircle(200);
      m.recordDuration(const Duration(milliseconds: 20));
      expect(m.averagePaintTimeMs, closeTo(15.0, 0.01));
    });

    test('totalArea accumulates across circles', () {
      final m = CirclePaintMetrics();
      m.recordCircle(100);
      m.recordCircle(200);
      m.recordCircle(300);
      expect(m.totalArea, closeTo(600.0, 0.01));
    });

    test('large number of records', () {
      final m = CirclePaintMetrics();
      for (var i = 0; i < 10000; i++) {
        m.recordCircle(i.toDouble());
        m.recordStroke();
      }
      expect(m.circlesPainted, equals(10000));
      expect(m.strokedCircles, equals(10000));
      expect(m.totalArea, greaterThan(0));
    });
  });

  group('CirclePainterDiagnostics', () {
    test('records operations', () {
      final d = CirclePainterDiagnostics();
      d.recordOperation('drawCircle');
      expect(d.totalOperations, equals(1));
    });

    test('records warnings and errors', () {
      final d = CirclePainterDiagnostics();
      d.recordWarning('Low memory');
      d.recordError('Canvas null');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isTrue);
    });

    test('records allocations', () {
      final d = CirclePainterDiagnostics();
      d.recordAllocation();
      d.recordAllocation();
      d.recordAllocation();
      expect(d.memoryAllocations, equals(3));
    });

    test('reset clears everything', () {
      final d = CirclePainterDiagnostics();
      d.recordOperation('draw');
      d.recordWarning('test');
      d.recordError('test');
      d.recordAllocation();
      d.reset();
      expect(d.totalOperations, equals(0));
      expect(d.hasWarnings, isFalse);
      expect(d.hasErrors, isFalse);
      expect(d.memoryAllocations, equals(0));
    });

    test('merge combines diagnostics', () {
      final a = CirclePainterDiagnostics();
      a.recordOperation('draw');
      a.recordWarning('warn a');
      a.recordError('err a');
      final b = CirclePainterDiagnostics();
      b.recordOperation('shadow');
      b.recordAllocation();
      a.merge(b);
      expect(a.totalOperations, equals(2));
      expect(a.warnings.length, equals(1));
      expect(a.errors.length, equals(1));
      expect(a.memoryAllocations, equals(1));
    });

    test('totalDuration with multiple ops', () {
      final d = CirclePainterDiagnostics();
      d.recordOperation('save', duration: const Duration(microseconds: 10));
      d.recordOperation('draw', duration: const Duration(microseconds: 50));
      d.recordOperation('restore', duration: const Duration(microseconds: 5));
      expect(d.totalDuration.inMicroseconds, equals(65));
    });

    test('totalDuration is zero when no ops', () {
      final d = CirclePainterDiagnostics();
      expect(d.totalDuration, equals(Duration.zero));
    });

    test('hasWarnings and hasErrors getters work correctly', () {
      final d = CirclePainterDiagnostics();
      expect(d.hasWarnings, isFalse);
      expect(d.hasErrors, isFalse);
      d.recordWarning('w');
      expect(d.hasWarnings, isTrue);
      d.recordError('e');
      expect(d.hasErrors, isTrue);
    });

    test('recordSkipped adds to skipped list', () {
      final d = CirclePainterDiagnostics();
      d.recordSkipped('Not visible');
      expect(d.skipped.length, equals(1));
    });
  });

  group('CirclePainter', () {
    test('canPaint returns true for circle type', () {
      final painter = CirclePainter();
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'circle')), isTrue);
    });

    test('canPaint returns false for non-circle types', () {
      final painter = CirclePainter();
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'rect')), isFalse);
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'text')), isFalse);
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'image')), isFalse);
    });

    test('type returns circle', () {
      expect(CirclePainter().type, equals('circle'));
    });

    test('capabilities supports required features', () {
      final caps = CirclePainter().capabilities;
      expect(caps.supportsOpacity, isTrue);
      expect(caps.supportsTransform, isTrue);
      expect(caps.supportsStroke, isTrue);
      expect(caps.supportsShadow, isTrue);
      expect(caps.supportsBlendMode, isTrue);
      expect(caps.supportsGradient, isTrue);
      expect(caps.supportsClipping, isTrue);
    });

    test('paint returns success for basic filled circle', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
      expect(result.elementType, equals('circle'));
      expect(result.paintBounds, isNotNull);
    });

    test('paint returns success for stroked circle', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for transparent circle', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0.5,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for rotated circle', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', rotation: 0.3,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for scaled circle', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 50, height: 50,
        color: '#FF0000', scaleX: 2.0, scaleY: 1.5,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for shadow circle', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for invisible circle (skipped)', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', visible: false,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns failure when canvas is null', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final ctx = _makeContext(node);
      final painter = CirclePainter();
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('paint with opacity=0', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0.0,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with scaleX=0 (degenerate)', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', scaleX: 0.0,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with huge strokeWidth', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 100, strokeColor: '#0000FF',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with 2*PI rotation', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', rotation: 6.283185307179586,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with explicit cx/cy/radius', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 200, height: 200,
        color: '#FF0000',
        properties: {'cx': 100, 'cy': 150, 'radius': 40},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('metrics accumulate across multiple paint calls', () {
      final painter = CirclePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node1 = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final ctx1 = _makeContext(node1, canvas: canvas);
      painter.prepare(ctx1);
      painter.paint(ctx1);

      final node2 = RenderPaintNode(
        id: 'c2', type: 'circle',
        x: 0, y: 0, width: 50, height: 50,
        color: '#00FF00',
      );
      final ctx2 = _makeContext(node2, canvas: canvas);
      painter.prepare(ctx2);
      painter.paint(ctx2);

      recorder.endRecording();
      expect(painter.metrics.circlesPainted, equals(2));
      expect(painter.metrics.totalArea, greaterThan(0));
    });

    test('dispose cleans up', () {
      final painter = CirclePainter();
      painter.prepare(_makeContext(
        RenderPaintNode(id: 'c', type: 'circle', x: 0, y: 0, width: 10, height: 10, color: '#000'),
        canvas: Canvas(PictureRecorder()),
      ));
      painter.dispose();
      expect(painter.metrics.circlesPainted, equals(0));
      expect(painter.diagnostics.totalOperations, equals(0));
    });

    test('lifecycle: initialize → prepare → paint → cleanup', () {
      final painter = CirclePainter();
      painter.initialize();
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
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

    test('debug paint draws overlays', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'debugPaint': true},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('multiple shadows paint successfully', () {
      final node = RenderPaintNode(
        id: 'c1', type: 'circle',
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

    test('prepare called multiple times before paint', () {
      final painter = CirclePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node1 = RenderPaintNode(
        id: 'c1', type: 'circle',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final node2 = RenderPaintNode(
        id: 'c2', type: 'circle',
        x: 0, y: 0, width: 50, height: 50,
        color: '#00FF00',
      );

      final ctx1 = _makeContext(node1, canvas: canvas);
      painter.prepare(ctx1);
      final ctx2 = _makeContext(node2, canvas: canvas);
      painter.prepare(ctx2);
      final result = painter.paint(ctx2);
      recorder.endRecording();
      expect(result.success, isTrue);
    });
  });
}
