import 'package:meta/meta.dart';
import 'layout_mode.dart';
import 'scene_layer.dart';

/// A scene within a theme, comprising a list of layers and layout settings.
@immutable
class ThemeScene {
  /// The unique identifier for this scene.
  final String id;

  /// The label for this scene.
  final String? label;

  /// The layout mode for this scene.
  final LayoutMode layoutMode;

  /// The canvas width in design logical pixels.
  final double width;

  /// The canvas height in design logical pixels.
  final double height;

  /// The corner radius for the scene canvas.
  final double cornerRadius;

  /// The layers that make up this scene.
  final List<SceneLayer> layers;

  /// Creates a [ThemeScene].
  const ThemeScene({
    required this.id,
    this.label,
    this.layoutMode = LayoutMode.centered,
    this.width = 1000,
    this.height = 600,
    this.cornerRadius = 0,
    this.layers = const [],
  });

  /// Creates a [ThemeScene] from a JSON map.
  factory ThemeScene.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeScene.fromJson');
  }

  /// Converts this scene to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ThemeScene.toJson');
  }
}
