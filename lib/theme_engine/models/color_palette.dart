import 'package:meta/meta.dart';

/// A color palette entry.
@immutable
class ColorSwatch {
  /// The unique identifier for this swatch.
  final String id;

  /// The hex color value (e.g., `"#FF0000"`).
  final String color;

  /// Optional label for the swatch.
  final String? label;

  /// Creates a [ColorSwatch].
  const ColorSwatch({
    required this.id,
    required this.color,
    this.label,
  });

  /// Creates a [ColorSwatch] from a JSON map.
  factory ColorSwatch.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ColorSwatch.fromJson');
  }

  /// Converts this swatch to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ColorSwatch.toJson');
  }
}

/// Defines the color palette for a theme.
@immutable
class ColorPalette {
  /// The list of color swatches in this palette.
  final List<ColorSwatch> swatches;

  /// The blend mode used for overlapping colors.
  final String? blendMode;

  /// Creates a [ColorPalette].
  const ColorPalette({
    this.swatches = const [],
    this.blendMode,
  });

  /// Creates a [ColorPalette] from a JSON map.
  factory ColorPalette.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ColorPalette.fromJson');
  }

  /// Converts this palette to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ColorPalette.toJson');
  }
}
