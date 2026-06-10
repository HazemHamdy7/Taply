import 'package:freezed_annotation/freezed_annotation.dart';
import 'transform.dart';
import 'layout_constraint.dart';
import 'shadow_definition.dart';
import 'gradient_definition.dart';

part 'scene_node.freezed.dart';

@Freezed(fromJson: false, toJson: false)
sealed class SceneNode with _$SceneNode {
  const factory SceneNode.group({
    required String id,
    String? name,
    @Default(true) bool visible,
    @Default(1.0) double opacity,
    @Default([]) List<SceneNode> children,
    @Default({}) Map<String, dynamic> properties,
  }) = GroupNode;

  const factory SceneNode.paint({
    required String id,
    required String type,
    String? name,
    @Default(true) bool visible,
    @Default(1.0) double opacity,
    @Default(0) int zIndex,
    @Default(Transform()) Transform transform,
    LayoutConstraint? constraints,
    String? color,
    GradientDefinition? gradient,
    double? strokeWidth,
    String? strokeColor,
    @Default([]) List<ShadowDefinition> shadows,
    @Default({}) Map<String, dynamic> properties,
  }) = PaintNode;

  const factory SceneNode.widget({
    required String id,
    required String type,
    String? name,
    @Default(true) bool visible,
    @Default(1.0) double opacity,
    @Default(0) int zIndex,
    @Default(Transform()) Transform transform,
    LayoutConstraint? constraints,
    String? field,
    double? fontSize,
    String? color,
    String? fontWeight,
    double? maxLines,
    double? size,
    String? shape,
    @Default([]) List<ShadowDefinition> shadows,
    @Default({}) Map<String, dynamic> properties,
  }) = WidgetNode;

  @override
  String get id;
  @override
  String? get name;
  @override
  bool get visible;
  @override
  double get opacity;
  @override
  Map<String, dynamic> get properties;
}

class SceneNodeConverter
    implements JsonConverter<SceneNode, Map<String, dynamic>> {
  const SceneNodeConverter();

  @override
  SceneNode fromJson(Map<String, dynamic> json) {
    final kind = json['kind'] as String;
    switch (kind) {
      case 'group':
        return GroupNode(
          id: json['id'] as String,
          name: json['name'] as String?,
          visible: json['visible'] as bool? ?? true,
          opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
          children: (json['children'] as List<dynamic>?)
                  ?.map(
                      (e) => SceneNodeConverter().fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
          properties: Map<String, dynamic>.from(json['properties'] as Map? ?? {}),
        );
      case 'paint':
        return PaintNode(
          id: json['id'] as String,
          type: json['type'] as String,
          name: json['name'] as String?,
          visible: json['visible'] as bool? ?? true,
          opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
          zIndex: json['zIndex'] as int? ?? 0,
          transform: json['transform'] != null
              ? Transform.fromJson(json['transform'] as Map<String, dynamic>)
              : const Transform(),
          constraints: json['constraints'] != null
              ? LayoutConstraint.fromJson(json['constraints'] as Map<String, dynamic>)
              : null,
          color: json['color'] as String?,
          gradient: json['gradient'] != null
              ? GradientDefinition.fromJson(json['gradient'] as Map<String, dynamic>)
              : null,
          strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
          strokeColor: json['strokeColor'] as String?,
          shadows: (json['shadows'] as List<dynamic>?)
                  ?.map((e) => ShadowDefinition.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
          properties: Map<String, dynamic>.from(json['properties'] as Map? ?? {}),
        );
      case 'widget':
        return WidgetNode(
          id: json['id'] as String,
          type: json['type'] as String,
          name: json['name'] as String?,
          visible: json['visible'] as bool? ?? true,
          opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
          zIndex: json['zIndex'] as int? ?? 0,
          transform: json['transform'] != null
              ? Transform.fromJson(json['transform'] as Map<String, dynamic>)
              : const Transform(),
          constraints: json['constraints'] != null
              ? LayoutConstraint.fromJson(json['constraints'] as Map<String, dynamic>)
              : null,
          field: json['field'] as String?,
          fontSize: (json['fontSize'] as num?)?.toDouble(),
          color: json['color'] as String?,
          fontWeight: json['fontWeight'] as String?,
          maxLines: (json['maxLines'] as num?)?.toDouble(),
          size: (json['size'] as num?)?.toDouble(),
          shape: json['shape'] as String?,
          shadows: (json['shadows'] as List<dynamic>?)
                  ?.map((e) => ShadowDefinition.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
          properties: Map<String, dynamic>.from(json['properties'] as Map? ?? {}),
        );
      default:
        throw ArgumentError('Unknown SceneNode kind: $kind');
    }
  }

  @override
  Map<String, dynamic> toJson(SceneNode node) {
    return node.when(
      group: (id, name, visible, opacity, children, properties) {
        return {
          'kind': 'group',
          'id': id,
          'name': name,
          'visible': visible,
          'opacity': opacity,
          'children': children.map((c) => SceneNodeConverter().toJson(c)).toList(),
          'properties': properties,
        };
      },
      paint: (id, type, name, visible, opacity, zIndex, transform,
          constraints, color, gradient, strokeWidth, strokeColor,
          shadows, properties) {
        return {
          'kind': 'paint',
          'id': id,
          'type': type,
          'name': name,
          'visible': visible,
          'opacity': opacity,
          'zIndex': zIndex,
          'transform': transform.toJson(),
          'constraints': constraints?.toJson(),
          'color': color,
          'gradient': gradient?.toJson(),
          'strokeWidth': strokeWidth,
          'strokeColor': strokeColor,
          'shadows': shadows.map((s) => s.toJson()).toList(),
          'properties': properties,
        };
      },
      widget: (id, type, name, visible, opacity, zIndex, transform,
          constraints, field, fontSize, color, fontWeight, maxLines, size,
          shape, shadows, properties) {
        return {
          'kind': 'widget',
          'id': id,
          'type': type,
          'name': name,
          'visible': visible,
          'opacity': opacity,
          'zIndex': zIndex,
          'transform': transform.toJson(),
          'constraints': constraints?.toJson(),
          'field': field,
          'fontSize': fontSize,
          'color': color,
          'fontWeight': fontWeight,
          'maxLines': maxLines,
          'size': size,
          'shape': shape,
          'shadows': shadows.map((s) => s.toJson()).toList(),
          'properties': properties,
        };
      },
    );
  }
}
