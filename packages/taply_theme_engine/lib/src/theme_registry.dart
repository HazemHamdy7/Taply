import '../taply_theme_engine.dart';

/// Registry for painters, loaders, and plugins in the theme engine.
class ThemeRegistry {
  final Map<String, BasePainter> _painters = {};
  final Map<String, ThemeLoader> _loaders = {};
  final List<void Function()> _plugins = [];

  void registerPainter(String type, BasePainter painter) {
    _painters[type] = painter;
  }

  BasePainter? getPainter(String type) => _painters[type];

  List<String> get painterTypes => _painters.keys.toList();

  void registerLoader(ThemeLoader loader) {
    _loaders[loader.runtimeType.toString()] = loader;
  }

  List<ThemeLoader> get loaders => _loaders.values.toList();

  void registerPlugin(void Function() initializer) {
    _plugins.add(initializer);
  }

  void initialize() {
    for (final plugin in _plugins) {
      plugin();
    }
  }

  void dispose() {
    for (final painter in _painters.values) {
      painter.dispose();
    }
    _painters.clear();
    _loaders.clear();
    _plugins.clear();
  }
}
