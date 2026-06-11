import '../models/theme_document.dart';
import '../models/theme_canvas.dart';
import 'node_handler.dart';

/// Context passed through the render tree building process.
///
/// Carries the parsed [ThemeDocument], the viewport dimensions, the
/// computed [scaleFactor], and the [NodeHandlerRegistry] so that every
/// node converter can recursively convert child nodes through the
/// same registry.
class RenderContext {
  /// The fully parsed theme document.
  final ThemeDocument document;

  /// The viewport width in logical pixels.
  final double viewportWidth;

  /// The viewport height in logical pixels.
  final double viewportHeight;

  /// The design-to-viewport scale factor.
  final double scaleFactor;

  /// The node handler registry for recursive conversion.
  final NodeHandlerRegistry handlers;

  /// Creates a [RenderContext].
  const RenderContext({
    required this.document,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.scaleFactor,
    required this.handlers,
  });

  /// The theme canvas definition (convenience getter).
  ThemeCanvas get canvas => document.canvas;

  /// The design canvas width.
  double get designWidth => canvas.width;

  /// The design canvas height.
  double get designHeight => canvas.height;

  /// The layout mode.
  LayoutMode get layoutMode => canvas.layoutMode;
}
