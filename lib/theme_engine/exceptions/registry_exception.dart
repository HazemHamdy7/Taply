/// Exception thrown when a registry operation fails (e.g., duplicate or
/// unregistered type).
class RegistryException implements Exception {
  /// Creates a [RegistryException] with an optional [message]
  /// and the [typeKey] involved in the failure.
  const RegistryException([
    this.message,
    this.typeKey,
  ]);

  /// A human-readable description of the registry error.
  final String? message;

  /// The type key that caused the failure.
  final String? typeKey;

  @override
  String toString() {
    final buf = StringBuffer('RegistryException');
    if (typeKey != null) buf.write(' for "$typeKey"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
