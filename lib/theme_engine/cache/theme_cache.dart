import '../interfaces/cache_interface.dart';
import '../models/theme_document.dart';

class ThemeCache implements IThemeCache {
  final Map<String, ThemeDocument> _cache = {};
  final int maxSize;

  ThemeCache({this.maxSize = 50});

  @override
  ThemeDocument? get(String themeId) => _cache[themeId];

  @override
  void set(String themeId, ThemeDocument theme) {
    if (_cache.length >= maxSize) {
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }
    _cache[themeId] = theme;
  }

  @override
  void remove(String themeId) {
    _cache.remove(themeId);
  }

  @override
  void clear() {
    _cache.clear();
  }

  @override
  bool contains(String themeId) => _cache.containsKey(themeId);

  @override
  int get count => _cache.length;
}
