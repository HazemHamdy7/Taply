import '../models/scene_node.dart';
import 'node_handler.dart';
import 'render_context.dart';
import 'render_node.dart';

/// Converts [GroupNode] to [RenderGroup].
class GroupNodeHandler extends NodeHandler {
  @override
  bool canHandle(SceneNode node) => node is GroupNode;

  @override
  RenderNode handle(SceneNode node, RenderContext context) {
    final group = node as GroupNode;
    return RenderGroup(
      id: group.id,
      name: group.name,
      visible: group.visible,
      opacity: group.opacity,
      properties: group.properties,
      children: group.children
          .map((child) => context.handlers.convert(child, context))
          .toList(),
    );
  }
}

/// Converts [PaintNode] to [RenderPaintNode].
class PaintNodeHandler extends NodeHandler {
  @override
  bool canHandle(SceneNode node) => node is PaintNode;

  @override
  RenderNode handle(SceneNode node, RenderContext context) {
    final paint = node as PaintNode;

    // Extract width/height from properties if present, else from transform
    final w = paint.properties['width'];
    final h = paint.properties['height'];
    final width = (w is num) ? w.toDouble() : paint.transform.scaleX;
    final height = (h is num) ? h.toDouble() : paint.transform.scaleY;

    return RenderPaintNode(
      id: paint.id,
      type: paint.type,
      name: paint.name,
      visible: paint.visible,
      opacity: paint.opacity,
      zIndex: paint.zIndex,
      x: paint.transform.x,
      y: paint.transform.y,
      width: width,
      height: height,
      rotation: paint.transform.rotation,
      scaleX: paint.transform.scaleX,
      scaleY: paint.transform.scaleY,
      color: paint.color,
      gradient: paint.gradient,
      strokeWidth: paint.strokeWidth,
      strokeColor: paint.strokeColor,
      shadows: paint.shadows,
      properties: paint.properties,
    );
  }
}

/// Converts [WidgetNode] to [RenderWidgetNode].
class WidgetNodeHandler extends NodeHandler {
  @override
  bool canHandle(SceneNode node) => node is WidgetNode;

  @override
  RenderNode handle(SceneNode node, RenderContext context) {
    final widget = node as WidgetNode;

    // Extract width/height from properties if present, else from transform
    final w = widget.properties['width'];
    final h = widget.properties['height'];
    final width = (w is num) ? w.toDouble() : widget.transform.scaleX;
    final height = (h is num) ? h.toDouble() : widget.transform.scaleY;

    return RenderWidgetNode(
      id: widget.id,
      type: widget.type,
      name: widget.name,
      visible: widget.visible,
      opacity: widget.opacity,
      zIndex: widget.zIndex,
      x: widget.transform.x,
      y: widget.transform.y,
      width: width,
      height: height,
      rotation: widget.transform.rotation,
      scaleX: widget.transform.scaleX,
      scaleY: widget.transform.scaleY,
      field: widget.field,
      fontSize: widget.fontSize,
      color: widget.color,
      fontWeight: widget.fontWeight,
      maxLines: widget.maxLines,
      size: widget.size,
      shape: widget.shape,
      properties: widget.properties,
    );
  }
}
