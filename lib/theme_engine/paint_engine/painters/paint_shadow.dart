import 'dart:ui' show Color;

class PaintShadow {
  final Color color;
  final double offsetX;
  final double offsetY;
  final double blurRadius;
  final double opacity;

  const PaintShadow({
    required this.color,
    this.offsetX = 0,
    this.offsetY = 4,
    this.blurRadius = 4.0,
    this.opacity = 0.3,
  });

  PaintShadow scale(double factor) => PaintShadow(
    color: color, offsetX: offsetX * factor,
    offsetY: offsetY * factor, blurRadius: blurRadius * factor,
    opacity: opacity,
  );

  @override
  String toString() =>
      'PaintShadow(offset: $offsetX,$offsetY blur: $blurRadius opacity: $opacity)';
}
