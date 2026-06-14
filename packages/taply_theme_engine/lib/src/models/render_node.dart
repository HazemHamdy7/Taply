import 'gradient_definition.dart';
import 'shadow_definition.dart';

/// Base class for all render tree nodes.
class RenderNode {
  final String id;
  final String? name;
  final bool visible;
  final double opacity;
  final Map<String, dynamic> properties;

  const RenderNode({
    required this.id,
    this.name,
    this.visible = true,
    this.opacity = 1.0,
    this.properties = const {},
  });
}

/// A node rendered by a painter (shapes, images, text).
class RenderPaintNode extends RenderNode {
  final String type;
  final int zIndex;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final String? color;
  final GradientDefinition? gradient;
  final double? strokeWidth;
  final String? strokeColor;
  final List<ShadowDefinition> shadows;

  const RenderPaintNode({
    required super.id,
    required this.type,
    super.name,
    super.visible,
    super.opacity,
    super.properties,
    this.zIndex = 0,
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
    this.rotation = 0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.color,
    this.gradient,
    this.strokeWidth,
    this.strokeColor,
    this.shadows = const [],
  });
}

/// A node rendered as a Flutter widget (text, fields, QR codes).
class RenderWidgetNode extends RenderNode {
  final String type;
  final int zIndex;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final String? field;
  final double? fontSize;
  final String? color;
  final String? fontWeight;
  final double? maxLines;
  final double? size;
  final String? shape;

  const RenderWidgetNode({
    required super.id,
    required this.type,
    super.name,
    super.visible,
    super.opacity,
    super.properties,
    this.zIndex = 0,
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
    this.rotation = 0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.field,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.size,
    this.shape,
  });
}
