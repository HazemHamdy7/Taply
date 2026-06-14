import 'render_node.dart';

/// A group node that contains child [RenderNode]s.
class RenderGroup extends RenderNode {
  final List<RenderNode> children;

  const RenderGroup({
    required super.id,
    super.name,
    super.visible,
    super.opacity,
    super.properties,
    this.children = const [],
  });
}
