/// Provides image assets to the engine.
class ImageProvider {
  /// Preloads an image from [path] into memory.
  Future<void> preload(String path) {
    throw UnimplementedError('ImageProvider.preload');
  }

  /// Releases a preloaded image from memory.
  void evict(String path) {
    throw UnimplementedError('ImageProvider.evict');
  }
}
