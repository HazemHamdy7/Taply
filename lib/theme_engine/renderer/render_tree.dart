import '../models/theme_canvas.dart';
import 'render_node.dart';

/// The root of the render tree.
///
/// Holds the computed scene graph as a tree of [RenderNode] objects,
/// along with canvas and viewport metadata needed for painting.
class RenderTree {
  /// The design canvas width.
  final double canvasWidth;

  /// The design canvas height.
  final double canvasHeight;

  /// The viewport width at render time.
  final double viewportWidth;

  /// The viewport height at render time.
  final double viewportHeight;

  /// The canvas layout mode.
  final LayoutMode layoutMode;

  /// The design-to-viewport scale factor.
  final double scaleFactor;

  /// The root group of the render tree.
  final RenderGroup root;

  /// Creates a [RenderTree].
  const RenderTree({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.layoutMode,
    required this.scaleFactor,
    required this.root,
  });

  /// Flattens the tree into a list of non-group nodes in z-order.
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

  /// Finds a node by [id] using depth-first search.
  RenderNode? findById(String id) {
    return _findById(root, id);
  }

  RenderNode? _findById(RenderNode node, String id) {
    if (node.id == id) return node;
    if (node is RenderGroup) {
      for (final child in node.children) {
        final found = _findById(child, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}
