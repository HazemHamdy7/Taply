/// Exception thrown when a required asset (image, font, etc.) is not found.
class AssetNotFoundException implements Exception {
  /// Creates an [AssetNotFoundException] with an optional [message]
  /// and the [assetKey] that was not found.
  const AssetNotFoundException([
    this.message,
    this.assetKey,
  ]);

  /// A human-readable description of the error.
  final String? message;

  /// The identifier or path of the missing asset.
  final String? assetKey;

  @override
  String toString() {
    final buf = StringBuffer('AssetNotFoundException');
    if (assetKey != null) buf.write(' for "$assetKey"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
