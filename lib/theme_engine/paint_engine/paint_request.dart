import '../renderer/render_node.dart';
import 'paint_context.dart';

class PaintRequest {
  final RenderPaintNode node;
  final PaintContext context;
  final bool useCache;

  const PaintRequest({
    required this.node,
    required this.context,
    this.useCache = true,
  });

  PaintRequest copyWith({
    RenderPaintNode? node,
    PaintContext? context,
    bool? useCache,
  }) {
    return PaintRequest(
      node: node ?? this.node,
      context: context ?? this.context,
      useCache: useCache ?? this.useCache,
    );
  }
}
