import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

const _iterations = 100;

PaintContext _makeContext(RenderPaintNode node, {Canvas? canvas}) {
  return PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'bench', name: 'Benchmark'),
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

void main() {
  group('PathPainter benchmarks', () {
    double runBenchmark(RenderPaintNode node) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final ctx = _makeContext(node, canvas: canvas);
      final painter = PathPainter();
      painter.prepare(ctx);

      final watch = Stopwatch();
      for (var i = 0; i < _iterations; i++) {
        watch.start();
        painter.paint(ctx);
        watch.stop();
      }
      recorder.endRecording();
      return watch.elapsedMicroseconds / _iterations;
    }

    test('Basic triangle path (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'p', type: 'path',
        x: 0, y: 0, width: 200, height: 200,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 100, 'y': 10},
            {'type': 'lineTo', 'x': 180, 'y': 180},
            {'type': 'lineTo', 'x': 20, 'y': 180},
            {'type': 'closePath'},
          ],
        },
      );
      final avg = runBenchmark(node);
      print('Basic triangle path: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Stroked path (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'p', type: 'path',
        x: 0, y: 0, width: 200, height: 200,
        color: '#FF0000', strokeWidth: 4, strokeColor: '#000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 20, 'y': 100},
            {'type': 'lineTo', 'x': 180, 'y': 100},
          ],
        },
      );
      final avg = runBenchmark(node);
      print('Stroked path: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Cubic bezier path (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'p', type: 'path',
        x: 0, y: 0, width: 200, height: 200,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 20, 'y': 100},
            {
              'type': 'cubicTo',
              'controlX1': 60, 'controlY1': 20,
              'controlX2': 140, 'controlY2': 180,
              'x': 180, 'y': 100,
            },
          ],
        },
      );
      final avg = runBenchmark(node);
      print('Cubic bezier path: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Shadow path (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'p', type: 'path',
        x: 0, y: 0, width: 200, height: 200,
        color: '#FF0000',
        shadows: const [
          ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8),
        ],
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 100, 'y': 10},
            {'type': 'lineTo', 'x': 180, 'y': 180},
            {'type': 'lineTo', 'x': 20, 'y': 180},
            {'type': 'closePath'},
          ],
        },
      );
      final avg = runBenchmark(node);
      print('Shadow path: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });
  });
}
