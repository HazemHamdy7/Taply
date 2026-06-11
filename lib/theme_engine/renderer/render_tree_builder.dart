import '../models/theme_canvas.dart';
import '../models/theme_document.dart';
import '../models/theme_scene.dart';
import '../models/scene_node.dart';
import 'node_handler.dart';
import 'node_handlers.dart';
import 'render_context.dart';
import 'render_node.dart';
import 'render_tree.dart';

/// Builds a [RenderTree] from a parsed [ThemeDocument].
///
/// Converts the [SceneNode] tree into a [RenderNode] tree by delegating
/// each node to a registered [NodeHandler]. No switch on node type
/// exists in this class; all dispatch goes through [NodeHandlerRegistry].
class RenderTreeBuilder {
  final NodeHandlerRegistry handlers;

  RenderTreeBuilder({NodeHandlerRegistry? handlers})
      : handlers = handlers ?? _createDefaultHandlers();

  static NodeHandlerRegistry _createDefaultHandlers() {
    final registry = NodeHandlerRegistry();
    registry.register('group', GroupNodeHandler());
    registry.register('paint', PaintNodeHandler());
    registry.register('widget', WidgetNodeHandler());
    return registry;
  }

  void registerHandler(String key, NodeHandler handler) {
    handlers.register(key, handler);
  }

  RenderTree build(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    final scaleFactor = _computeScaleFactor(
      document.canvas.layoutMode,
      document.canvas.width,
      document.canvas.height,
      viewportWidth,
      viewportHeight,
    );

    final context = RenderContext(
      document: document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      scaleFactor: scaleFactor,
      handlers: handlers,
    );

    final root = _buildRoot(document.scene, context);

    return RenderTree(
      canvasWidth: document.canvas.width,
      canvasHeight: document.canvas.height,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      layoutMode: document.canvas.layoutMode,
      scaleFactor: scaleFactor,
      root: root,
    );
  }

  RenderGroup _buildRoot(ThemeScene scene, RenderContext context) {
    final children = scene.nodes
        .map((node) => handlers.convert(node, context))
        .toList();

    return RenderGroup(
      id: scene.id,
      name: scene.label,
      children: children,
    );
  }

  double _computeScaleFactor(
    LayoutMode mode,
    double designWidth,
    double designHeight,
    double viewportWidth,
    double viewportHeight,
  ) {
    if (designWidth <= 0 || designHeight <= 0) return 1.0;
    switch (mode) {
      case LayoutMode.fill:
        return (viewportWidth / designWidth)
            .clamp(0.0, viewportHeight / designHeight);
      case LayoutMode.fit:
        final sx = viewportWidth / designWidth;
        final sy = viewportHeight / designHeight;
        return sx < sy ? sx : sy;
      case LayoutMode.stretch:
        return 1.0;
      case LayoutMode.fillAllEdges:
        final sx = viewportWidth / designWidth;
        final sy = viewportHeight / designHeight;
        return sx > sy ? sx : sy;
      case LayoutMode.centered:
        return 1.0;
    }
  }
}
