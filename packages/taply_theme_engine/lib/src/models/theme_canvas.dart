/// Configuration for the rendering canvas.
class ThemeCanvas {
  final double width;
  final double height;
  final double? scaleFactor;

  const ThemeCanvas({
    required this.width,
    required this.height,
    this.scaleFactor,
  });
}
