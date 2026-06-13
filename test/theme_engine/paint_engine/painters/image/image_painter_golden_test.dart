import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/painters/image/image_painter.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

Future<void> _assertGolden(
  WidgetTester tester,
  RenderPaintNode node,
  String goldenName,
) async {
  final painter = ImagePainter();
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 200, height: 200,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _ImageGoldenPainter(painter, node),
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

class _ImageGoldenPainter extends CustomPainter {
  final ImagePainter painter;
  final RenderPaintNode node;
  _ImageGoldenPainter(this.painter, this.node);

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
  testWidgets('ImagePainter golden - placeholder', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'i1', type: 'image',
      x: 0, y: 0, width: 200, height: 200,
      color: '#E0E0E0',
    ), 'image_placeholder.png');
  });

  testWidgets('ImagePainter golden - rounded', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'i2', type: 'image',
      x: 0, y: 0, width: 200, height: 200,
      color: '#BBDEFB',
      properties: {'borderRadius': 30},
    ), 'image_rounded.png');
  });

  testWidgets('ImagePainter golden - circular', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'i3', type: 'image',
      x: 0, y: 0, width: 200, height: 200,
      color: '#C8E6C9',
      properties: {'circular': true},
    ), 'image_circular.png');
  });

  testWidgets('ImagePainter golden - bordered', (tester) async {
    await _assertGolden(tester, RenderPaintNode(
      id: 'i4', type: 'image',
      x: 0, y: 0, width: 200, height: 200,
      color: '#FFE0B2',
      properties: {
        'borderWidth': 6,
        'borderColor': '#E65100',
      },
    ), 'image_bordered.png');
  });
}
