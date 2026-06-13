import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_painter.dart';
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
    final painter = GradientPainter();
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
  test('GradientPainter benchmark - linear gradient', () {
    final node = RenderPaintNode(
      id: 'b1', type: 'gradient',
      x: 0, y: 0, width: 100, height: 100,
      properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF']},
    );
    final durations = _runBenchmark(node);
    _printStats('Linear', durations);
    expect(durations.length, equals(_iterations));
  });

  test('GradientPainter benchmark - radial gradient', () {
    final node = RenderPaintNode(
      id: 'b2', type: 'gradient',
      x: 0, y: 0, width: 100, height: 100,
      properties: {'gradientKind': 'radial', 'gradientColors': ['#00FF00', '#0000FF']},
    );
    final durations = _runBenchmark(node);
    _printStats('Radial', durations);
    expect(durations.length, equals(_iterations));
  });

  test('GradientPainter benchmark - sweep gradient', () {
    final node = RenderPaintNode(
      id: 'b3', type: 'gradient',
      x: 0, y: 0, width: 100, height: 100,
      properties: {'gradientKind': 'sweep', 'gradientColors': ['#FF0000', '#FFFF00', '#00FF00', '#0000FF']},
    );
    final durations = _runBenchmark(node);
    _printStats('Sweep', durations);
    expect(durations.length, equals(_iterations));
  });

  test('GradientPainter benchmark - rounded gradient', () {
    final node = RenderPaintNode(
      id: 'b4', type: 'gradient',
      x: 0, y: 0, width: 100, height: 100,
      properties: {'gradientKind': 'linear', 'gradientColors': ['#FF0000', '#0000FF'], 'borderRadius': 20},
    );
    final durations = _runBenchmark(node);
    _printStats('Rounded', durations);
    expect(durations.length, equals(_iterations));
  });
}
