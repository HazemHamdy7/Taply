import 'dart:ui' show Color;

/// Utility methods for color parsing and manipulation.
class ColorUtils {
  ColorUtils._();

  /// Parses a hex color string (e.g., `#FF0000`, `#FF0000@0.5`, `transparent`).
  static Color parse(String? value) {
    throw UnimplementedError('ColorUtils.parse');
  }

  /// Converts a [Color] to a hex string (e.g., `#FF0000`).
  static String toHex(Color color) {
    throw UnimplementedError('ColorUtils.toHex');
  }

  /// Converts a [Color] to a hex string with alpha (e.g., `#80FF0000`).
  static String toHexWithAlpha(Color color) {
    throw UnimplementedError('ColorUtils.toHexWithAlpha');
  }

  /// Blends [foreground] over [background] with the given [opacity].
  static Color blend(Color foreground, Color background, double opacity) {
    throw UnimplementedError('ColorUtils.blend');
  }

  /// Returns a darkened version of [color] by [fraction] (0.0 – 1.0).
  static Color darken(Color color, double fraction) {
    throw UnimplementedError('ColorUtils.darken');
  }

  /// Returns a lightened version of [color] by [fraction] (0.0 – 1.0).
  static Color lighten(Color color, double fraction) {
    throw UnimplementedError('ColorUtils.lighten');
  }

  /// Computes the relative luminance of [color] using the WCAG formula.
  static double relativeLuminance(Color color) {
    throw UnimplementedError('ColorUtils.relativeLuminance');
  }

  /// Returns the contrast ratio between two colors using WCAG 2.1.
  static double contrastRatio(Color a, Color b) {
    throw UnimplementedError('ColorUtils.contrastRatio');
  }

  /// Returns `true` if [color] is considered light (high luminance).
  static bool isLight(Color color) {
    throw UnimplementedError('ColorUtils.isLight');
  }
}
