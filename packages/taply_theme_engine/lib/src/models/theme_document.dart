import 'theme_metadata.dart';
import 'theme_canvas.dart';

/// A fully parsed theme document ready for rendering.
class ThemeDocument {
  final ThemeMetadata metadata;
  final ThemeCanvas canvas;
  final Map<String, dynamic> json;

  const ThemeDocument({
    required this.metadata,
    required this.canvas,
    this.json = const {},
  });
}
