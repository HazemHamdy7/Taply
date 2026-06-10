import 'package:meta/meta.dart';
import 'scene_layer.dart';

/// A theme state definition, describing a named variant of the scene
/// (e.g., folded, expanded, dark mode).
@immutable
class ThemeState {
  /// The unique identifier for this state.
  final String id;

  /// The layers that are active in this state.
  final List<SceneLayer> layers;

  /// Creates a [ThemeState].
  const ThemeState({
    required this.id,
    this.layers = const [],
  });

  /// Creates a [ThemeState] from a JSON map.
  factory ThemeState.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeState.fromJson');
  }

  /// Converts this state to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ThemeState.toJson');
  }
}
