import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/text/text_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

Future<void> _assertGolden(
  WidgetTester tester,
  RenderPaintNode node,
  String goldenName,
) async {
  final painter = TextPainterElement();
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 200, height: 100,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(200, 100),
            painter: _TextGoldenPainter(painter, node),
          ),
        ),
      ),
    ),
  );
  await expectLater(
    find.byType(RepaintBoundary),
    matchesGoldenFile('goldens/$goldenName'),
  );
  painter.dispose();
}

class _TextGoldenPainter extends CustomPainter {
  final TextPainterElement painter;
  final RenderPaintNode node;
  _TextGoldenPainter(this.painter, this.node);

  @override
  void paint(Canvas canvas, Size size) {
    final ctx = PaintContext(
      canvas: canvas,
      document: ThemeDocument(metadata: ThemeMetadata(id: 'golden', name: 'Golden')),
      renderTree: RenderTree(
        canvasWidth: 200, canvasHeight: 100,
        viewportWidth: 200, viewportHeight: 100,
        layoutMode: LayoutMode.centered, scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [node]),
      ),
      renderNode: node,
      viewportWidth: 200, viewportHeight: 100, scaleFactor: 1.0,
    );
    painter.prepare(ctx);
    painter.paint(ctx);
  }

  @override
  bool shouldRepaint(_) => false;
}

void main() {
  testWidgets('TextPainter golden - English', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 't1', type: 'text',
      x: 10, y: 10, width: 180, height: 30,
      properties: {
        'text': 'Hello, World!',
        'fontSize': 20,
        'color': '#000000',
      },
    ), 'text_english.png');
  });

  testWidgets('TextPainter golden - Arabic RTL', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 't2', type: 'text',
      x: 10, y: 10, width: 180, height: 30,
      properties: {
        'text': 'مرحباً بالعالم',
        'fontSize': 20,
        'color': '#1565C0',
        'textDirection': 'rtl',
      },
    ), 'text_arabic.png');
  });

  testWidgets('TextPainter golden - gradient', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 't3', type: 'text',
      x: 10, y: 10, width: 180, height: 40,
      properties: {
        'text': 'Gradient',
        'fontSize': 24,
        'fontWeight': 'bold',
        'gradientKind': 'linear',
        'gradientColors': ['#FF0000', '#0000FF'],
      },
    ), 'text_gradient.png');
  });

  testWidgets('TextPainter golden - multiline', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 't4', type: 'text',
      x: 10, y: 10, width: 180, height: 60,
      properties: {
        'text': 'Multiline text that wraps across lines.',
        'fontSize': 14,
        'color': '#424242',
        'lineHeight': 1.5,
      },
    ), 'text_multiline.png');
  });
}
