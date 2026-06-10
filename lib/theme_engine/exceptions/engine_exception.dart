/// Generic exception thrown by the ThemeEngine for unrecoverable errors.
class EngineException implements Exception {
  /// Creates an [EngineException] with an optional [message] and [code].
  const EngineException([
    this.message,
    this.code,
  ]);

  /// A human-readable description of the error.
  final String? message;

  /// An optional error code for programmatic handling.
  final String? code;

  @override
  String toString() {
    final buf = StringBuffer('EngineException');
    if (code != null) buf.write('[$code]');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
