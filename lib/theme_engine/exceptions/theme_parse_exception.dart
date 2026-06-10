/// Exception thrown when theme JSON parsing fails.
class ThemeParseException implements Exception {
  /// Creates a [ThemeParseException] with an optional [message] and [sourceKey].
  const ThemeParseException([
    this.message,
    this.sourceKey,
  ]);

  /// A human-readable description of the parse error.
  final String? message;

  /// The JSON key or source identifier that caused the failure.
  final String? sourceKey;

  @override
  String toString() {
    final buf = StringBuffer('ThemeParseException');
    if (sourceKey != null) buf.write(' at key "$sourceKey"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
