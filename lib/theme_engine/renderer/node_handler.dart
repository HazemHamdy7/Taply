import '../models/scene_node.dart';
import '../registry/registry_base.dart';
import 'render_context.dart';
import 'render_node.dart';

/// Handles conversion of a single [SceneNode] variant into a [RenderNode].
///
/// Implementations are registered in [NodeHandlerRegistry] so that the
/// [RenderTreeBuilder] never needs a switch on node type. New node kinds
/// (e.g. plugin-provided) simply register their own handler.
abstract class NodeHandler {
  /// Returns `true` if this handler can convert [node].
  bool canHandle(SceneNode node);

  /// Converts [node] into a [RenderNode] using the given [context].
  RenderNode handle(SceneNode node, RenderContext context);
}

/// Registry of [NodeHandler] instances.
///
/// Dispatches SceneNode conversion by iterating registered handlers
/// and calling the first one whose [NodeHandler.canHandle] returns true.
class NodeHandlerRegistry extends RegistryBase<NodeHandler> {
  /// Converts [node] by finding a matching handler.
  ///
  /// Throws [StateError] if no handler can handle [node].
  RenderNode convert(SceneNode node, RenderContext context) {
    for (final handler in all) {
      if (handler.canHandle(node)) {
        return handler.handle(node, context);
      }
    }
    throw StateError('No handler registered for SceneNode (id=${node.id})');
  }
}
