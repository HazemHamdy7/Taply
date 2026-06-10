import '../models/scene_node.dart';
import '../models/theme_scene.dart';
import '../models/theme_canvas.dart';

/// Interface for the layout engine that computes positions and sizes.
abstract class ILayoutEngine {
  /// Computes the layout for [scene] at the given [viewportWidth] and
  /// [viewportHeight]. Returns the root [SceneNode] with computed
  /// positions.
  SceneNode computeLayout(ThemeScene scene, double viewportWidth, double viewportHeight);

  /// Returns the computed width for a given [layoutMode] and dimensions.
  double computeWidth(LayoutMode mode, double designWidth, double viewportWidth);

  /// Returns the computed height for a given [layoutMode] and dimensions.
  double computeHeight(LayoutMode mode, double designHeight, double viewportHeight);

  /// Computes the scale factor between design space and viewport space.
  double computeScaleFactor(
    LayoutMode mode,
    double designWidth,
    double designHeight,
    double viewportWidth,
    double viewportHeight,
  );
}
