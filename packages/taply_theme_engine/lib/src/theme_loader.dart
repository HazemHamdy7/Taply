/// Interface for theme loading implementations.
///
/// Implement this to provide custom theme loading strategies
/// (e.g. from network, local storage, or bundled assets).
abstract class ThemeLoader {
  /// Load a theme by its unique identifier.
  Future<String> load(String themeId);

  /// List all available theme identifiers.
  Future<List<String>> listThemes();

  /// Whether this loader can handle the given [themeId].
  bool supports(String themeId);
}
