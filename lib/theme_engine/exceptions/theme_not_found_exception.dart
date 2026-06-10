/// Exception thrown when a requested theme ID is not found.
class ThemeNotFoundException implements Exception {
  /// Creates a [ThemeNotFoundException] with an optional [message]
  /// and the [themeId] that was not found.
  const ThemeNotFoundException([
    this.message,
    this.themeId,
  ]);

  /// A human-readable description of the error.
  final String? message;

  /// The theme identifier that could not be located.
  final String? themeId;

  @override
  String toString() {
    final buf = StringBuffer('ThemeNotFoundException');
    if (themeId != null) buf.write(' for "$themeId"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
