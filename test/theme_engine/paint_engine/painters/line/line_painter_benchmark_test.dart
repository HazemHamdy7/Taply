import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_painter.dart';
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
      canvasWidth: 1000, canvasHeight: 600,
      viewportWidth: 1000, viewportHeight: 600,
      layoutMode: LayoutMode.centered, scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [node]),
    ),
    renderNode: node,
    viewportWidth: 1000, viewportHeight: 600, scaleFactor: 1.0,
  );
}

void main() {
  group('LinePainter benchmarks', () {
    double runBenchmark(RenderPaintNode node) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final ctx = _makeContext(node, canvas: canvas);
      final painter = LinePainter();
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

    test('Basic line (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'l', type: 'line',
        x: 10, y: 100, width: 200, height: 0,
        color: '#FF0000',
      );
      final avg = runBenchmark(node);
      print('Basic line: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Thick line (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'l', type: 'line',
        x: 10, y: 100, width: 200, height: 0,
        color: '#0000FF', strokeWidth: 10,
      );
      final avg = runBenchmark(node);
      print('Thick line: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Shadow line (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'l', type: 'line',
        x: 10, y: 100, width: 200, height: 0,
        color: '#FF0000',
        shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8)],
      );
      final avg = runBenchmark(node);
      print('Shadow line: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });

    test('Rotated line (100 iterations)', () {
      final node = RenderPaintNode(
        id: 'l', type: 'line',
        x: 100, y: 100, width: 200, height: 0,
        color: '#FF0000', rotation: 0.3,
      );
      final avg = runBenchmark(node);
      print('Rotated line: $avg us avg ($_iterations iterations)');
      expect(avg, greaterThan(0));
    });
  });
}
