import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/models/gradient_definition.dart';
import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/rectangle_painter.dart';
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
  group('RectanglePainter benchmarks', () {
    double runBenchmark(RenderPaintNode node) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final ctx = _makeContext(node, canvas: canvas);
      final painter = RectanglePainter();
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

    test('Basic fill rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 0, y: 0, width: 200, height: 150,
        color: '#FF0000',
      );
      final avg = runBenchmark(node);
      print('Basic fill rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Stroked rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 0, y: 0, width: 200, height: 150,
        color: '#FF0000', strokeWidth: 4, strokeColor: '#000',
        properties: {'styleType': 'fillAndStroke'},
      );
      final avg = runBenchmark(node);
      print('Stroked rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Shadow rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 0, y: 0, width: 200, height: 150,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final avg = runBenchmark(node);
      print('Shadow rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Rotated rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 100, y: 75, width: 200, height: 150,
        color: '#FF0000', rotation: 0.3,
      );
      final avg = runBenchmark(node);
      print('Rotated rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Rounded rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 0, y: 0, width: 200, height: 150,
        color: '#FF0000',
        properties: {'borderRadius': 20},
      );
      final avg = runBenchmark(node);
      print('Rounded rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Gradient rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 0, y: 0, width: 200, height: 150,
        gradient: GradientDefinition(kind: 'linear', colors: ['#FF0000', '#0000FF']),
      );
      final avg = runBenchmark(node);
      print('Gradient rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Dashed stroke rect (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'r', type: 'rect',
        x: 0, y: 0, width: 200, height: 150,
        color: '#FFFFFF', strokeWidth: 3, strokeColor: '#000',
        properties: {
          'dashPattern': [10, 5],
          'styleType': 'fillAndStroke',
        },
      );
      final avg = runBenchmark(node);
      print('Dashed stroke rect: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });
  });
}
