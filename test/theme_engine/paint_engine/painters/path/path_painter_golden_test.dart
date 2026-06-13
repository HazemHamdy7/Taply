import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

Future<void> _assertGolden(
  WidgetTester tester,
  RenderPaintNode node,
  String goldenName,
) async {
  final painter = PathPainter();
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 200, height: 200,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _PathGoldenPainter(painter, node),
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

class _PathGoldenPainter extends CustomPainter {
  final PathPainter painter;
  final RenderPaintNode node;
  _PathGoldenPainter(this.painter, this.node);

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
  testWidgets('PathPainter golden - triangle fill', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g1', type: 'path',
      x: 0, y: 0, width: 200, height: 200,
      color: '#FF0000',
      properties: {
        'commands': [
          {'type': 'moveTo', 'x': 100, 'y': 10},
          {'type': 'lineTo', 'x': 180, 'y': 180},
          {'type': 'lineTo', 'x': 20, 'y': 180},
          {'type': 'closePath'},
        ],
      },
    ), 'path_triangle.png');
  });

  testWidgets('PathPainter golden - stroked', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g2', type: 'path',
      x: 0, y: 0, width: 200, height: 200,
      strokeWidth: 4, strokeColor: '#0000FF',
      properties: {
        'commands': [
          {'type': 'moveTo', 'x': 20, 'y': 100},
          {'type': 'lineTo', 'x': 180, 'y': 100},
        ],
      },
    ), 'path_stroked.png');
  });

  testWidgets('PathPainter golden - cubic bezier', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g3', type: 'path',
      x: 0, y: 0, width: 200, height: 200,
      color: '#FF0000',
      properties: {
        'commands': [
          {'type': 'moveTo', 'x': 20, 'y': 100},
          {'type': 'cubicTo', 'controlX1': 60, 'controlY1': 20, 'controlX2': 140, 'controlY2': 180, 'x': 180, 'y': 100},
        ],
      },
    ), 'path_cubic.png');
  });

  testWidgets('PathPainter golden - shadow', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g4', type: 'path',
      x: 0, y: 0, width: 200, height: 200,
      color: '#FF8800',
      properties: {
        'commands': [
          {'type': 'moveTo', 'x': 100, 'y': 20},
          {'type': 'lineTo', 'x': 180, 'y': 170},
          {'type': 'lineTo', 'x': 20, 'y': 170},
          {'type': 'closePath'},
        ],
        'shadows': [
          {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
        ],
      },
    ), 'path_shadow.png');
  });
}
