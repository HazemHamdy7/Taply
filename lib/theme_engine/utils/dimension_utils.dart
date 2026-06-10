/// Utility methods for dimension parsing and conversion.
class DimensionUtils {
  DimensionUtils._();

  /// Parses a dimension value which may be an absolute number or a
  /// percentage string (e.g., `"50%"`) relative to [reference].
  static double parse(String value, double reference) {
    throw UnimplementedError('DimensionUtils.parse');
  }

  /// Scales a design-space value by [scaleFactor].
  static double scale(double value, double scaleFactor) {
    throw UnimplementedError('DimensionUtils.scale');
  }

  /// Clamps [value] between [min] and [max].
  static double clamp(double value, double min, double max) {
    throw UnimplementedError('DimensionUtils.clamp');
  }

  /// Converts millimeters to logical pixels at the given [dpi].
  static double mmToPx(double mm, double dpi) {
    throw UnimplementedError('DimensionUtils.mmToPx');
  }

  /// Converts inches to logical pixels at the given [dpi].
  static double inchesToPx(double inches, double dpi) {
    throw UnimplementedError('DimensionUtils.inchesToPx');
  }

  /// Converts points (typographic) to logical pixels at the given [dpi].
  static double ptToPx(double pt, double dpi) {
    throw UnimplementedError('DimensionUtils.ptToPx');
  }
}
