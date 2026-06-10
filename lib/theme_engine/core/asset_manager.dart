import '../interfaces/asset_provider_interface.dart';

/// Default implementation of [IAssetProvider].
///
/// Manages fonts, images, and other assets referenced by themes.
class AssetManager implements IAssetProvider {
  @override
  String? resolveUri(String assetPath) {
    throw UnimplementedError('AssetManager.resolveUri');
  }

  @override
  Future<bool> exists(String path) {
    throw UnimplementedError('AssetManager.exists');
  }

  @override
  Future<List<int>> readImageBytes(String path) {
    throw UnimplementedError('AssetManager.readImageBytes');
  }

  @override
  Future<List<int>> readFontBytes(String path) {
    throw UnimplementedError('AssetManager.readFontBytes');
  }

  @override
  Future<int> fileSize(String path) {
    throw UnimplementedError('AssetManager.fileSize');
  }

  @override
  Future<DateTime?> lastModified(String path) {
    throw UnimplementedError('AssetManager.lastModified');
  }
}
