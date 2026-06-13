import 'dart:ui' show PictureRecorder, Canvas, Rect, Color, Paint;

import '../../paint_context.dart';
import '../../../models/theme_document.dart';
import '../../../models/theme_metadata.dart';
import '../../../models/theme_canvas.dart';
import '../../../renderer/render_node.dart';
import '../../../renderer/render_tree.dart';
import 'text_painter.dart';

String runTextDemo() {
  final buffer = StringBuffer();
  buffer.writeln('=== Text Demo ===');
  buffer.writeln('');

  const canvasW = 600.0;
  const canvasH = 700.0;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasW, canvasH));

  canvas.drawRect(
    Rect.fromLTWH(0, 0, canvasW, canvasH),
    Paint()..color = const Color(0xFFF5F5F5),
  );

  void paintText(String label, RenderPaintNode node) {
    final ctx = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'text_demo', name: 'Text Demo'),
      ),
      renderTree: RenderTree(
        canvasWidth: canvasW, canvasHeight: canvasH,
        viewportWidth: canvasW, viewportHeight: canvasH,
        layoutMode: LayoutMode.centered,
        scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [node]),
      ),
      renderNode: node,
      viewportWidth: canvasW, viewportHeight: canvasH,
      scaleFactor: 1.0,
    );
    final painter = TextPainterElement();
    painter.prepare(ctx);
    final result = painter.paint(ctx);
    buffer.writeln('$label: ${result.success ? "OK" : "FAIL"} '
        '(${result.duration.inMicroseconds}us) '
        'metrics: ${painter.metrics} '
        'diag: ${painter.diagnostics}');
  }

  double y = 20.0;

  paintText('English', RenderPaintNode(
    id: 't1', type: 'text',
    x: 20, y: y, width: 260, height: 40,
    properties: {
      'text': 'Hello, World!',
      'fontSize': 20, 'color': '#000000',
    },
  ));
  y += 50.0;

  paintText('Arabic (RTL)', RenderPaintNode(
    id: 't2', type: 'text',
    x: 20, y: y, width: 260, height: 40,
    properties: {
      'text': 'مرحباً بالعالم',
      'fontSize': 20, 'color': '#1565C0',
      'textDirection': 'rtl',
    },
  ));
  y += 50.0;

  paintText('Mixed', RenderPaintNode(
    id: 't3', type: 'text',
    x: 20, y: y, width: 260, height: 50,
    properties: {
      'text': 'مرحباً Hello 2024',
      'fontSize': 18, 'color': '#2E7D32',
      'textDirection': 'rtl', 'fontWeight': 'bold',
    },
  ));
  y += 60.0;

  paintText('Gradient', RenderPaintNode(
    id: 't4', type: 'text',
    x: 20, y: y, width: 260, height: 50,
    properties: {
      'text': 'Gradient Text',
      'fontSize': 24, 'fontWeight': 'bold',
      'gradientKind': 'linear',
      'gradientColors': ['#FF0000', '#0000FF'],
    },
  ));
  y += 60.0;

  paintText('Shadow', RenderPaintNode(
    id: 't5', type: 'text',
    x: 20, y: y, width: 260, height: 50,
    properties: {
      'text': 'Shadow Text',
      'fontSize': 22, 'color': '#000000',
      'fontWeight': 'bold',
      'textShadows': [
        {'color': '#FF0000', 'offsetX': 3, 'offsetY': 3, 'blurRadius': 4},
      ],
    },
  ));
  y += 60.0;

  paintText('Stroke', RenderPaintNode(
    id: 't6', type: 'text',
    x: 20, y: y, width: 260, height: 50,
    properties: {
      'text': 'Stroke Text',
      'fontSize': 24, 'color': '#FFFFFF',
      'strokeColor': '#000000', 'strokeWidth': 2,
      'fontWeight': 'bold',
    },
  ));
  y += 60.0;

  paintText('Multiline', RenderPaintNode(
    id: 't7', type: 'text',
    x: 20, y: y, width: 260, height: 80,
    properties: {
      'text': 'Multiline text demo with soft wrap.',
      'fontSize': 14, 'color': '#424242',
    },
  ));
  y += 90.0;

  paintText('Ellipsis', RenderPaintNode(
    id: 't8', type: 'text',
    x: 20, y: y, width: 260, height: 40,
    properties: {
      'text': 'Very long text that should be truncated',
      'fontSize': 16, 'color': '#C62828',
      'maxLines': 1, 'overflow': 'ellipsis',
    },
  ));

  recorder.endRecording();
  buffer.writeln('');
  buffer.writeln('=== Text Demo Complete ===');

  return buffer.toString();
}
