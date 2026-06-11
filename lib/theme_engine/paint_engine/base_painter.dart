import '../renderer/render_node.dart';
import 'paint_capabilities.dart';
import 'paint_context.dart';
import 'paint_result.dart';

abstract class BasePainter {
  String get type;

  PaintCapabilities get capabilities;

  bool canPaint(RenderPaintNode node);

  void initialize();

  void prepare(PaintContext context);

  PaintResult paint(PaintContext context);

  void dispose();
}
