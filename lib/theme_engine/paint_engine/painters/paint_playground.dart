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
import 'gradient/gradient_painter.dart';
import 'image/image_painter.dart';
import 'text/text_painter.dart';

/// Renders all 6 element types (rect, circle, line, path, gradient, image) on
/// a single canvas. Returns a String with performance results.
String runPaintPlayground() {
  final buffer = StringBuffer();
  buffer.writeln('=== Paint Playground - Combined Demo ===');
  buffer.writeln('');

  const canvasW = 900.0;
  const canvasH = 700.0;

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

  // -----------------------------------------------------------------------
  // 5. Gradient
  // -----------------------------------------------------------------------
  final gradNode = RenderPaintNode(
    id: 'gradient', type: 'gradient',
    x: 20, y: 240, width: 260, height: 200,
    properties: {
      'gradientKind': 'linear',
      'gradientColors': ['#FF6F00', '#FFB74D'],
      'angle': 135,
      'borderRadius': 16,
    },
  );

  final gradCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [gradNode]),
    ),
    renderNode: gradNode,
    viewportWidth: canvasW, viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final gradPainter = GradientPainter();
  gradPainter.prepare(gradCtx);
  final gradResult = gradPainter.paint(gradCtx);
  buffer.writeln('Gradient: ${gradResult.duration.inMicroseconds}us');

  // -----------------------------------------------------------------------
  // 6. Image (placeholder)
  // -----------------------------------------------------------------------
  final imgNode = RenderPaintNode(
    id: 'image', type: 'image',
    x: 320, y: 240, width: 260, height: 200,
    color: '#C8E6C9',
    properties: {
      'borderRadius': 16,
      'borderWidth': 3,
      'borderColor': '#2E7D32',
    },
  );

  final imgCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [imgNode]),
    ),
    renderNode: imgNode,
    viewportWidth: canvasW, viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final imgPainter = ImagePainter();
  imgPainter.prepare(imgCtx);
  final imgResult = imgPainter.paint(imgCtx);
  buffer.writeln('Image: ${imgResult.duration.inMicroseconds}us');

  // -----------------------------------------------------------------------
  // 7. Text
  // -----------------------------------------------------------------------
  final textNode = RenderPaintNode(
    id: 'text', type: 'text',
    x: 620, y: 20, width: 260, height: 40,
    properties: {
      'text': 'Hello Text!',
      'fontSize': 20,
      'color': '#000000',
      'fontWeight': 'bold',
    },
  );

  final textCtx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [textNode]),
    ),
    renderNode: textNode,
    viewportWidth: canvasW, viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final textPainter = TextPainterElement();
  textPainter.prepare(textCtx);
  final textResult = textPainter.paint(textCtx);
  buffer.writeln('Text: ${textResult.duration.inMicroseconds}us');

  // -----------------------------------------------------------------------
  // 8. Circle with styling
  // -----------------------------------------------------------------------
  final circle2Node = RenderPaintNode(
    id: 'circle2', type: 'circle',
    x: 620, y: 20, width: 260, height: 180,
    color: '#AB47BC',
    strokeWidth: 2,
    strokeColor: '#6A1B9A',
  );

  final circle2Ctx = PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'playground', name: 'Playground'),
    ),
    renderTree: RenderTree(
      canvasWidth: canvasW, canvasHeight: canvasH,
      viewportWidth: canvasW, viewportHeight: canvasH,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [circle2Node]),
    ),
    renderNode: circle2Node,
    viewportWidth: canvasW, viewportHeight: canvasH,
    scaleFactor: 1.0,
  );

  final circle2Painter = CirclePainter();
  circle2Painter.prepare(circle2Ctx);
  final circle2Result = circle2Painter.paint(circle2Ctx);
  buffer.writeln('Circle2: ${circle2Result.duration.inMicroseconds}us');

  recorder.endRecording();

  buffer.writeln('');
  buffer.writeln('=== Playground Complete ===');
  buffer.writeln('Canvas: ${canvasW}x$canvasH');
  buffer.writeln('Rectangles: ${rectPainter.metrics}');
  buffer.writeln('Circles: ${circlePainter.metrics}');
  buffer.writeln('Lines: ${linePainter.metrics}');
  buffer.writeln('Paths: ${pathPainter.metrics}');
  buffer.writeln('Gradients: ${gradPainter.metrics}');
  buffer.writeln('Images: ${imgPainter.metrics}');
  buffer.writeln('Texts: ${textPainter.metrics}');

  return buffer.toString();
}
