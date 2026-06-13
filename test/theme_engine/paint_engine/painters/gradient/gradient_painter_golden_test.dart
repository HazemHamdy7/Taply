import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/gradient/gradient_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

Future<void> _assertGolden(
  WidgetTester tester,
  RenderPaintNode node,
  String goldenName,
) async {
  final painter = GradientPainter();
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 200, height: 200,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _GradientGoldenPainter(painter, node),
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

class _GradientGoldenPainter extends CustomPainter {
  final GradientPainter painter;
  final RenderPaintNode node;
  _GradientGoldenPainter(this.painter, this.node);

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
  testWidgets('GradientPainter golden - linear', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g1', type: 'gradient',
      x: 0, y: 0, width: 200, height: 200,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#FF0000', '#0000FF'],
        'angle': 45,
      },
    ), 'gradient_linear.png');
  });

  testWidgets('GradientPainter golden - radial', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g2', type: 'gradient',
      x: 0, y: 0, width: 200, height: 200,
      properties: {
        'gradientKind': 'radial',
        'gradientColors': ['#00FF00', '#0000FF'],
      },
    ), 'gradient_radial.png');
  });

  testWidgets('GradientPainter golden - sweep', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g3', type: 'gradient',
      x: 0, y: 0, width: 200, height: 200,
      properties: {
        'gradientKind': 'sweep',
        'gradientColors': ['#FF0000', '#FFFF00', '#00FF00', '#0000FF', '#FF00FF'],
      },
    ), 'gradient_sweep.png');
  });

  testWidgets('GradientPainter golden - rounded', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'g4', type: 'gradient',
      x: 0, y: 0, width: 200, height: 200,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#FF6F00', '#FFB74D'],
        'angle': 135,
        'borderRadius': 30,
      },
    ), 'gradient_rounded.png');
  });
}
