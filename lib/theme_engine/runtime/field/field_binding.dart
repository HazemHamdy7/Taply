import '../../renderer/render_node.dart';
import 'data_provider.dart';
import 'expression_resolver.dart';
import 'field_resolver.dart';

class FieldBinding {
  final FieldResolver fieldResolver;
  final ExpressionResolver expressionResolver;

  FieldBinding({
    FieldResolver? fieldResolver,
    ExpressionResolver? expressionResolver,
  })  : fieldResolver = fieldResolver ?? FieldResolver(),
        expressionResolver = expressionResolver ?? ExpressionResolver();

  String resolve(String template, BusinessCardData data) {
    return fieldResolver.resolve(template, data, expressionResolver);
  }

  Map<String, dynamic> resolveProperties(
    Map<String, dynamic> properties,
    BusinessCardData data,
  ) {
    final resolved = <String, dynamic>{};
    for (final entry in properties.entries) {
      if (entry.value is String) {
        resolved[entry.key] = resolve(entry.value as String, data);
      } else if (entry.value is Map<String, dynamic>) {
        resolved[entry.key] = resolveProperties(
          entry.value as Map<String, dynamic>,
          data,
        );
      } else if (entry.value is List) {
        resolved[entry.key] = _resolveList(
          entry.value as List,
          data,
        );
      } else {
        resolved[entry.key] = entry.value;
      }
    }
    return resolved;
  }

  List _resolveList(List list, BusinessCardData data) {
    final result = <dynamic>[];
    for (final item in list) {
      if (item is String) {
        result.add(resolve(item, data));
      } else if (item is Map<String, dynamic>) {
        result.add(resolveProperties(item, data));
      } else if (item is List) {
        result.add(_resolveList(item, data));
      } else {
        result.add(item);
      }
    }
    return result;
  }

  RenderPaintNode bindNode(RenderPaintNode node, BusinessCardData data) {
    return RenderPaintNode(
      id: node.id,
      type: node.type,
      name: node.name,
      visible: node.visible,
      opacity: node.opacity,
      zIndex: node.zIndex,
      x: node.x,
      y: node.y,
      width: node.width,
      height: node.height,
      rotation: node.rotation,
      scaleX: node.scaleX,
      scaleY: node.scaleY,
      color: node.color,
      gradient: node.gradient,
      strokeWidth: node.strokeWidth,
      strokeColor: node.strokeColor,
      shadows: node.shadows,
      properties: resolveProperties(node.properties, data),
    );
  }

  RenderWidgetNode bindWidgetNode(RenderWidgetNode node, BusinessCardData data) {
    return RenderWidgetNode(
      id: node.id,
      type: node.type,
      name: node.name,
      visible: node.visible,
      opacity: node.opacity,
      zIndex: node.zIndex,
      x: node.x,
      y: node.y,
      width: node.width,
      height: node.height,
      rotation: node.rotation,
      scaleX: node.scaleX,
      scaleY: node.scaleY,
      field: node.field,
      fontSize: node.fontSize,
      color: node.color,
      fontWeight: node.fontWeight,
      maxLines: node.maxLines,
      size: node.size,
      shape: node.shape,
      properties: resolveProperties(node.properties, data),
    );
  }

  RenderNode bind(RenderNode node, BusinessCardData data) {
    if (node is RenderPaintNode) return bindNode(node, data);
    if (node is RenderWidgetNode) return bindWidgetNode(node, data);
    if (node is RenderGroup) {
      return RenderGroup(
        id: node.id,
        name: node.name,
        visible: node.visible,
        opacity: node.opacity,
        properties: resolveProperties(node.properties, data),
        children: node.children.map((c) => bind(c, data)).toList(),
      );
    }
    return node;
  }
}
