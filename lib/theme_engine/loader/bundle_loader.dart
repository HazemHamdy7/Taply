import '../models/theme_document.dart';

/// Loads themes from the app bundle.
class BundleLoader {
  /// Loads a theme from a bundled asset path.
  Future<ThemeDocument> load(String assetPath) {
    throw UnimplementedError('BundleLoader.load');
  }

  /// Lists available theme asset paths in the bundle.
  Future<List<String>> listAvailable() {
    throw UnimplementedError('BundleLoader.listAvailable');
  }
}
