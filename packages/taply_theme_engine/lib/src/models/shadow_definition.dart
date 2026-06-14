/// Defines a shadow effect for use in paint operations.
class ShadowDefinition {
  final String? color;
  final double offsetX;
  final double offsetY;
  final double blurRadius;
  final double opacity;
  final String? id;

  const ShadowDefinition({
    this.color,
    this.offsetX = 0,
    this.offsetY = 4,
    this.blurRadius = 4.0,
    this.opacity = 0.3,
    this.id,
  });
}
