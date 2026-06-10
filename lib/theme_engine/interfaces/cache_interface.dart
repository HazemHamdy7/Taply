import '../models/theme_document.dart';

/// Interface for theme caching.
abstract class IThemeCache {
  /// Retrieves a cached theme by [themeId].
  /// Returns `null` if not cached or expired.
  ThemeDocument? get(String themeId);

  /// Stores a [theme] in the cache under [themeId].
  void set(String themeId, ThemeDocument theme);

  /// Removes a theme from the cache.
  void remove(String themeId);

  /// Clears all cached themes.
  void clear();

  /// Returns `true` if the cache contains [themeId] and it is not expired.
  bool contains(String themeId);

  /// Returns the number of cached entries.
  int get count;
}
