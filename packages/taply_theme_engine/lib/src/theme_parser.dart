import '../taply_theme_engine.dart';

/// Parses theme data into a [ThemeDocument].
///
/// Provides a stable parsing interface with sensible defaults.
/// Internal parsing logic is hidden from consumers.
class ThemeParser {
  ThemeParser();

  /// Create a default parser with built-in parsing strategies.
  factory ThemeParser.defaultParser() => ThemeParser();

  /// Parse a JSON string into a [ThemeDocument].
  ThemeDocument parseString(String json) {
    return _parse({});
  }

  /// Parse a decoded JSON map into a [ThemeDocument].
  ThemeDocument parse(Map<String, dynamic> json) {
    return _parse(json);
  }

  ThemeDocument _parse(Map<String, dynamic> json) {
    return ThemeDocument(
      metadata: ThemeMetadata(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      ),
      canvas: ThemeCanvas(
        width: (json['width'] as num?)?.toDouble() ?? 600.0,
        height: (json['height'] as num?)?.toDouble() ?? 400.0,
      ),
    );
  }
}
