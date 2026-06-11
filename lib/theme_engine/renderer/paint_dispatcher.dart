import '../interfaces/painter_interface.dart';
import '../registry/paint_registry.dart';
import 'render_node.dart';

/// Dispatches [RenderPaintNode] instances to registered [IPainter]s.
///
/// The [PaintRegistry] maps paint type keys (e.g. `"rect"`, `"circle"`)
/// to [IPainter] implementations. The dispatcher looks up the painter
/// by [RenderPaintNode.type] and delegates execution.
class PaintDispatcher {
  final PaintRegistry registry;

  PaintDispatcher({PaintRegistry? registry})
      : registry = registry ?? PaintRegistry.instance;

  /// Returns the [IPainter] registered for [node.type], or `null` if
  /// no painter is registered.
  IPainter? resolve(RenderPaintNode node) => registry.get(node.type);

  /// Returns `true` if a painter is registered for [node.type].
  bool canHandle(RenderPaintNode node) => registry.has(node.type);

  /// Returns all registered painter type keys.
  List<String> get registeredTypes => registry.registeredTypes;
}
