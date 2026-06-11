import '../renderer/render_node.dart';
import 'base_painter.dart';
import 'paint_exception.dart';
import 'paint_registry.dart';

class PainterResolver {
  final PaintRegistry registry;

  PainterResolver({PaintRegistry? registry})
      : registry = registry ?? PaintRegistry.instance;

  BasePainter? resolve(RenderPaintNode node) => registry.resolve(node.type);

  bool canResolve(RenderPaintNode node) => registry.contains(node.type);

  BasePainter requireResolve(RenderPaintNode node) {
    final painter = resolve(node);
    if (painter == null) {
      throw PaintException(
        'No painter registered for type "${node.type}"',
        type: node.type,
      );
    }
    return painter;
  }

  List<String> get registeredTypes => registry.registeredTypes;
}
