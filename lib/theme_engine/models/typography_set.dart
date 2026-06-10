import 'package:meta/meta.dart';

/// Defines the typography settings for a theme, including font families,
/// sizes, weights, and line heights.
@immutable
class TypographySet {
  /// The primary font family identifier.
  final String? primaryFontFamily;

  /// The secondary font family identifier.
  final String? secondaryFontFamily;

  /// Named text styles keyed by role (e.g., `"heading"`, `"body"`, `"caption"`).
  final Map<String, TextStyleDef> styles;

  /// Creates a [TypographySet].
  const TypographySet({
    this.primaryFontFamily,
    this.secondaryFontFamily,
    this.styles = const {},
  });

  /// Creates a [TypographySet] from a JSON map.
  factory TypographySet.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('TypographySet.fromJson');
  }

  /// Converts this set to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('TypographySet.toJson');
  }
}

/// A single text style definition.
@immutable
class TextStyleDef {
  /// The font size in logical pixels or points.
  final double? fontSize;

  /// The font weight (e.g., `"400"`, `"700"`).
  final String? fontWeight;

  /// The line height as a multiplier of font size.
  final double? lineHeight;

  /// The letter spacing in logical pixels.
  final double? letterSpacing;

  /// The text color as a hex string.
  final String? color;

  /// Creates a [TextStyleDef].
  const TextStyleDef({
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.letterSpacing,
    this.color,
  });

  /// Creates a [TextStyleDef] from a JSON map.
  factory TextStyleDef.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('TextStyleDef.fromJson');
  }

  /// Converts this definition to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('TextStyleDef.toJson');
  }
}
