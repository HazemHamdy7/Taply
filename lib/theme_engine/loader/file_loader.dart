import '../models/theme_document.dart';

/// Loads themes from the local file system.
class FileLoader {
  /// Loads a theme from a file path.
  Future<ThemeDocument> load(String filePath) {
    throw UnimplementedError('FileLoader.load');
  }

  /// Lists available theme files in a directory.
  Future<List<String>> listAvailable(String directoryPath) {
    throw UnimplementedError('FileLoader.listAvailable');
  }
}
