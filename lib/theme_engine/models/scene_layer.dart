import 'package:meta/meta.dart';

/// A scene layer within a theme scene.
///
/// Layers form a tree structure via their [children]. Each layer has a
/// [type] that determines how it is painted or which widget it renders.
@immutable
class SceneLayer {
  /// The unique identifier for this layer within the scene.
  final String id;

  /// The layer type (e.g., `"rect"`, `"text"`, `"image"`, `"group"`).
  final String type;

  /// The x position in design logical pixels.
  final double x;

  /// The y position in design logical pixels.
  final double y;

  /// The width in design logical pixels.
  final double? width;

  /// The height in design logical pixels.
  final double? height;

  /// The corner radius.
  final double? cornerRadius;

  /// The rotation in degrees.
  final double? rotation;

  /// The opacity (0.0 – 1.0).
  final double opacity;

  /// Whether this layer is visible.
  final bool visible;

  /// The z-index for stacking order.
  final int zIndex;

  /// Additional properties specific to the layer type.
  final Map<String, dynamic> properties;

  /// Child layers (for group-type layers).
  final List<SceneLayer> children;

  /// The field binding for dynamic content.
  final String? field;

  /// Creates a [SceneLayer].
  const SceneLayer({
    required this.id,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.width,
    this.height,
    this.cornerRadius,
    this.rotation,
    this.opacity = 1.0,
    this.visible = true,
    this.zIndex = 0,
    this.properties = const {},
    this.children = const [],
    this.field,
  });

  /// Creates a [SceneLayer] from a JSON map.
  factory SceneLayer.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('SceneLayer.fromJson');
  }

  /// Converts this layer to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('SceneLayer.toJson');
  }
}
