import 'dart:ui' show PictureRecorder, Canvas, BlendMode, TileMode;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/paint_result.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_painter.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_paint_metrics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_paint_options.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_paint_style.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_painter_diagnostics.dart';
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
  final painter = GradientPainter();
  painter.prepare(ctx);
  final result = painter.paint(ctx);
  recorder.endRecording();
  return result;
}

void main() {
  group('GradientPaintStyle', () {
    test('fromNode creates linear gradient style', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
        },
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.gradientKind, equals('linear'));
      expect(style.hasGradient, isTrue);
      expect(style.colors.length, equals(2));
    });

    test('fromNode creates radial gradient style', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'radial',
          'gradientColors': ['#00FF00', '#0000FF'],
        },
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.gradientKind, equals('radial'));
      expect(style.hasGradient, isTrue);
    });

    test('fromNode creates sweep gradient style', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'sweep',
          'gradientColors': ['#FF0000', '#FFFF00', '#00FF00'],
        },
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.gradientKind, equals('sweep'));
      expect(style.hasGradient, isTrue);
    });

    test('fromNode with no colors returns no gradient', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear'},
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.hasGradient, isFalse);
    });

    test('fromNode reads tileMode from properties', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
          'tileMode': 'repeated',
        },
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.tileMode, equals(TileMode.repeated));
    });

    test('fromNode reads shadows from properties', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('fromNode reads shadows from model', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
        },
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 2, offsetY: 2, blurRadius: 4, opacity: 0.3)],
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('blendMode defaults to srcOver', () {
      final node = RenderPaintNode(
        id: 'g1', type: 'gradient',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
        },
      );
      final style = GradientPaintStyle.fromNode(node);
      expect(style.blendMode, equals(BlendMode.srcOver));
    });

    test('equality operator', () {
      final node1 = RenderPaintNode(id: 'a', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final node2 = RenderPaintNode(id: 'b', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      expect(GradientPaintStyle.fromNode(node1), equals(GradientPaintStyle.fromNode(node2)));
    });

    test('toString returns descriptive string', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final style = GradientPaintStyle.fromNode(node);
      expect(style.toString(), contains('linear'));
    });
  });

  group('GradientPaintOptions', () {
    test('fromNode creates basic gradient rect', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 10, y: 20, width: 200, height: 150,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final opts = GradientPaintOptions.fromNode(node);
      expect(opts.rect.left, equals(10));
      expect(opts.rect.top, equals(20));
      expect(opts.rect.width, equals(200));
      expect(opts.rect.height, equals(150));
    });

    test('fromNode reads borderRadius', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'], 'borderRadius': 10});
      final opts = GradientPaintOptions.fromNode(node);
      expect(opts.borderRadius, equals(10));
      expect(opts.hasBorderRadius, isTrue);
    });

    test('fromNode reads individual corner radii', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'],
          'borderRadiusTL': 5, 'borderRadiusTR': 10, 'borderRadiusBR': 15, 'borderRadiusBL': 20});
      final opts = GradientPaintOptions.fromNode(node);
      expect(opts.borderRadiusTL, equals(5));
      expect(opts.borderRadiusTR, equals(10));
      expect(opts.borderRadiusBR, equals(15));
      expect(opts.borderRadiusBL, equals(20));
    });

    test('computePaintBounds includes shadows', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'],
          'shadows': [{'color': '#000000', 'offsetX': 10, 'offsetY': 10, 'blurRadius': 5, 'opacity': 0.3}]});
      final opts = GradientPaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
    });

    test('computePaintBounds includes rotation', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        rotation: 0.5,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final opts = GradientPaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
    });

    test('opacity and rotation read from node', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        opacity: 0.5, rotation: 0.3,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final opts = GradientPaintOptions.fromNode(node);
      expect(opts.opacity, equals(0.5));
      expect(opts.rotation, equals(0.3));
    });

    test('visible defaults to true', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final opts = GradientPaintOptions.fromNode(node);
      expect(opts.visible, isTrue);
    });

    test('toString returns descriptive string', () {
      final node = RenderPaintNode(id: 'g1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final opts = GradientPaintOptions.fromNode(node);
      expect(opts.toString(), contains('GradientPaintOptions'));
    });
  });

  group('GradientPaintMetrics', () {
    test('records all counters correctly', () {
      final m = GradientPaintMetrics();
      m.recordGradient(100, 'linear');
      m.recordShadow();
      m.recordCacheHit();
      expect(m.gradientsPainted, equals(1));
      expect(m.linearCount, equals(1));
      expect(m.shadowCount, equals(1));
      expect(m.cacheHits, equals(1));
    });

    test('reset clears all counters', () {
      final m = GradientPaintMetrics();
      m.recordGradient(100, 'linear');
      m.reset();
      expect(m.gradientsPainted, equals(0));
    });

    test('copy creates independent clone', () {
      final m = GradientPaintMetrics();
      m.recordGradient(100, 'linear');
      final c = m.copy();
      expect(c.gradientsPainted, equals(1));
      m.recordGradient(50, 'radial');
      expect(c.gradientsPainted, equals(1));
    });

    test('operator+ merges correctly', () {
      final a = GradientPaintMetrics();
      a.recordGradient(100, 'linear');
      final b = GradientPaintMetrics();
      b.recordGradient(50, 'sweep');
      b.recordShadow();
      final c = a + b;
      expect(c.gradientsPainted, equals(2));
      expect(c.linearCount, equals(1));
      expect(c.sweepCount, equals(1));
      expect(c.shadowCount, equals(1));
    });

    test('averagePaintTimeMs returns 0 when no gradients', () {
      expect(GradientPaintMetrics().averagePaintTimeMs, equals(0));
    });
  });

  group('GradientPainterDiagnostics', () {
    test('records operations', () {
      final d = GradientPainterDiagnostics();
      d.recordOperation('canvas.save');
      expect(d.totalOperations, equals(1));
    });

    test('records warnings and errors', () {
      final d = GradientPainterDiagnostics();
      d.recordWarning('test warning');
      d.recordError('test error');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isTrue);
    });

    test('reset clears everything', () {
      final d = GradientPainterDiagnostics();
      d.recordOperation('canvas.save');
      d.recordError('error');
      d.reset();
      expect(d.totalOperations, equals(0));
      expect(d.hasErrors, isFalse);
    });

    test('merge combines diagnostics', () {
      final a = GradientPainterDiagnostics();
      a.recordOperation('op1');
      final b = GradientPainterDiagnostics();
      b.recordError('err');
      a.merge(b);
      expect(a.totalOperations, equals(1));
      expect(a.hasErrors, isTrue);
    });
  });

  group('GradientPainter', () {
    test('canPaint returns true for gradient type', () {
      final painter = GradientPainter();
      final node = RenderPaintNode(id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      expect(painter.canPaint(node), isTrue);
    });

    test('canPaint returns false for non-gradient types', () {
      final painter = GradientPainter();
      final node = RenderPaintNode(id: 'n1', type: 'rect', x: 0, y: 0, width: 100, height: 100);
      expect(painter.canPaint(node), isFalse);
    });

    test('type returns gradient', () {
      expect(GradientPainter().type, equals('gradient'));
    });

    test('capabilities is advanced', () {
      expect(GradientPainter().capabilities.supportsGradient, isTrue);
    });

    test('paint returns success for linear gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for radial gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'radial', 'gradientColors': ['#00FF00', '#0000FF']},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for sweep gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'sweep', 'gradientColors': ['#FF0000', '#FFFF00', '#00FF00']},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for empty gradient (no colors)', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear'},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for rounded gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'], 'borderRadius': 20},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for rotated gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        rotation: 0.3,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for scaled gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        scaleX: 1.5, scaleY: 1.5,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for shadow gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'],
          'shadows': [{'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4}]},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for invisible gradient (skipped)', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        visible: false,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns failure when canvas is null', () {
      final node = RenderPaintNode(id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final ctx = _makeContext(node);
      final painter = GradientPainter();
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('paint with opacity=0', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        opacity: 0,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']},
      ));
      expect(result.success, isTrue);
    });

    test('metrics accumulate across paint calls', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = GradientPainter();
      for (var i = 0; i < 3; i++) {
        final node = RenderPaintNode(id: 'n$i', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
          properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
        final ctx = _makeContext(node, canvas: canvas);
        painter.prepare(ctx);
        painter.paint(ctx);
      }
      expect(painter.metrics.gradientsPainted, equals(3));
    });

    test('dispose cleans up', () {
      final painter = GradientPainter();
      painter.initialize();
      painter.dispose();
      expect(painter.metrics.gradientsPainted, equals(0));
    });

    test('lifecycle: initialize -> prepare -> paint -> cleanup', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = GradientPainter();
      painter.initialize();
      final node = RenderPaintNode(id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final ctx = _makeContext(node, canvas: canvas);
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      painter.cleanup();
      expect(result.success, isTrue);
    });

    test('debug paint draws overlays', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'], 'debugPaint': true},
      ));
      expect(result.success, isTrue);
    });

    test('clipped gradient paints successfully', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'], 'clipping': true, 'borderRadius': 10},
      ));
      expect(result.success, isTrue);
    });

    test('multi-color stops gradient', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#FFFF00', '#00FF00'],
          'gradientStops': [0.0, 0.5, 1.0]},
      ));
      expect(result.success, isTrue);
    });

    test('radial with explicit center and radius', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'radial', 'gradientColors': ['#00FF00', '#0000FF'],
          'centerX': 50, 'centerY': 50, 'gradientRadius': 60},
      ));
      expect(result.success, isTrue);
    });

    test('sweep with start/end angles', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'sweep', 'gradientColors': ['#FF0000', '#0000FF'],
          'startAngle': 0, 'endAngle': 180},
      ));
      expect(result.success, isTrue);
    });

    test('multiple shadows paint successfully', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'],
          'shadows': [
            {'color': '#000000', 'offsetX': 2, 'offsetY': 2, 'blurRadius': 4, 'opacity': 0.3},
            {'color': '#000000', 'offsetX': 6, 'offsetY': 6, 'blurRadius': 12, 'opacity': 0.2},
          ]},
      ));
      expect(result.success, isTrue);
    });

    test('prepare called multiple times before paint', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = GradientPainter();
      final node1 = RenderPaintNode(id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']});
      final node2 = RenderPaintNode(id: 'n2', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {'gradientKind': 'radial', 'gradientColors': ['#00FF00', '#0000FF']});
      var ctx = _makeContext(node1, canvas: canvas);
      painter.prepare(ctx);
      ctx = _makeContext(node2, canvas: canvas);
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isTrue);
    });

    test('demo runs without exceptions', () {
      expect(runGradientPainterDemo(), contains('Demo Complete'));
    });

    test('paint with all properties empty (defaults)', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'gradient', x: 0, y: 0, width: 100, height: 100,
        properties: {},
      ));
      expect(result.success, isTrue);
    });
  });
}
