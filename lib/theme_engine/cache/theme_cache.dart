import '../interfaces/cache_interface.dart';
import '../models/theme_document.dart';

/// Default implementation of [IThemeCache].
///
/// An in-memory LRU-style cache for parsed [ThemeDocument] objects.
class ThemeCache implements IThemeCache {
  @override
  ThemeDocument? get(String themeId) {
    throw UnimplementedError('ThemeCache.get');
  }

  @override
  void set(String themeId, ThemeDocument theme) {
    throw UnimplementedError('ThemeCache.set');
  }

  @override
  void remove(String themeId) {
    throw UnimplementedError('ThemeCache.remove');
  }

  @override
  void clear() {
    throw UnimplementedError('ThemeCache.clear');
  }

  @override
  bool contains(String themeId) {
    throw UnimplementedError('ThemeCache.contains');
  }

  @override
  int get count {
    throw UnimplementedError('ThemeCache.count');
  }
}
