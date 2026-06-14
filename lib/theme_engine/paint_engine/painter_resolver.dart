import '../renderer/render_node.dart';
import 'base_painter.dart';
import 'paint_registry.dart';
import 'painters/unsupported_painter.dart';

class PainterResolver {
  final PaintRegistry registry;
  final UnsupportedPainter _fallback;

  PainterResolver({PaintRegistry? registry, bool debug = false})
      : registry = registry ?? PaintRegistry.instance,
        _fallback = UnsupportedPainter(debug: debug);

  BasePainter? resolve(RenderPaintNode node) => registry.resolve(node.type);

  bool canResolve(RenderPaintNode node) => registry.contains(node.type);

  BasePainter requireResolve(RenderPaintNode node) {
    return resolve(node) ?? _fallback;
  }

  List<String> get registeredTypes => registry.registeredTypes;
}
