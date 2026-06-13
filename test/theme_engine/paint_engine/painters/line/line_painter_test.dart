import 'dart:ui' show PictureRecorder, Canvas, Color, StrokeCap;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/paint_result.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_painter.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_paint_metrics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_paint_options.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_paint_style.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_painter_diagnostics.dart';
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
  final painter = LinePainter();
  painter.prepare(ctx);
  final result = painter.paint(ctx);
  recorder.endRecording();
  return result;
}

void main() {
  group('LinePaintStyle', () {
    test('fromNode creates default line style with color', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final style = LinePaintStyle.fromNode(node);
      expect(style.lineColor, equals(Color(0xFFFF0000)));
      expect(style.hasLine, isTrue);
      expect(style.hasShadows, isFalse);
      expect(style.strokeWidth, equals(1.0));
      expect(style.strokeCap, equals(StrokeCap.butt));
    });

    test('fromNode with null color returns null lineColor (hasLine false)', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
      );
      final style = LinePaintStyle.fromNode(node);
      expect(style.lineColor, isNull);
      expect(style.hasLine, isFalse);
    });

    test('fromNode reads strokeWidth', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3.0,
      );
      final style = LinePaintStyle.fromNode(node);
      expect(style.strokeWidth, equals(3.0));
    });

    test('fromNode reads strokeCap (butt, round, square)', () {
      final buttNode = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'strokeCap': 'butt'},
      );
      expect(LinePaintStyle.fromNode(buttNode).strokeCap, equals(StrokeCap.butt));

      final roundNode = RenderPaintNode(
        id: 'l2', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'strokeCap': 'round'},
      );
      expect(LinePaintStyle.fromNode(roundNode).strokeCap, equals(StrokeCap.round));

      final squareNode = RenderPaintNode(
        id: 'l3', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'strokeCap': 'square'},
      );
      expect(LinePaintStyle.fromNode(squareNode).strokeCap, equals(StrokeCap.square));
    });

    test('fromNode reads shadows from properties', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = LinePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
      expect(style.shadows[0].offsetX, equals(4));
      expect(style.shadows[0].offsetY, equals(4));
      expect(style.shadows[0].blurRadius, equals(8));
      expect(style.shadows[0].opacity, equals(0.4));
    });

    test('fromNode reads shadows from model', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final style = LinePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('hasLine returns true only when lineColor != null AND strokeWidth > 0', () {
      expect(const LinePaintStyle().hasLine, isFalse);
      expect(const LinePaintStyle(lineColor: Color(0xFFFF0000), strokeWidth: 0).hasLine, isFalse);
      expect(const LinePaintStyle(lineColor: Color(0xFFFF0000), strokeWidth: 1).hasLine, isTrue);
    });

    test('equality operator', () {
      final a = LinePaintStyle(lineColor: Color(0xFFFF0000), strokeWidth: 2.0);
      final b = LinePaintStyle(lineColor: Color(0xFFFF0000), strokeWidth: 2.0);
      final c = LinePaintStyle(lineColor: Color(0xFF0000FF), strokeWidth: 2.0);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString', () {
      final style = LinePaintStyle(lineColor: Color(0xFFFF0000), strokeWidth: 2.0);
      final str = style.toString();
      expect(str, contains('LinePaintStyle'));
      expect(str, contains('width: 2.0'));
      expect(str, contains('butt'));
      expect(str, contains('shadows: 0'));
    });
  });

  group('LinePaintOptions', () {
    test('fromNode computes start/end from x,y,width,height', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 10, y: 20, width: 200, height: 150,
        color: '#FF0000',
      );
      final opts = LinePaintOptions.fromNode(node);
      expect(opts.startX, equals(10));
      expect(opts.startY, equals(20));
      expect(opts.endX, equals(210));
      expect(opts.endY, equals(170));
    });

    test('fromNode reads explicit startX/startY/endX/endY from properties', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'startX': 50, 'startY': 60, 'endX': 250, 'endY': 300},
      );
      final opts = LinePaintOptions.fromNode(node);
      expect(opts.startX, equals(50));
      expect(opts.startY, equals(60));
      expect(opts.endX, equals(250));
      expect(opts.endY, equals(300));
    });

    test('computePaintBounds includes stroke half-width', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000', strokeWidth: 10,
      );
      final opts = LinePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.left, equals(-5.0));
      expect(bounds.right, equals(105.0));
      expect(bounds.top, equals(-5.0));
      expect(bounds.bottom, equals(5.0));
    });

    test('computePaintBounds includes shadows', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 10, 'offsetY': 10, 'blurRadius': 5, 'opacity': 0.3},
          ],
        },
      );
      final opts = LinePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.right, greaterThanOrEqualTo(110));
      expect(bounds.bottom, greaterThanOrEqualTo(10));
    });

    test('computePaintBounds includes rotation', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000', rotation: 1.0,
      );
      final opts = LinePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('cx returns midpoint X', () {
      final opts = LinePaintOptions(
        startX: 10, startY: 20, endX: 210, endY: 170,
        style: const LinePaintStyle(lineColor: Color(0xFFFF0000)),
      );
      expect(opts.cx, equals(110));
    });

    test('cy returns midpoint Y', () {
      final opts = LinePaintOptions(
        startX: 10, startY: 20, endX: 210, endY: 170,
        style: const LinePaintStyle(lineColor: Color(0xFFFF0000)),
      );
      expect(opts.cy, equals(95));
    });

    test('debugPaint flag', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000',
        properties: {'debugPaint': true},
      );
      final opts = LinePaintOptions.fromNode(node);
      expect(opts.debugPaint, isTrue);
    });

    test('hitTestBounds reading', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000',
        properties: {
          'hitTestBounds': {'x': -10, 'y': -5, 'width': 120, 'height': 20},
        },
      );
      final opts = LinePaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNotNull);
      expect(opts.hitTestBounds!.left, equals(-10));
      expect(opts.hitTestBounds!.top, equals(-5));
      expect(opts.hitTestBounds!.width, equals(120));
      expect(opts.hitTestBounds!.height, equals(20));
    });

    test('visible defaults to true', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000',
      );
      final opts = LinePaintOptions.fromNode(node);
      expect(opts.visible, isTrue);
    });
  });

  group('LinePaintMetrics', () {
    test('records all counters', () {
      final m = LinePaintMetrics();
      m.recordLine(100);
      m.recordShadow();
      m.recordCacheHit();
      m.recordCacheMiss();
      m.recordDuration(const Duration(milliseconds: 3));
      expect(m.linesPainted, equals(1));
      expect(m.shadowCount, equals(1));
      expect(m.cacheHits, equals(1));
      expect(m.cacheMisses, equals(1));
      expect(m.totalLength, equals(100));
    });

    test('reset clears all counters', () {
      final m = LinePaintMetrics();
      m.recordLine(50);
      m.recordShadow();
      m.recordDuration(const Duration(milliseconds: 5));
      m.reset();
      expect(m.linesPainted, equals(0));
      expect(m.shadowCount, equals(0));
      expect(m.totalLength, equals(0));
      expect(m.paintDuration, equals(Duration.zero));
    });

    test('copy creates independent clone', () {
      final m = LinePaintMetrics();
      m.recordLine(200);
      final c = m.copy();
      c.recordLine(300);
      expect(m.linesPainted, equals(1));
      expect(c.linesPainted, equals(2));
      expect(m.totalLength, equals(200));
      expect(c.totalLength, equals(500));
    });

    test('operator+ merges correctly', () {
      final a = LinePaintMetrics();
      a.recordLine(100);
      a.recordShadow();
      final b = LinePaintMetrics();
      b.recordLine(200);
      b.recordCacheHit();
      final sum = a + b;
      expect(sum.linesPainted, equals(2));
      expect(sum.shadowCount, equals(1));
      expect(sum.cacheHits, equals(1));
      expect(sum.totalLength, equals(300));
    });

    test('averagePaintTimeMs returns 0 when no lines painted', () {
      expect(LinePaintMetrics().averagePaintTimeMs, equals(0));
    });

    test('averagePaintTimeMs computes correctly', () {
      final m = LinePaintMetrics();
      m.recordDuration(const Duration(milliseconds: 10));
      m.recordLine(100);
      expect(m.averagePaintTimeMs, equals(10.0));
    });

    test('totalLength accumulates across recordLine calls', () {
      final m = LinePaintMetrics();
      m.recordLine(50);
      m.recordLine(75);
      m.recordLine(25);
      expect(m.totalLength, equals(150.0));
    });
  });

  group('LinePainterDiagnostics', () {
    test('records operations', () {
      final d = LinePainterDiagnostics();
      d.recordOperation('drawLine');
      d.recordOperation('save');
      expect(d.totalOperations, equals(2));
    });

    test('records warnings and errors', () {
      final d = LinePainterDiagnostics();
      d.recordWarning('Low memory');
      d.recordError('Canvas null');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isTrue);
      expect(d.warnings.length, equals(1));
      expect(d.errors.length, equals(1));
    });

    test('records allocations', () {
      final d = LinePainterDiagnostics();
      d.recordAllocation();
      d.recordAllocation();
      d.recordAllocation();
      expect(d.memoryAllocations, equals(3));
    });

    test('reset clears everything', () {
      final d = LinePainterDiagnostics();
      d.recordOperation('draw');
      d.recordWarning('warn');
      d.recordError('err');
      d.recordAllocation();
      d.reset();
      expect(d.totalOperations, equals(0));
      expect(d.warnings.length, equals(0));
      expect(d.errors.length, equals(0));
      expect(d.memoryAllocations, equals(0));
    });

    test('merge combines diagnostics from another instance', () {
      final a = LinePainterDiagnostics();
      a.recordOperation('op1');
      a.recordWarning('warn1');
      a.recordAllocation();
      final b = LinePainterDiagnostics();
      b.recordOperation('op2');
      b.recordError('err1');
      a.merge(b);
      expect(a.totalOperations, equals(2));
      expect(a.warnings.length, equals(1));
      expect(a.errors.length, equals(1));
      expect(a.memoryAllocations, equals(1));
    });

    test('totalDuration sums operation durations', () {
      final d = LinePainterDiagnostics();
      d.recordOperation('a', duration: const Duration(milliseconds: 5));
      d.recordOperation('b', duration: const Duration(milliseconds: 3));
      expect(d.totalDuration.inMilliseconds, equals(8));
    });

    test('hasWarnings/hasErrors reflect state', () {
      final d = LinePainterDiagnostics();
      expect(d.hasWarnings, isFalse);
      expect(d.hasErrors, isFalse);
      d.recordWarning('test');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isFalse);
      d.recordError('err');
      expect(d.hasErrors, isTrue);
    });
  });

  group('LinePainter', () {
    test('canPaint returns true for line type', () {
      final painter = LinePainter();
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'line')), isTrue);
    });

    test('canPaint returns false for non-line types', () {
      final painter = LinePainter();
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'circle')), isFalse);
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'rect')), isFalse);
      expect(painter.canPaint(const RenderPaintNode(id: 't', type: 'text')), isFalse);
    });

    test('type returns line', () {
      expect(LinePainter().type, equals('line'));
    });

    test('capabilities', () {
      final caps = LinePainter().capabilities;
      expect(caps.supportsOpacity, isTrue);
      expect(caps.supportsTransform, isTrue);
      expect(caps.supportsStroke, isTrue);
      expect(caps.supportsShadow, isTrue);
      expect(caps.supportsBlendMode, isTrue);
      expect(caps.supportsGradient, isFalse);
      expect(caps.supportsClipping, isFalse);
    });

    test('paint returns success for basic line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 10, y: 10, width: 200, height: 100,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
      expect(result.elementType, equals('line'));
      expect(result.paintBounds, isNotNull);
    });

    test('paint returns success for thick line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 200, height: 0,
        color: '#0000FF', strokeWidth: 8,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for transparent line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0.5,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for rotated line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 50, y: 50, width: 100, height: 0,
        color: '#FF0000', rotation: 0.3,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for scaled line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000', scaleX: 2.0, scaleY: 1.0,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for shadow line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for invisible line (skipped)', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', visible: false,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns failure when canvas is null', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final ctx = _makeContext(node);
      final painter = LinePainter();
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('paint with vertical line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 50, y: 0, width: 0, height: 200,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with horizontal line', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 50, width: 200, height: 0,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with zero-length line (start == end)', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 100, y: 100, width: 0, height: 0,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with negative coordinates', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: -100, y: -50, width: 200, height: 100,
        color: '#FF0000',
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with opacity=0', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', opacity: 0,
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('metrics accumulate across paint calls', () {
      final painter = LinePainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node1 = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000',
      );
      final ctx1 = _makeContext(node1, canvas: canvas);
      painter.prepare(ctx1);
      painter.paint(ctx1);

      final node2 = RenderPaintNode(
        id: 'l2', type: 'line',
        x: 0, y: 50, width: 50, height: 50,
        color: '#00FF00',
      );
      final ctx2 = _makeContext(node2, canvas: canvas);
      painter.prepare(ctx2);
      painter.paint(ctx2);

      recorder.endRecording();
      expect(painter.metrics.linesPainted, equals(2));
      expect(painter.metrics.totalLength, greaterThan(0));
    });

    test('dispose cleans up state', () {
      final painter = LinePainter();
      painter.prepare(_makeContext(
        RenderPaintNode(id: 'l', type: 'line', x: 0, y: 0, width: 10, height: 10, color: '#000'),
      ));
      painter.dispose();
      expect(painter.metrics.linesPainted, equals(0));
      expect(painter.diagnostics.totalOperations, equals(0));
    });

    test('lifecycle: initialize -> prepare -> paint -> cleanup', () {
      final painter = LinePainter();
      painter.initialize();
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
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
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 0,
        color: '#FF0000',
        properties: {'debugPaint': true},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with multiple shadows', () {
      final node = RenderPaintNode(
        id: 'l1', type: 'line',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.3},
            {'color': '#000000', 'offsetX': -4, 'offsetY': -4, 'blurRadius': 4, 'opacity': 0.2},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });
  });
}
