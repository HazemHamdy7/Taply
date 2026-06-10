import '../models/theme_document.dart';

/// Interface for theme JSON parsing.
abstract class IThemeParser {
  /// Parses a JSON map into a [ThemeDocument].
  ///
  /// Throws [ThemeParseException] if the JSON structure is invalid.
  ThemeDocument parse(Map<String, dynamic> json);

  /// Parses a raw JSON string into a [ThemeDocument].
  ThemeDocument parseString(String jsonString);

  /// Validates the JSON structure without building a full model.
  /// Returns a list of validation error messages (empty if valid).
  List<String> validate(Map<String, dynamic> json);
}
