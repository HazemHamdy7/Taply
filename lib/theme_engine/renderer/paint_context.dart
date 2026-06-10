import 'dart:ui' show Canvas, Size;

/// The context in which painting occurs, holding the current [Canvas],
/// [size], and computed [scaleFactor].
class PaintContext {
  /// The canvas to paint on.
  final Canvas canvas;

  /// The viewport size.
  final Size size;

  /// The design-to-viewport scale factor.
  final double scaleFactor;

  /// Creates a [PaintContext].
  const PaintContext({
    required this.canvas,
    required this.size,
    required this.scaleFactor,
  });
}
