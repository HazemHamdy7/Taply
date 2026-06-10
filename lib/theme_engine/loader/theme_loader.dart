import '../interfaces/theme_loader_interface.dart';
import '../models/theme_document.dart';

/// Default implementation of [IThemeLoader].
///
/// Loads themes from the app bundle, file system, and network.
class ThemeLoader implements IThemeLoader {
  @override
  Future<ThemeDocument> load(String themeId) {
    throw UnimplementedError('ThemeLoader.load');
  }

  @override
  Future<ThemeDocument> loadFromString(String jsonString) {
    throw UnimplementedError('ThemeLoader.loadFromString');
  }

  @override
  Future<ThemeDocument> loadFromFile(String filePath) {
    throw UnimplementedError('ThemeLoader.loadFromFile');
  }

  @override
  Future<ThemeDocument> loadFromUrl(String url) {
    throw UnimplementedError('ThemeLoader.loadFromUrl');
  }

  @override
  Future<ThemeDocument> loadFromBundle(String assetPath) {
    throw UnimplementedError('ThemeLoader.loadFromBundle');
  }

  @override
  Future<List<String>> listAvailable() {
    throw UnimplementedError('ThemeLoader.listAvailable');
  }
}
