import 'dart:ui' show Color, Paint, PaintingStyle, Rect;

import '../../renderer/render_node.dart';
import '../base_painter.dart';
import '../paint_capabilities.dart';
import '../paint_context.dart';
import '../paint_result.dart';

class UnsupportedPainter extends BasePainter {
  final bool debug;

  UnsupportedPainter({this.debug = false});

  @override
  String get type => '_unsupported';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.basic;

  @override
  bool canPaint(RenderPaintNode node) => true;

  @override
  void initialize() {}

  @override
  void prepare(PaintContext context) {}

  @override
  PaintResult paint(PaintContext context) {
    final node = context.renderNode;
    final sw = Stopwatch()..start();

    if (!debug || context.canvas == null) {
      sw.stop();
      return PaintResult(success: true, duration: sw.elapsed, elementType: node.type,
        warnings: ['Unsupported type: ${node.type}']);
    }

    final canvas = context.canvas!;
    final rect = Rect.fromLTWH(node.x, node.y, node.width, node.height);

    if (rect.width > 0 && rect.height > 0) {
      final fill = Paint()
        ..color = const Color(0x18FF0000)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, fill);

      final border = Paint()
        ..color = const Color(0x88FF0000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRect(rect, border);
    }

    sw.stop();
    return PaintResult(success: true, duration: sw.elapsed, elementType: node.type,
      paintBounds: rect,
      warnings: ['Unsupported type rendered as placeholder: ${node.type}']);
  }

  @override
  void dispose() {}
}
