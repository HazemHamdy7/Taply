import 'render_node.dart';
import 'render_group.dart';

/// The root of the render tree.
class RenderTree {
  final double canvasWidth;
  final double canvasHeight;
  final double viewportWidth;
  final double viewportHeight;
  final double scaleFactor;
  final RenderGroup root;

  const RenderTree({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.scaleFactor,
    required this.root,
  });

  List<RenderNode> flatten() {
    final result = <RenderNode>[];
    _flattenNode(root, result);
    result.sort((a, b) {
      final za = a is RenderPaintNode
          ? a.zIndex
          : a is RenderWidgetNode
              ? a.zIndex
              : 0;
      final zb = b is RenderPaintNode
          ? b.zIndex
          : b is RenderWidgetNode
              ? b.zIndex
              : 0;
      return za.compareTo(zb);
    });
    return result;
  }

  void _flattenNode(RenderNode node, List<RenderNode> result) {
    if (node is RenderGroup) {
      for (final child in node.children) {
        _flattenNode(child, result);
      }
    } else {
      result.add(node);
    }
  }
}
