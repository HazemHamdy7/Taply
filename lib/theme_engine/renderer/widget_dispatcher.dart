import '../interfaces/widget_factory_interface.dart';
import '../registry/widget_registry.dart';
import 'render_node.dart';

/// Dispatches [RenderWidgetNode] instances to registered [IWidgetFactory]s.
///
/// The [WidgetRegistry] maps widget type keys (e.g. `"text"`, `"image"`)
/// to [IWidgetFactory] implementations. The dispatcher looks up the
/// factory by [RenderWidgetNode.type] and delegates widget building.
class WidgetDispatcher {
  final WidgetRegistry registry;

  WidgetDispatcher({WidgetRegistry? registry})
      : registry = registry ?? WidgetRegistry.instance;

  /// Returns the [IWidgetFactory] registered for [node.type], or `null`
  /// if no factory is registered.
  IWidgetFactory? resolve(RenderWidgetNode node) => registry.get(node.type);

  /// Returns `true` if a factory is registered for [node.type].
  bool canHandle(RenderWidgetNode node) => registry.has(node.type);

  /// Returns all registered widget type keys.
  List<String> get registeredTypes => registry.registeredTypes;
}
