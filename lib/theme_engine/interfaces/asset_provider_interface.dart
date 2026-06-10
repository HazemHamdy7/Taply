/// Interface for asset providers (images, fonts, etc.).
abstract class IAssetProvider {
  /// Resolves an asset path to a full URI.
  String? resolveUri(String assetPath);

  /// Returns `true` if the asset at [path] exists.
  Future<bool> exists(String path);

  /// Reads the bytes of an image asset at [path].
  Future<List<int>> readImageBytes(String path);

  /// Reads the bytes of a font asset at [path].
  Future<List<int>> readFontBytes(String path);

  /// Returns the file size of the asset at [path] in bytes.
  Future<int> fileSize(String path);

  /// Returns the last modified timestamp for the asset, or `null`.
  Future<DateTime?> lastModified(String path);
}
