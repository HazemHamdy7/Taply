import 'dart:ui' show PictureRecorder, Canvas, Rect;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart' show TextAlign, TextDirection, FontWeight;

import 'package:business_card/theme_engine/paint_engine/painters/text/text_paint_style.dart';
import 'package:business_card/theme_engine/paint_engine/painters/text/text_paint_options.dart';
import 'package:business_card/theme_engine/paint_engine/painters/text/text_paint_metrics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/text/text_painter_diagnostics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/text/text_painter.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

void main() {
  group('TextPaintStyle', () {
    test('fromNode parses basic text', () {
      final node = RenderPaintNode(
        id: 't1', type: 'text',
        x: 10, y: 20, width: 200, height: 50,
        properties: {
          'text': 'Hello',
          'fontSize': 16,
          'color': '#FF0000',
        },
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.text, 'Hello');
      expect(style.fontSize, 16.0);
      expect(style.color, isNotNull);
    });

    test('fromNode parses RTL Arabic text', () {
      final node = RenderPaintNode(
        id: 't2', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'مرحباً',
          'fontSize': 18,
          'color': '#1565C0',
          'textDirection': 'rtl',
        },
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.text, 'مرحباً');
      expect(style.textDirection, TextDirection.rtl);
    });

    test('fromNode parses font weight', () {
      final node = RenderPaintNode(
        id: 't3', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Bold',
          'fontWeight': 'bold',
          'fontSize': 14,
        },
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.fontWeight, FontWeight.bold);
    });

    test('fromNode parses gradient', () {
      final node = RenderPaintNode(
        id: 't4', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Gradient',
          'fontSize': 20,
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
        },
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.hasGradient, isTrue);
    });

    test('fromNode parses shadows', () {
      final node = RenderPaintNode(
        id: 't5', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Shadow',
          'fontSize': 14,
          'color': '#000000',
          'textShadows': [
            {'color': '#FF0000', 'offsetX': 3, 'offsetY': 3, 'blurRadius': 4},
          ],
        },
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, 1);
    });

    test('fromNode parses stroke', () {
      final node = RenderPaintNode(
        id: 't6', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Stroke',
          'fontSize': 18,
          'color': '#FFFFFF',
          'strokeColor': '#000000',
          'strokeWidth': 2,
        },
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.hasStroke, isTrue);
      expect(style.strokeWidth, 2.0);
    });

    test('empty text handling', () {
      final node = RenderPaintNode(
        id: 't7', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {},
      );
      final style = TextPaintStyle.fromNode(node);
      expect(style.text, '');
      expect(style.fontSize, 14.0);
    });

    test('buildTextStyle returns valid TextStyle', () {
      final node = RenderPaintNode(
        id: 't8', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Test',
          'fontSize': 16,
          'color': '#FF0000',
          'fontFamily': 'Arial',
          'letterSpacing': 1.5,
        },
      );
      final style = TextPaintStyle.fromNode(node);
      final ts = style.buildTextStyle();
      expect(ts.fontSize, 16.0);
      expect(ts.fontFamily, 'Arial');
      expect(ts.letterSpacing, 1.5);
    });

    test('buildStrokeTextStyle returns stroke style', () {
      final node = RenderPaintNode(
        id: 't9', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Stroke',
          'strokeColor': '#000000',
          'strokeWidth': 2,
        },
      );
      final style = TextPaintStyle.fromNode(node);
      final ts = style.buildStrokeTextStyle();
      expect(ts.foreground, isNotNull);
    });
  });

  group('TextPaintOptions', () {
    test('fromNode creates options with correct rect', () {
      final node = RenderPaintNode(
        id: 't1', type: 'text',
        x: 10, y: 20, width: 200, height: 50,
        properties: {
          'text': 'Hello',
          'fontSize': 16,
        },
      );
      final opts = TextPaintOptions.fromNode(node);
      expect(opts.rect.left, 10);
      expect(opts.rect.top, 20);
      expect(opts.rect.width, 200);
      expect(opts.rect.height, 50);
      expect(opts.text, 'Hello');
    });

    test('invisible node returns visible: false', () {
      final node = RenderPaintNode(
        id: 't2', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        visible: false,
        properties: {'text': 'Hello'},
      );
      final opts = TextPaintOptions.fromNode(node);
      expect(opts.visible, isFalse);
    });

    test('computePaintBounds returns rect bounds', () {
      final node = RenderPaintNode(
        id: 't3', type: 'text',
        x: 10, y: 10, width: 100, height: 30,
        properties: {'text': 'Hello'},
      );
      final opts = TextPaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.left, lessThanOrEqualTo(10));
      expect(bounds.right, greaterThanOrEqualTo(110));
    });

    test('computePaintBounds expands for shadows', () {
      final node = RenderPaintNode(
        id: 't4', type: 'text',
        x: 10, y: 10, width: 100, height: 30,
        properties: {
          'text': 'Shadow',
          'color': '#000000',
          'textShadows': [
            {'color': '#FF0000', 'offsetX': 5, 'offsetY': 5, 'blurRadius': 10},
          ],
        },
      );
      final opts = TextPaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.left, lessThanOrEqualTo(10));
      expect(bounds.top, lessThanOrEqualTo(10));
    });

    test('debugPaint parsing', () {
      final node = RenderPaintNode(
        id: 't5', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {
          'text': 'Debug',
          'debugPaint': true,
        },
      );
      final opts = TextPaintOptions.fromNode(node);
      expect(opts.debugPaint, isTrue);
    });
  });

  group('TextPaintMetrics', () {
    test('records characters and lines', () {
      final m = TextPaintMetrics();
      m.recordCharacter(10);
      m.recordLine(2);
      expect(m.charactersPainted, 10);
      expect(m.linesPainted, 2);
    });

    test('records layout and paint time', () {
      final m = TextPaintMetrics();
      m.recordLayoutTime(const Duration(milliseconds: 5));
      m.recordPaintTime(const Duration(milliseconds: 3));
      expect(m.totalTimeMs, closeTo(8.0, 0.1));
    });

    test('records cache hits and misses', () {
      final m = TextPaintMetrics();
      m.recordCacheHit();
      m.recordCacheMiss();
      expect(m.cacheHits, 1);
      expect(m.cacheMisses, 1);
    });

    test('reset clears all values', () {
      final m = TextPaintMetrics();
      m.recordCharacter(10);
      m.recordLine(2);
      m.reset();
      expect(m.charactersPainted, 0);
      expect(m.linesPainted, 0);
    });

    test('copy returns independent copy', () {
      final m = TextPaintMetrics();
      m.recordCharacter(5);
      final c = m.copy();
      c.recordCharacter(3);
      expect(m.charactersPainted, 5);
      expect(c.charactersPainted, 8);
    });

    test('operator + merges correctly', () {
      final a = TextPaintMetrics();
      a.recordCharacter(3);
      a.recordLine(1);
      a.recordLayoutTime(const Duration(milliseconds: 1));

      final b = TextPaintMetrics();
      b.recordCharacter(5);
      b.recordLine(2);
      b.recordLayoutTime(const Duration(milliseconds: 2));

      final r = a + b;
      expect(r.charactersPainted, 8);
      expect(r.linesPainted, 3);
      expect(r.layoutDuration.inMilliseconds, 3);
    });
  });

  group('TextPainterDiagnostics', () {
    test('records operations', () {
      final d = TextPainterDiagnostics();
      d.recordLayoutOp('layout');
      d.recordPaintOp('draw');
      expect(d.totalLayoutOps, 1);
      expect(d.totalPaintOps, 1);
    });

    test('records warnings and errors', () {
      final d = TextPainterDiagnostics();
      d.recordWarning('fallback font used');
      d.recordError('missing glyph');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isTrue);
    });

    test('records overflow', () {
      final d = TextPainterDiagnostics();
      d.recordOverflow('text exceeds bounds');
      expect(d.hasOverflow, isTrue);
    });

    test('records allocations', () {
      final d = TextPainterDiagnostics();
      d.recordAllocation();
      d.recordAllocation();
      expect(d.memoryAllocations, 2);
    });

    test('reset clears all', () {
      final d = TextPainterDiagnostics();
      d.recordLayoutOp('layout');
      d.recordError('error');
      d.reset();
      expect(d.totalLayoutOps, 0);
      expect(d.hasErrors, isFalse);
    });

    test('merge combines diagnostics', () {
      final a = TextPainterDiagnostics();
      a.recordLayoutOp('layout');

      final b = TextPainterDiagnostics();
      b.recordPaintOp('paint');

      a.merge(b);
      expect(a.totalLayoutOps, 1);
      expect(a.totalPaintOps, 1);
    });
  });

  group('TextPainterElement', () {
    late PictureRecorder recorder;
    late Canvas canvas;
    late TextPainterElement painter;

    setUp(() {
      recorder = PictureRecorder();
      canvas = Canvas(recorder);
      painter = TextPainterElement();
    });

    PaintContext _makeContext(RenderPaintNode node) {
      return PaintContext(
        canvas: canvas,
        document: ThemeDocument(
          metadata: ThemeMetadata(id: 'test', name: 'Test'),
        ),
        renderTree: RenderTree(
          canvasWidth: 300, canvasHeight: 100,
          viewportWidth: 300, viewportHeight: 100,
          layoutMode: LayoutMode.centered,
          scaleFactor: 1.0,
          root: RenderGroup(id: 'root', children: [node]),
        ),
        renderNode: node,
        viewportWidth: 300, viewportHeight: 100,
        scaleFactor: 1.0,
      );
    }

    test('type is text', () {
      expect(painter.type, 'text');
    });

    test('canPaint returns true for text type', () {
      final node = RenderPaintNode(
        id: 't1', type: 'text',
        x: 0, y: 0, width: 100, height: 30,
        properties: {'text': 'Hello'},
      );
      expect(painter.canPaint(node), isTrue);
    });

    test('canPaint returns false for non-text type', () {
      final node = RenderPaintNode(
        id: 'r1', type: 'rect',
        x: 0, y: 0, width: 100, height: 30,
      );
      expect(painter.canPaint(node), isFalse);
    });

    test('paint returns success for English text', () {
      final node = RenderPaintNode(
        id: 't1', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'Hello, World!',
          'fontSize': 18,
          'color': '#000000',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
      expect(result.elementType, 'text');
    });

    test('paint returns success for Arabic text (RTL)', () {
      final node = RenderPaintNode(
        id: 't2', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'مرحباً بالعالم',
          'fontSize': 18,
          'color': '#1565C0',
          'textDirection': 'rtl',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for mixed Arabic/English', () {
      final node = RenderPaintNode(
        id: 't3', type: 'text',
        x: 10, y: 10, width: 200, height: 50,
        properties: {
          'text': 'مرحباً Hello 2024',
          'fontSize': 18,
          'color': '#2E7D32',
          'textDirection': 'rtl',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for gradient text', () {
      final node = RenderPaintNode(
        id: 't4', type: 'text',
        x: 10, y: 10, width: 200, height: 50,
        properties: {
          'text': 'Gradient Text',
          'fontSize': 24,
          'fontWeight': 'bold',
          'gradientKind': 'linear',
          'gradientColors': ['#FF0000', '#0000FF'],
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for shadow text', () {
      final node = RenderPaintNode(
        id: 't5', type: 'text',
        x: 10, y: 10, width: 200, height: 50,
        properties: {
          'text': 'Shadow Text',
          'fontSize': 22,
          'color': '#000000',
          'fontWeight': 'bold',
          'textShadows': [
            {'color': '#FF0000', 'offsetX': 3, 'offsetY': 3, 'blurRadius': 4},
          ],
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for stroke text', () {
      final node = RenderPaintNode(
        id: 't6', type: 'text',
        x: 10, y: 10, width: 200, height: 50,
        properties: {
          'text': 'Stroke Text',
          'fontSize': 24,
          'color': '#FFFFFF',
          'strokeColor': '#000000',
          'strokeWidth': 2,
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for multiline text', () {
      final node = RenderPaintNode(
        id: 't7', type: 'text',
        x: 10, y: 10, width: 200, height: 80,
        properties: {
          'text': 'Multiline text that wraps across multiple lines in the container.',
          'fontSize': 14,
          'color': '#424242',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for ellipsis overflow', () {
      final node = RenderPaintNode(
        id: 't8', type: 'text',
        x: 10, y: 10, width: 200, height: 30,
        properties: {
          'text': 'Very long text that should be truncated with ellipsis',
          'fontSize': 16,
          'color': '#C62828',
          'maxLines': 1,
          'overflow': 'ellipsis',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint returns success for center aligned text', () {
      final node = RenderPaintNode(
        id: 't9', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'Centered',
          'fontSize': 18,
          'color': '#6A1B9A',
          'textAlign': 'center',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint handles empty text gracefully', () {
      final node = RenderPaintNode(
        id: 't10', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': '',
          'fontSize': 18,
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint handles invisible node', () {
      final node = RenderPaintNode(
        id: 't11', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        visible: false,
        properties: {
          'text': 'Hidden',
          'fontSize': 18,
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('paint handles null canvas gracefully', () {
      final node = RenderPaintNode(
        id: 't12', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'Hello',
          'fontSize': 18,
        },
      );
      final ctx = PaintContext(
        canvas: null,
        document: ThemeDocument(
          metadata: ThemeMetadata(id: 'test', name: 'Test'),
        ),
        renderTree: RenderTree(
          canvasWidth: 300, canvasHeight: 100,
          viewportWidth: 300, viewportHeight: 100,
          layoutMode: LayoutMode.centered,
          scaleFactor: 1.0,
          root: RenderGroup(id: 'root', children: [node]),
        ),
        renderNode: node,
        viewportWidth: 300, viewportHeight: 100,
        scaleFactor: 1.0,
      );
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('paint with rotation and opacity', () {
      final node = RenderPaintNode(
        id: 't13', type: 'text',
        x: 10, y: 10, width: 200, height: 50,
        rotation: 0.15,
        opacity: 0.8,
        properties: {
          'text': 'Rotated Text',
          'fontSize': 18,
          'color': '#000000',
        },
      );
      painter.prepare(_makeContext(node));
      final result = painter.paint(_makeContext(node));
      expect(result.success, isTrue);
    });

    test('dispose clears resources', () {
      final node = RenderPaintNode(
        id: 't14', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'Hello',
          'fontSize': 18,
        },
      );
      painter.prepare(_makeContext(node));
      painter.paint(_makeContext(node));
      painter.dispose();
      expect(painter.metrics.charactersPainted, 0);
    });

    test('initialize resets state', () {
      final node = RenderPaintNode(
        id: 't15', type: 'text',
        x: 10, y: 10, width: 200, height: 40,
        properties: {
          'text': 'Hello',
          'fontSize': 18,
        },
      );
      painter.prepare(_makeContext(node));
      painter.paint(_makeContext(node));
      painter.initialize();
      expect(painter.metrics.charactersPainted, 0);
    });
  });

  group('TextPainter Demo', () {
    test('runTextPainterDemo runs without error', () {
      final output = runTextPainterDemo();
      expect(output, contains('=== TextPainter Demo ==='));
      expect(output, contains('=== Demo Complete'));
      expect(output, contains('OK'));
    });

    test('all 10 examples succeed', () {
      final output = runTextPainterDemo();
      final okCount = 'OK'.allMatches(output).length;
      expect(okCount, 10);
    });
  });
}
