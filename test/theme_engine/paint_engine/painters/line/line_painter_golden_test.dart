import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/line/line_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

Future<void> _assertGolden(
  WidgetTester tester,
  RenderPaintNode node,
  String goldenName,
) async {
  final painter = LinePainter();
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 200, height: 200,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _LineGoldenPainter(painter, node),
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

class _LineGoldenPainter extends CustomPainter {
  final LinePainter painter;
  final RenderPaintNode node;
  _LineGoldenPainter(this.painter, this.node);

  @override
  void paint(Canvas canvas, Size size) {
    final ctx = PaintContext(
      canvas: canvas,
      document: ThemeDocument(metadata: ThemeMetadata(id: 'golden', name: 'Golden')),
      renderTree: RenderTree(
        canvasWidth: 200, canvasHeight: 200,
        viewportWidth: 200, viewportHeight: 200,
        layoutMode: LayoutMode.centered, scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [node]),
      ),
      renderNode: node,
      viewportWidth: 200, viewportHeight: 200, scaleFactor: 1.0,
    );
    painter.prepare(ctx);
    painter.paint(ctx);
  }

  @override
  bool shouldRepaint(_) => false;
}

void main() {
  testWidgets('LinePainter golden - basic', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g1', type: 'line',
      x: 20, y: 100, width: 160, height: 0,
      color: '#FF0000',
    ), 'line_basic.png');
  });

  testWidgets('LinePainter golden - thick', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g2', type: 'line',
      x: 20, y: 100, width: 160, height: 0,
      color: '#0000FF', strokeWidth: 10,
    ), 'line_thick.png');
  });

  testWidgets('LinePainter golden - rotated', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g3', type: 'line',
      x: 50, y: 100, width: 100, height: 0,
      color: '#FF0000', rotation: 0.3,
    ), 'line_rotated.png');
  });

  testWidgets('LinePainter golden - shadow', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g4', type: 'line',
      x: 20, y: 100, width: 160, height: 0,
      color: '#FF0000',
      properties: {
        'shadows': [
          {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
        ],
      },
    ), 'line_shadow.png');
  });
}
