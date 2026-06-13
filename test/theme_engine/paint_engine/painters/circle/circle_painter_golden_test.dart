import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/circle/circle_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

Future<void> _assertGolden(
  WidgetTester tester,
  RenderPaintNode node,
  String goldenName,
) async {
  final painter = CirclePainter();
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 200, height: 200,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _CircleGoldenPainter(painter, node),
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

class _CircleGoldenPainter extends CustomPainter {
  final CirclePainter painter;
  final RenderPaintNode node;
  _CircleGoldenPainter(this.painter, this.node);

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
  testWidgets('CirclePainter golden - fill', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g1', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000',
    ), 'circle_fill.png');
  });

  testWidgets('CirclePainter golden - stroked', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g2', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000', strokeWidth: 5, strokeColor: '#0000FF',
    ), 'circle_stroked.png');
  });

  testWidgets('CirclePainter golden - shadow', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g3', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#888888',
      properties: {
        'shadows': [
          {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
        ],
      },
    ), 'circle_shadow.png');
  });

  testWidgets('CirclePainter golden - rotated', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g4', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000', rotation: 0.3,
    ), 'circle_rotated.png');
  });
}
