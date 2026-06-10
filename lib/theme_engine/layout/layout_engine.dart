import '../interfaces/layout_engine_interface.dart';
import '../models/theme_scene.dart';
import '../models/layout_mode.dart';
import '../interfaces/scene_graph_interface.dart';

/// Default implementation of [ILayoutEngine].
///
/// Computes positions and sizes from the scene definition and viewport.
class LayoutEngine implements ILayoutEngine {
  @override
  SceneNode computeLayout(
    ThemeScene scene,
    double viewportWidth,
    double viewportHeight,
  ) {
    throw UnimplementedError('LayoutEngine.computeLayout');
  }

  @override
  double computeWidth(LayoutMode mode, double designWidth, double viewportWidth) {
    throw UnimplementedError('LayoutEngine.computeWidth');
  }

  @override
  double computeHeight(LayoutMode mode, double designHeight, double viewportHeight) {
    throw UnimplementedError('LayoutEngine.computeHeight');
  }

  @override
  double computeScaleFactor(
    LayoutMode mode,
    double designWidth,
    double designHeight,
    double viewportWidth,
    double viewportHeight,
  ) {
    throw UnimplementedError('LayoutEngine.computeScaleFactor');
  }
}
