import '../models/theme_document.dart';

/// Interface for theme loading from various sources.
abstract class IThemeLoader {
  /// Loads a theme by its identifier.
  ///
  /// Throws [ThemeLoadException] if the theme cannot be loaded.
  Future<ThemeDocument> load(String themeId);

  /// Loads a theme from a raw JSON string.
  Future<ThemeDocument> loadFromString(String jsonString);

  /// Loads a theme from a file at [filePath].
  Future<ThemeDocument> loadFromFile(String filePath);

  /// Loads a theme from a network URL.
  Future<ThemeDocument> loadFromUrl(String url);

  /// Loads a theme from the app bundle.
  Future<ThemeDocument> loadFromBundle(String assetPath);

  /// Returns a list of all available theme identifiers.
  Future<List<String>> listAvailable();
}
