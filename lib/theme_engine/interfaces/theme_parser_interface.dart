import '../models/theme_document.dart';
import '../parser/parse_result.dart';

/// Interface for theme JSON parsing.
abstract class IThemeParser {
  /// Parses a JSON map into a [ThemeDocument].
  ///
  /// Throws [ParserException] if the JSON structure is invalid and
  /// strict mode is enabled, or on fatal errors.
  ThemeDocument parse(Map<String, dynamic> json);

  /// Parses a raw JSON string into a [ThemeDocument].
  ThemeDocument parseString(String jsonString);

  /// Parses JSON into a [ParseResult] with full diagnostic details.
  ///
  /// Returns success and diagnostics regardless of strict/lenient mode.
  ParseResult<ThemeDocument> parseWithResult(Map<String, dynamic> json);

  /// Validates the JSON structure without building a full model.
  /// Returns a list of error messages (empty if valid).
  List<String> validate(Map<String, dynamic> json);
}
