import '../models/theme_document.dart';
import 'paint_dispatcher.dart';
import 'render_node.dart';
import 'render_tree.dart';
import 'render_tree_builder.dart';
import 'widget_dispatcher.dart';

/// Orchestrates the full rendering pipeline.
///
/// Stages:
/// 1. Build [RenderTree] from [ThemeDocument] via [RenderTreeBuilder]
/// 2. Prepare the tree (resolve painters/widgets, collect diagnostics)
/// 3. Return the prepared [RenderTree] for painting
///
/// No actual painting occurs here. The pipeline only prepares data
/// structures for downstream consumers (painters, widget builders).
class RenderPipeline {
  final RenderTreeBuilder treeBuilder;
  final PaintDispatcher paintDispatcher;
  final WidgetDispatcher widgetDispatcher;

  RenderPipeline({
    RenderTreeBuilder? treeBuilder,
    PaintDispatcher? paintDispatcher,
    WidgetDispatcher? widgetDispatcher,
  })  : treeBuilder = treeBuilder ?? RenderTreeBuilder(),
        paintDispatcher = paintDispatcher ?? PaintDispatcher(),
        widgetDispatcher = widgetDispatcher ?? WidgetDispatcher();

  /// Builds and prepares a [RenderTree] from [document].
  ///
  /// [viewportWidth] and [viewportHeight] define the rendering surface
  /// size and affect layout scaling.
  RenderTree prepare(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    final tree = treeBuilder.build(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );

    _resolvePainters(tree);
    _resolveWidgetBuilders(tree);

    return tree;
  }

  void _resolvePainters(RenderTree tree) {
    for (final node in tree.flatten()) {
      if (node is RenderPaintNode) {
        paintDispatcher.resolve(node);
      }
    }
  }

  void _resolveWidgetBuilders(RenderTree tree) {
    for (final node in tree.flatten()) {
      if (node is RenderWidgetNode) {
        widgetDispatcher.resolve(node);
      }
    }
  }

  /// Returns the list of registered paint type keys.
  List<String> get registeredPaintTypes => paintDispatcher.registeredTypes;

  /// Returns the list of registered widget type keys.
  List<String> get registeredWidgetTypes => widgetDispatcher.registeredTypes;
}
