import 'dart:ui' show Canvas, Size;
import '../models/theme_scene.dart';

/// Orchestrates the full render pipeline: scene graph building, layout
/// computation, paint dispatch, and widget layer build.
class RenderPipeline {
  /// Renders a [scene] onto the given [canvas] within [size].
  ///
  /// Returns the list of computed layer positions for widget overlays.
  List<Rect> render(Canvas canvas, Size size, ThemeScene scene) {
    throw UnimplementedError('RenderPipeline.render');
  }
}

/// Bounding rectangle for a rendered layer.
class Rect {
  final double left;
  final double top;
  final double width;
  final double height;

  const Rect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
