/// Provides font assets to the engine.
class FontProvider {
  /// Registers a font family from an asset path.
  Future<void> registerFont(String familyName, String assetPath) {
    throw UnimplementedError('FontProvider.registerFont');
  }

  /// Returns the list of registered font families.
  List<String> get registeredFamilies {
    throw UnimplementedError('FontProvider.registeredFamilies');
  }
}
