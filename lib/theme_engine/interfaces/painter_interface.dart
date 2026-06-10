import 'dart:ui' show Canvas, Size;

/// Interface for a paint layer painter.
abstract class IPainter {
  /// The type identifier for this painter (e.g., `"rect"`, `"circle"`).
  String get type;

  /// Paints the layer onto [canvas] within the given [size].
  void paint(Canvas canvas, Size size, Map<String, dynamic> properties);

  /// Returns `true` if this painter can handle the given [type].
  bool supports(String type);
}
