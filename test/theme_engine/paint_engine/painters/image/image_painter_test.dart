import 'dart:ui' show PictureRecorder, Canvas, BlendMode;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/paint_result.dart';
import 'package:business_card/theme_engine/paint_engine/painters/image/image_painter.dart';
import 'package:business_card/theme_engine/paint_engine/painters/image/image_paint_metrics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/image/image_paint_options.dart';
import 'package:business_card/theme_engine/paint_engine/painters/image/image_paint_style.dart';
import 'package:business_card/theme_engine/paint_engine/painters/image/image_painter_diagnostics.dart';
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
  final painter = ImagePainter();
  painter.prepare(ctx);
  final result = painter.paint(ctx);
  recorder.endRecording();
  return result;
}

void main() {
  group('ImagePaintStyle', () {
    test('fromNode creates default placeholder style', () {
      final node = RenderPaintNode(
        id: 'i1', type: 'image',
        x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
      );
      final style = ImagePaintStyle.fromNode(node);
      expect(style.imageSource, equals('placeholder'));
      expect(style.hasBorder, isFalse);
    });

    test('fromNode reads border properties', () {
      final node = RenderPaintNode(
        id: 'i1', type: 'image',
        x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {
          'borderWidth': 4,
          'borderColor': '#FF0000',
        },
      );
      final style = ImagePaintStyle.fromNode(node);
      expect(style.borderWidth, equals(4));
      expect(style.borderColor, isNotNull);
      expect(style.hasBorder, isTrue);
    });

    test('fromNode reads shadows from properties', () {
      final node = RenderPaintNode(
        id: 'i1', type: 'image',
        x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = ImagePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('fromNode reads shadows from model', () {
      final node = RenderPaintNode(
        id: 'i1', type: 'image',
        x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 2, offsetY: 2, blurRadius: 4, opacity: 0.3)],
      );
      final style = ImagePaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
    });

    test('fromNode reads colorFilter', () {
      final node = RenderPaintNode(
        id: 'i1', type: 'image',
        x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {
          'colorFilterColor': '#FF0000',
          'colorFilterBlendMode': 'multiply',
        },
      );
      final style = ImagePaintStyle.fromNode(node);
      expect(style.hasColorFilter, isTrue);
      expect(style.colorFilterBlendMode, equals(BlendMode.multiply));
    });

    test('fromNode reads imageSource and imagePath', () {
      final node = RenderPaintNode(
        id: 'i1', type: 'image',
        x: 0, y: 0, width: 100, height: 100,
        properties: {
          'imageSource': 'asset',
          'imagePath': 'images/test.png',
        },
      );
      final style = ImagePaintStyle.fromNode(node);
      expect(style.imageSource, equals('asset'));
      expect(style.imagePath, equals('images/test.png'));
    });

    test('equality operator', () {
      final n1 = RenderPaintNode(id: 'a', type: 'image', x: 0, y: 0, width: 100, height: 100,
        properties: {'borderWidth': 2, 'borderColor': '#FF0000'});
      final n2 = RenderPaintNode(id: 'b', type: 'image', x: 0, y: 0, width: 100, height: 100,
        properties: {'borderWidth': 2, 'borderColor': '#FF0000'});
      expect(ImagePaintStyle.fromNode(n1), equals(ImagePaintStyle.fromNode(n2)));
    });

    test('toString returns descriptive string', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0');
      final style = ImagePaintStyle.fromNode(node);
      expect(style.toString(), contains('placeholder'));
    });
  });

  group('ImagePaintOptions', () {
    test('fromNode creates basic image rect', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 10, y: 20, width: 200, height: 150,
        color: '#E0E0E0');
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.rect.left, equals(10));
      expect(opts.rect.top, equals(20));
      expect(opts.rect.width, equals(200));
      expect(opts.rect.height, equals(150));
    });

    test('fromNode reads borderRadius', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'borderRadius': 15});
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.borderRadius, equals(15));
    });

    test('fromNode reads circular property', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'circular': true});
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.circular, isTrue);
    });

    test('fromNode reads fit and alignment', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'fit': 'cover', 'alignment': 'topCenter'});
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.fit, equals(ImageBoxFit.cover));
      expect(opts.alignment, equals(ImageAlignment.topCenter));
    });

    test('computePaintBounds includes border and shadows', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {'borderWidth': 4, 'borderColor': '#FF0000',
          'shadows': [{'color': '#000000', 'offsetX': 10, 'offsetY': 10, 'blurRadius': 5, 'opacity': 0.3}]});
      final opts = ImagePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
    });

    test('computePaintBounds includes rotation', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', rotation: 0.5);
      final opts = ImagePaintOptions.fromNode(node);
      final bounds = opts.computePaintBounds();
      expect(bounds.width, greaterThan(100));
    });

    test('opacity and rotation read from node', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', opacity: 0.5, rotation: 0.3);
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.opacity, equals(0.5));
      expect(opts.rotation, equals(0.3));
    });

    test('visible defaults to true', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0');
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.visible, isTrue);
    });

    test('toString returns descriptive string', () {
      final node = RenderPaintNode(id: 'i1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0');
      final opts = ImagePaintOptions.fromNode(node);
      expect(opts.toString(), contains('ImagePaintOptions'));
    });
  });

  group('ImagePaintMetrics', () {
    test('records all counters correctly', () {
      final m = ImagePaintMetrics();
      m.recordImage(100);
      m.recordPlaceholder();
      m.recordBorder();
      m.recordShadow();
      expect(m.imagesPainted, equals(1));
      expect(m.placeholderCount, equals(1));
      expect(m.borderCount, equals(1));
      expect(m.shadowCount, equals(1));
    });

    test('reset clears all counters', () {
      final m = ImagePaintMetrics();
      m.recordImage(100);
      m.reset();
      expect(m.imagesPainted, equals(0));
    });

    test('copy creates independent clone', () {
      final m = ImagePaintMetrics();
      m.recordImage(100);
      final c = m.copy();
      expect(c.imagesPainted, equals(1));
      m.recordImage(50);
      expect(c.imagesPainted, equals(1));
    });

    test('operator+ merges correctly', () {
      final a = ImagePaintMetrics();
      a.recordImage(100);
      final b = ImagePaintMetrics();
      b.recordImage(50);
      b.recordBorder();
      final c = a + b;
      expect(c.imagesPainted, equals(2));
      expect(c.borderCount, equals(1));
    });

    test('averagePaintTimeMs returns 0 when no images', () {
      expect(ImagePaintMetrics().averagePaintTimeMs, equals(0));
    });
  });

  group('ImagePainterDiagnostics', () {
    test('records operations', () {
      final d = ImagePainterDiagnostics();
      d.recordOperation('canvas.save');
      expect(d.totalOperations, equals(1));
    });

    test('records warnings and errors', () {
      final d = ImagePainterDiagnostics();
      d.recordWarning('test');
      d.recordError('test');
      expect(d.hasWarnings, isTrue);
      expect(d.hasErrors, isTrue);
    });

    test('reset clears everything', () {
      final d = ImagePainterDiagnostics();
      d.recordOperation('canvas.save');
      d.reset();
      expect(d.totalOperations, equals(0));
    });

    test('merge combines diagnostics', () {
      final a = ImagePainterDiagnostics();
      a.recordOperation('op1');
      final b = ImagePainterDiagnostics();
      b.recordError('err');
      a.merge(b);
      expect(a.totalOperations, equals(1));
      expect(a.hasErrors, isTrue);
    });
  });

  group('ImagePainter', () {
    test('canPaint returns true for image type', () {
      final painter = ImagePainter();
      final node = RenderPaintNode(id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0');
      expect(painter.canPaint(node), isTrue);
    });

    test('canPaint returns false for non-image types', () {
      final painter = ImagePainter();
      final node = RenderPaintNode(id: 'n1', type: 'rect', x: 0, y: 0, width: 100, height: 100);
      expect(painter.canPaint(node), isFalse);
    });

    test('type returns image', () {
      expect(ImagePainter().type, equals('image'));
    });

    test('paint returns success for placeholder image', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for rounded image', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'borderRadius': 20},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for circular image', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'circular': true},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for image with border', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'borderWidth': 4, 'borderColor': '#FF0000'},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for image with shadow', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {'shadows': [{'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4}]},
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for rotated image', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', rotation: 0.3,
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for scaled image', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', scaleX: 1.5, scaleY: 1.5,
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for transparent image', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', opacity: 0.5,
      ));
      expect(result.success, isTrue);
    });

    test('paint returns success for invisible image (skipped)', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', visible: false,
      ));
      expect(result.success, isTrue);
    });

    test('paint returns failure when canvas is null', () {
      final node = RenderPaintNode(id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0');
      final ctx = _makeContext(node);
      final painter = ImagePainter();
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('paint with opacity=0', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', opacity: 0,
      ));
      expect(result.success, isTrue);
    });

    test('paint with color filter', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {'colorFilterColor': '#FF0000', 'colorFilterBlendMode': 'multiply'},
      ));
      expect(result.success, isTrue);
    });

    test('metrics accumulate across paint calls', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = ImagePainter();
      for (var i = 0; i < 3; i++) {
        final node = RenderPaintNode(id: 'n$i', type: 'image', x: 0, y: 0, width: 100, height: 100,
          color: '#E0E0E0');
        final ctx = _makeContext(node, canvas: canvas);
        painter.prepare(ctx);
        painter.paint(ctx);
      }
      expect(painter.metrics.imagesPainted, equals(3));
    });

    test('dispose cleans up', () {
      final painter = ImagePainter();
      painter.initialize();
      painter.dispose();
      expect(painter.metrics.imagesPainted, equals(0));
    });

    test('lifecycle: initialize -> prepare -> paint -> cleanup', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = ImagePainter();
      painter.initialize();
      final node = RenderPaintNode(id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0');
      final ctx = _makeContext(node, canvas: canvas);
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      painter.cleanup();
      expect(result.success, isTrue);
    });

    test('debug paint draws overlays', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'debugPaint': true},
      ));
      expect(result.success, isTrue);
    });

    test('clipped image paints successfully', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0', properties: {'clipping': true, 'borderRadius': 10},
      ));
      expect(result.success, isTrue);
    });

    test('multiple shadows paint successfully', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {'shadows': [
          {'color': '#000000', 'offsetX': 2, 'offsetY': 2, 'blurRadius': 4, 'opacity': 0.3},
          {'color': '#000000', 'offsetX': 6, 'offsetY': 6, 'blurRadius': 12, 'opacity': 0.2},
        ]},
      ));
      expect(result.success, isTrue);
    });

    test('circular with border paints successfully', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        color: '#E0E0E0',
        properties: {'circular': true, 'borderWidth': 3, 'borderColor': '#FF0000'},
      ));
      expect(result.success, isTrue);
    });

    test('setImage stores reference', () {
      final painter = ImagePainter();
      // Just test that setImage accepts null without crashing
      painter.setImage(null);
      expect(painter is ImagePainter, isTrue);
    });

    test('demo runs without exceptions', () {
      expect(runImagePainterDemo(), contains('Demo Complete'));
    });

    test('paint with all properties empty (defaults)', () {
      final result = _paintNode(RenderPaintNode(
        id: 'n1', type: 'image', x: 0, y: 0, width: 100, height: 100,
        properties: {},
      ));
      expect(result.success, isTrue);
    });
  });
}
