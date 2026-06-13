import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

const _iterations = 100;

PaintContext _makeBenchContext(RenderPaintNode node, {required Canvas canvas}) {
  return PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'bench', name: 'Benchmark'),
    ),
    renderTree: RenderTree(
      canvasWidth: 200, canvasHeight: 200,
      viewportWidth: 200, viewportHeight: 200,
      layoutMode: LayoutMode.centered, scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [node]),
    ),
    renderNode: node,
    viewportWidth: 200, viewportHeight: 200, scaleFactor: 1.0,
  );
}

List<double> _runBenchmark(RenderPaintNode node) {
    final durations = <double>[];
    for (var i = 0; i < _iterations; i++) {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final ctx = _makeBenchContext(node, canvas: canvas);
      final painter = CirclePainter();
      painter.prepare(ctx);
      final sw = Stopwatch()..start();
      painter.paint(ctx);
      sw.stop();
      durations.add(sw.elapsedMicroseconds.toDouble());
      recorder.endRecording();
    }
    return durations;
}

void _printStats(String label, List<double> durations) {
    final min = durations.reduce((a, b) => a < b ? a : b);
    final max = durations.reduce((a, b) => a > b ? a : b);
    final avg = durations.reduce((a, b) => a + b) / durations.length;
    // ignore: avoid_print
    print('$label: min=${min.toStringAsFixed(1)}us '
        'avg=${avg.toStringAsFixed(1)}us '
        'max=${max.toStringAsFixed(1)}us '
        '($_iterations iterations)');
}

void main() {
  test('CirclePainter benchmark - basic fill circle', () {
    final node = RenderPaintNode(
      id: 'b1', type: 'circle',
      x: 50, y: 50, width: 100, height: 100,
      color: '#FF0000',
    );
    final durations = _runBenchmark(node);
    _printStats('Basic fill', durations);
    expect(durations.length, equals(_iterations));
  });

  test('CirclePainter benchmark - stroked circle', () {
    final node = RenderPaintNode(
      id: 'b2', type: 'circle',
      x: 50, y: 50, width: 100, height: 100,
      color: '#FF0000', strokeWidth: 5, strokeColor: '#0000FF',
    );
    final durations = _runBenchmark(node);
    _printStats('Stroked', durations);
    expect(durations.length, equals(_iterations));
  });

  test('CirclePainter benchmark - shadow circle', () {
    final node = RenderPaintNode(
      id: 'b3', type: 'circle',
      x: 50, y: 50, width: 100, height: 100,
      color: '#FF0000',
      shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8, opacity: 0.4)],
    );
    final durations = _runBenchmark(node);
    _printStats('Shadow', durations);
    expect(durations.length, equals(_iterations));
  });

  test('CirclePainter benchmark - rotated circle', () {
    final node = RenderPaintNode(
      id: 'b4', type: 'circle',
      x: 50, y: 50, width: 100, height: 100,
      color: '#FF0000', rotation: 0.3,
    );
    final durations = _runBenchmark(node);
    _printStats('Rotated', durations);
    expect(durations.length, equals(_iterations));
  });
}
