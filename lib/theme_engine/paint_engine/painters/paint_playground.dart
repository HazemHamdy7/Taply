import 'dart:ui' show PictureRecorder, Canvas, Rect, Color, Paint;

import '../paint_context.dart';
import '../../models/theme_document.dart';
import '../../models/theme_metadata.dart';
import '../../models/theme_canvas.dart';
import '../../renderer/render_node.dart';
import '../../renderer/render_tree.dart';
import 'rectangle_painter.dart';
import 'circle/circle_painter.dart';
import 'line/line_painter.dart';
import 'path/path_painter.dart';

/// Renders all 4 element types (rect, circle, line, path) on a single canvas
/// with labels. Returns a String with performance results.
String runPaintPlayground() {
  final buffer = StringBuffer();
  buffer.writeln('=== Paint Playground - Combined Demo ===');
  buffer.writeln('');

  const canvasW = 600.0;
  const canvasH = 500.0;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasW, canvasH));

  // Draw background
  canvas.drawRect(
    Rect.fromLTWH(0, 0, canvasW, canvasH),
    Paint()..color = const Color(0xFFF5F5F5),
  );

  // -----------------------------------------------------------------------
  // 1. Rectangle
  // -----------------------------------------------------------------------
  final rectNode = RenderPaintNode(
    id: 'rect', type: 'rect',
    x: 20, y: 20, width: 260, height: 180,
    color: '#42A5F5',
    strokeWidth: 2,
    strokeColor: '#1565C0',
    rotation: 0.05,
    properties: {
      'borderRadius': 16,
      'styleType': 'fillAndStroke',
    },
  );

  final rectCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [rectNode]),
    ),
    renderNode: rectNode,
    viewportWidth: canvasW,
    viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final rectPainter = RectanglePainter();
  rectPainter.prepare(rectCtx);
  final rectResult = rectPainter.paint(rectCtx);
  buffer.writeln('Rect: ${rectResult.duration.inMicroseconds}us');

  // -----------------------------------------------------------------------
  // 2. Circle
  // -----------------------------------------------------------------------
  final circleNode = RenderPaintNode(
    id: 'circle', type: 'circle',
    x: 320, y: 20, width: 260, height: 180,
    color: '#66BB6A',
    strokeWidth: 2,
    strokeColor: '#2E7D32',
    properties: {
      'styleType': 'fillAndStroke',
    },
  );

  final circleCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [circleNode]),
    ),
    renderNode: circleNode,
    viewportWidth: canvasW,
    viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final circlePainter = CirclePainter();
  circlePainter.prepare(circleCtx);
  final circleResult = circlePainter.paint(circleCtx);
  buffer.writeln('Circle: ${circleResult.duration.inMicroseconds}us');

  // -----------------------------------------------------------------------
  // 3. Line
  // -----------------------------------------------------------------------
  final lineNode = RenderPaintNode(
    id: 'line', type: 'line',
    x: 20, y: 240, width: 260, height: 220,
    color: '#FF7043',
    strokeWidth: 4,
    strokeColor: '#FF7043',
  );

  final lineCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [lineNode]),
    ),
    renderNode: lineNode,
    viewportWidth: canvasW,
    viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final linePainter = LinePainter();
  linePainter.prepare(lineCtx);
  final lineResult = linePainter.paint(lineCtx);
  buffer.writeln('Line: ${lineResult.duration.inMicroseconds}us');

  // -----------------------------------------------------------------------
  // 4. Path
  // -----------------------------------------------------------------------
  final pathNode = RenderPaintNode(
    id: 'path', type: 'path',
    x: 320, y: 240, width: 260, height: 220,
    color: '#AB47BC',
    strokeWidth: 2,
    strokeColor: '#6A1B9A',
    properties: {
      'styleType': 'fillAndStroke',
      'pathCommands': [
        {'type': 'moveTo', 'x': 0.1, 'y': 0.8},
        {'type': 'lineTo', 'x': 0.5, 'y': 0.2},
        {'type': 'lineTo', 'x': 0.9, 'y': 0.8},
        {'type': 'close'},
      ],
    },
  );

  final pathCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [pathNode]),
    ),
    renderNode: pathNode,
    viewportWidth: canvasW,
    viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final pathPainter = PathPainter();
  pathPainter.prepare(pathCtx);
  final pathResult = pathPainter.paint(pathCtx);
  buffer.writeln('Path: ${pathResult.duration.inMicroseconds}us');

  recorder.endRecording();

  buffer.writeln('');
  buffer.writeln('=== Playground Complete ===');
  buffer.writeln('Canvas: ${canvasW}x$canvasH');
  buffer.writeln('Rectangles: ${rectPainter.metrics}');
  buffer.writeln('Circles: ${circlePainter.metrics}');
  buffer.writeln('Lines: ${linePainter.metrics}');
  buffer.writeln('Paths: ${pathPainter.metrics}');

  return buffer.toString();
}
