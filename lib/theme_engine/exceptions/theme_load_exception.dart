/// Exception thrown when a theme cannot be loaded from its source.
class ThemeLoadException implements Exception {
  /// Creates a [ThemeLoadException] with an optional [message] and [sourceUri].
  const ThemeLoadException([
    this.message,
    this.sourceUri,
  ]);

  /// A human-readable description of the load error.
  final String? message;

  /// The URI or identifier of the source that failed to load.
  final String? sourceUri;

  @override
  String toString() {
    final buf = StringBuffer('ThemeLoadException');
    if (sourceUri != null) buf.write(' loading "$sourceUri"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
