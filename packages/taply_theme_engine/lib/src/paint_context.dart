import 'dart:ui' show Canvas, Rect;

/// Context provided to painters during a paint operation.
class PaintContext {
  final Canvas canvas;
  final Rect viewport;
  final double opacity;
  final Map<String, dynamic> themeData;
  final Map<String, dynamic> bindings;

  const PaintContext({
    required this.canvas,
    required this.viewport,
    this.opacity = 1.0,
    this.themeData = const {},
    this.bindings = const {},
  });
}
