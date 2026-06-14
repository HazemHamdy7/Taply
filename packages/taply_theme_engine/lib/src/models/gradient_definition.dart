/// Defines a gradient for use in paint operations.
class GradientDefinition {
  final String kind;
  final List<String> colors;
  final List<double>? stops;
  final double angle;
  final double radius;
  final double focalX;
  final double focalY;

  const GradientDefinition({
    required this.kind,
    required this.colors,
    this.stops,
    this.angle = 0,
    this.radius = 0.5,
    this.focalX = 0.5,
    this.focalY = 0.5,
  });
}
